#define _POSIX_C_SOURCE 199309L
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sched.h>
#include <fcntl.h>
#include <math.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <time.h>
#include "xadc_temp.h"

#define BILLION  1000000000L;

#define clrscr() printf("\e[1;1H\e[2J")

#define CMA_ALLOC _IOWR('Z', 0, uint32_t)
#define N 30000 //900000 //N 4194304

int interrupted = 0;

void signal_handler(int sig) {
  interrupted = 1;
}

int main () {

  struct timespec start, stop;       //Для хранения засечек времени с целью измерить время выполнения операции

  int fd;

  //Для работы с памятью
  uint64_t position = 0;
  uint64_t prev_position = 0;
  int limit, offset;

  volatile uint16_t *trigger_activated, *triggers_count;
  volatile uint32_t *rx_addr, *rx_cntr;
  volatile uint16_t *adc_abs_max, *cur_adc;
  volatile uint32_t *adc_sent;
  volatile uint64_t *last_detrigged, *first_trgged, *samples_count;

  volatile uint16_t *rx_rate, *trg_value;
  volatile uint8_t *rx_rst;
  volatile void *cfg, *sts, *ram;
  
  cpu_set_t mask;
  struct sched_param param;
  uint32_t size;

  memset(&param, 0, sizeof(param));

  //Процесс привязывается к CPU 1 с максимальным приоритетом в режиме реального времени (SCHED_FIFO)
  param.sched_priority = sched_get_priority_max(SCHED_FIFO);
  sched_setscheduler(0, SCHED_FIFO, &param);

  CPU_ZERO(&mask);
  CPU_SET(1, &mask);
  sched_setaffinity(0, sizeof(cpu_set_t), &mask);

  if((fd = open("/dev/mem", O_RDWR)) < 0)
  {
    perror("open");
    return EXIT_FAILURE;
  }

  cfg = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40000000);
  sts = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x41000000);

  close(fd);

  if((fd = open("/dev/cma", O_RDWR)) < 0)
  {
    perror("open");
    return EXIT_FAILURE;
  }

  size = 2*2048*sysconf(_SC_PAGESIZE);    //sysconf(_SC_PAGESIZE) на Zynq под Linux обычно = 4096 байт (4 КБ). Т.е. 2x8 МБ памяти

  
  if (ioctl(fd, CMA_ALLOC, &size) < 0) {    //в size возвращается физ адрес
    perror("ioctl CMA_ALLOC failed");
    return EXIT_FAILURE;
  }

  uint32_t physical_address = (uint32_t)size;   // вот он, адрес от драйвера

  ram = mmap(NULL, 2*2048*sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);

  /* В ПЛИСе
  cfg_data 160 bit в axi_hub_modified_0 - передача конфигурационных данных
  SLICE0: 0...0 (1 bit) -> ADC_1.areset   -   брасывает ADC, axis_dwidth_converter_0, decimator
  SLICE1: 1...1 (1 bit) -> writer_0.areset  - сбрасывает блок writer_0, который пишет в шину axi
  SLICE6: 2...2 (1 bit) -> ADC_1.reset_trigger  - сбрасывает триггер, если он сработал
  SLICE7: 3...3 (1 bit) -> ADC_1.reset_max_sum  - при подаче 1 на вход сбрасывает максимум, определенны для суммы входов АЦП в ходе работы
  

  SLICE2: 31...16 (16 bit) -> axis_decimator_0.cfg_data  - настройка децимации ? Направление битов меняется?
  SLICE3: 63....32 (32 bit) -> writer_0.min_addr         - указывает скакого физического адреса начинать писать в память ? Направление битов меняется?
  SLICE6: 79...64 (16 bit) -> ADC_1.trigger_level (16 bit)      <------------------ Все правильно Начиная с 64го бита + 16 бит дает 80. Но указывается конец с -1, сечет же с 0го бита. Потому 79
  
  sta_data через xlconcat_0
  31:0 <- ADC_1.max_sum_out (16 bit)
  31:0 <- ADC_1.triggered_by_out (16 bit)
  31:0 <- ADC_1.triggered_when (32 bit)
  31:0 <- writer_0.sts_data (16 bit)
  */

  //+1 означает сдвиг на 8 бит, т.к. указатели 8 бит => 64 bit address shift is 64/8 = 8
  rx_rst          = (uint8_t *)(cfg + 0);   //[0 bit shifted]   //Набор битов сброса IP блоков ПЛИС 0й - ADC_1, 1й - axis writer, 2 - флаг превышения триггера у ADC_1, 3 - сброс максимума суммы значений по каналам АЦП
  rx_rate         = (uint16_t *)(cfg + 2);  //[16 bit shift]    //Децимация
  rx_addr         = (uint32_t *)(cfg + 4);  //32 bit shifted    //Начальный адрес буфера памяти
  trg_value       = (uint16_t *)(cfg + 8);  //16 bit for mod(ADC1+ADC2) trigger value

  rx_cntr         = (uint32_t *)(sts + 0);    //через rx_cntr writer0 блок сообщает программе сколько данных он записал в память
  adc_abs_max     = (uint16_t *)(sts + 4);    //Максимальное значение после сброса, для самокалибровки триггера
  cur_adc         = (uint16_t *)(sts + 6);    //Значение сейчас
  last_detrigged  = (uint64_t *)(sts + 8);   //Последний раз caкогда переходили триггер вниз, в семплах
  first_trgged    = (uint64_t *)(sts + 16);   //Когда сработал триггер, в семплах
  adc_sent        = (uint32_t *)(sts + 24);   //Число отправленных отсчетов из блока АЦП
  trigger_activated = (uint16_t *)(sts + 28); //1 бит состояния переменной в IP
  triggers_count  = (uint16_t *)(sts + 30);
  samples_count   = (uint64_t *)(sts + 32); //Счетчик семплов (всех)
  

  //Запись в память счетчик номера семпла + значение АЦП
#pragma pack(push, 1)   // выравнивание по 1 байту
struct record {
    uint16_t marker;       // 16 бит (2 байта, например 0xA1B2)
    uint16_t sum_abs;      // 16 бит (2 байта)
    int16_t adc_b;        // 16 бит (2 байта, signed)
    int16_t adc_a;        // 16 бит (2 байта, signed)
    uint64_t counter;      // 64 бита (8 байт)
};
#pragma pack(pop)


  uint16_t trg    = 5;

  *trg_value      = trg;
  *rx_addr        = physical_address;   //начальный адрес записи У CMA GP0 это 0x8000_0000, у HP0 это 0x0000_0000

  uint32_t adc_sent_val;
  uint64_t first_trgged_val, last_detrigged_val, samples_count_val;
  uint16_t trigger_activated_val, triggers_count_val, cur_adc_val, adc_abs_max_val;

  char outbuf[4500];  //Print to

  double temp = 0;

  while(!interrupted) {

    usleep(30000);


    //clrscr();
    printf("CLEAN\n");

    printf("RESET\n"); 
    
    *rx_rst &= ~1;    //сброс первого бита в 0
    usleep(100);
    *rx_rst &= ~2;
    /* set default sample rate */
    
    *rx_rate = 1;    //Дециматор. Ранее стояло 29  ЕСЛИ СТОИТ 4, то будет передаваться каждый 5й отсчет, 9 -> каждый 10й, 1-каждй 2й

    signal(SIGINT, signal_handler);

    /* enter normal operating mode */
    *rx_rst |= 2; //установка второго бита в 1 (axis writer)
    usleep(100);
    *rx_rst |= 1;  //установка первого бита в 1 (дециматор и другие)


    usleep(20);
    // Сброс триггера
    *rx_rst |= (1 << 2);  // ADC_1.reset_trigger
    usleep(20);
    *rx_rst &= ~(1 << 2); 


    // Включаем writer и ADC
    *rx_rst |= 2;  // writer
    usleep(20);
    *rx_rst |= 1;  // ADC


    printf("CONSOLE WAIT TRIGGER > %u...\n", trg);

//    snprintf(outbuf, sizeof(outbuf), "VALUES:\n");

    while(!interrupted) {
      adc_abs_max_val         = *adc_abs_max;
      first_trgged_val        = *first_trgged;
      last_detrigged_val      = *last_detrigged;
      adc_sent_val            = *adc_sent;
      trigger_activated_val   = *trigger_activated;
      triggers_count_val      = *triggers_count;
      cur_adc_val             = *cur_adc;
      samples_count_val       = *samples_count;
      
      /* read ram writer position */
      prev_position = position;
      position      = *rx_cntr;

      if (adc_abs_max_val < *adc_abs_max) 
        adc_abs_max_val = *adc_abs_max;

      clrscr();

      first_trgged_val    = *first_trgged;
      last_detrigged_val  = *last_detrigged;

      printf("CMA buffer physical address: 0x%08X\n", physical_address);
      printf("Запись в памяти POS %llu\n", position);
      printf("Сдвиг по записям D_POS \033[0;31m%i\033[0m\n", (unsigned int)(position - prev_position));
      printf("TRGS_COUNT %i\n", triggers_count_val);
      printf("first_trgged_val %ju (0x%jx)\n", first_trgged_val, first_trgged_val);        
      printf("last_detrigged_val %ju (0x%jx)\n", last_detrigged_val, last_detrigged_val);
      
      double_t pulse_len       = (double_t)(last_detrigged_val-first_trgged_val)/125000.0;
      printf("Длительность импульсв, мс, PULSE_LEN %f\n", pulse_len);
      printf("ADC (MAX/NOW)= %i/%i ед. АЦП\n", adc_abs_max_val, cur_adc_val);
      printf("Отправлено в память семлов, ADC_SENT_VAL %i\n", adc_sent_val);
      printf("TRG_ACTIVE %i\n", trigger_activated_val);

      double_t samples_time       = (double_t)(samples_count_val)/125000000.0;        
      printf("Время с начала измерения, с SAPMLES_TIME %f\n", samples_time);
      printf("Число измерений АЦП (семплов) %ju\n", samples_count_val);

      static struct timespec last_temp_time = {0, 0};
      static double cached_temp = 0.0;
      struct timespec now_time;

      clock_gettime(CLOCK_MONOTONIC, &now_time);
      long diff_sec = now_time.tv_sec - last_temp_time.tv_sec;
      
      if (diff_sec >= 1) {
          struct timespec t_start, t_end;
          clock_gettime(CLOCK_MONOTONIC, &t_start);

          cached_temp = read_temperature();
          clock_gettime(CLOCK_MONOTONIC, &t_end);
          long elapsed_us = (t_end.tv_sec - t_start.tv_sec) * 1000000L + (t_end.tv_nsec - t_start.tv_nsec) / 1000L;
          //printf("Время выполнения блока (read_temperature): %ld мкс\n", elapsed_us);
          last_temp_time = now_time;
      }
      
      if (cached_temp > 47.0) {
          printf("Температура XADC: \033[0;31m%.2f °C\033[0m\n", cached_temp);
      } else {
          printf("Температура XADC: %.2f °C\n", cached_temp);
      }

        
      if (prev_position != position) {
        uint8_t *base = (uint8_t *)ram + prev_position;
        size_t bytes = (size_t)(position - prev_position);

        if (bytes < 4) {
            printf("Мало данных (%zu байт), ждем еще.\n", bytes);            
        } else {

          //Данные приходят: 00 (счетчик сэмплов) - начало передачи, первая часть счетчика
          //                 01 - вторая часть счетчика
          //                 10 - АЦП 1 + АЦП 2 (должны пролезать все семплы на 125 МГЦ)
          //                 0

          size_t nwords = bytes / 4; // количество 32-битных слов
          uint32_t *buf32 = (uint32_t *)base;

          // структура события (динамически выделяем по числу слов, будет достаточно)
          typedef struct {
              uint64_t counter;
              uint16_t adc_a;   // 15-bit packed -> store in 16
              uint16_t adc_b;   // 15-bit packed -> store in 16
              uint8_t  end_flag;
          } event_t;

          event_t *events = (event_t *)calloc(nwords, sizeof(event_t));
          if (!events) {


              perror("calloc events");
              exit(1);
          }
          size_t ev_count = 0;

          // временные переменные для сборки счётчика
          uint32_t counter_low = 0;
          uint32_t counter_high = 0;
          int have_counter_low = 0;
          int have_counter_high = 0;
          uint64_t current_counter = 0;

          for (size_t i = 0; i < nwords; ++i) {
              uint32_t word = buf32[i];
              uint8_t type = (word >> 30) & 0x3;
              uint32_t payload = word & 0x3FFFFFFF; // 30 бит полезной нагрузки

              switch (type) {
                  case 0x0: // 00 - младшие 30 бит счетчика
                      counter_low = payload & 0x3FFFFFFF;
                      have_counter_low = 1;
                      if (have_counter_high) {
                          current_counter = ((uint64_t)counter_high << 30) | (uint64_t)counter_low;
                      } else {
                          current_counter = (uint64_t)counter_low;
                      }
                      break;
                  case 0x1: // 01 - старшие 30 бит счетчика
                      counter_high = payload & 0x3FFFFFFF;
                      have_counter_high = 1;
                      if (have_counter_low) {
                          current_counter = ((uint64_t)counter_high << 30) | (uint64_t)counter_low;
                      } else {
                          current_counter = ((uint64_t)counter_high << 30);
                      }
                      break;
                  case 0x2: { // 10 - данные АЦП (a_u15 (15b) | b_u15 (15b))
                      uint16_t a_u15 = (uint16_t)((payload >> 15) & 0x7FFF);
                      uint16_t b_u15 = (uint16_t)(payload & 0x7FFF);
                      // запишем событие (используем текущий собранный counter)
                      if (ev_count < nwords) {
                          events[ev_count].counter = current_counter;
                          events[ev_count].adc_a = a_u15;
                          events[ev_count].adc_b = b_u15;
                          events[ev_count].end_flag = 0;
                          ev_count++;
                      }
                      break;
                  }
                  case 0x3: // 11 - окончание серии
                      if (ev_count < nwords) {
                          events[ev_count].counter = current_counter;
                          events[ev_count].adc_a = 0;
                          events[ev_count].adc_b = 0;
                          events[ev_count].end_flag = 1;
                          ev_count++;
                      }
                      // при окончании можно очистить текущий counter или оставить, в зависимости от логики
                      break;
                  default:
                      break;
              }
          }

          // Печать таблицы (как раньше — первые 15 событий)
          printf("Idx  | Counter            | Dcnt    | ADC_A  | ADC_B  | End\n");
          printf("-----+--------------------+---------+--------+--------+----\n");
          for (size_t i = 0; i < ev_count && i < 25; ++i) {
              uint64_t counter = events[i].counter;
              uint64_t prev_counter = (i == 0) ? 0 : events[i-1].counter;
              long dcnt = (i == 0) ? 0 : (long)(counter - prev_counter);
              int adc_a = (int)events[i].adc_a;
              int adc_b = (int)events[i].adc_b;
              int endf = events[i].end_flag;
              printf("%3zu | %18llu | %7ld | %6d | %6d |  %d\n",
                  i, (unsigned long long)counter, dcnt, adc_a, adc_b, endf);
          }

          // Дополнительно вывести общее число разобранных событий
          printf("\nTotal events parsed from block: %zu (words=%zu bytes=%zu)\n", ev_count, nwords, bytes);

          // Очистка
          free(events);

          //snprintf(outbuf+strlen(outbuf), sizeof(outbuf)-strlen(outbuf), "END OF PORTION----\n");    

          printf("%s\n", outbuf);
          exit (0);
        
          usleep(350000);

        }

      }   //(prev_position != position)
      else {
        printf("%s\n", outbuf);    
        usleep(150000);
      }
      

    } //Окончание цикла ожидания сигнала прерывания по CTRL-D #2

    signal(SIGINT, SIG_DFL);
  } //Окончание цикла ожидания сигнала прерывания по CTRL-D

  /* enter reset mode */
  *rx_rst &= ~1;
  usleep(500);
  *rx_rst &= ~2;


  return EXIT_SUCCESS;
}




/*
#define _POSIX_C_SOURCE 199309L
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sched.h>
#include <fcntl.h>
#include <math.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <time.h>
#include "xadc_temp.h"

#define BILLION  1000000000L;

#define clrscr() printf("\e[1;1H\e[2J")

#define CMA_ALLOC _IOWR('Z', 0, uint32_t)
#define N 30000 //900000 //N 4194304

int interrupted = 0;



void signal_handler(int sig) {
  interrupted = 1;
}

int main () {

  struct timespec start, stop;       //Для хранения засечек времени с целью измерить время выполнения операции

  int fd;

  //Для работы с памятью
  uint64_t position = 0;
  uint64_t prev_position = 0;
  int limit, offset;

  volatile uint16_t *trigger_activated, *triggers_count;
  volatile uint32_t *rx_addr, *rx_cntr;
  volatile uint16_t *adc_abs_max, *cur_adc;
  volatile uint32_t *adc_sent;
  volatile uint64_t *last_detrigged, *first_trgged, *samples_count;

  volatile uint16_t *rx_rate, *trg_value;
  volatile uint8_t *rx_rst;
  volatile void *cfg, *sts, *ram;
  
  cpu_set_t mask;
  struct sched_param param;
  uint32_t size;



  memset(&param, 0, sizeof(param));

  //Процесс привязывается к CPU 1 с максимальным приоритетом в режиме реального времени (SCHED_FIFO)
  param.sched_priority = sched_get_priority_max(SCHED_FIFO);
  sched_setscheduler(0, SCHED_FIFO, &param);

  CPU_ZERO(&mask);
  CPU_SET(1, &mask);
  sched_setaffinity(0, sizeof(cpu_set_t), &mask);

  if((fd = open("/dev/mem", O_RDWR)) < 0)
  {
    perror("open");
    return EXIT_FAILURE;
  }

  cfg = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40000000);
  sts = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x41000000);

  close(fd);

  if((fd = open("/dev/cma", O_RDWR)) < 0)
  {
    perror("open");
    return EXIT_FAILURE;
  }

  size = 2*2048*sysconf(_SC_PAGESIZE);    //sysconf(_SC_PAGESIZE) на Zynq под Linux обычно = 4096 байт (4 КБ). Т.е. 2x8 МБ памяти

  
  if (ioctl(fd, CMA_ALLOC, &size) < 0) {    //в size возвращается физ адрес
    perror("ioctl CMA_ALLOC failed");
    return EXIT_FAILURE;
  }

  uint32_t physical_address = (uint32_t)size;   // вот он, адрес от драйвера

  ram = mmap(NULL, 2*2048*sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);

  // В ПЛИСе
  //cfg_data 160 bit в axi_hub_modified_0 - передача конфигурационных данных
  //SLICE0: 0...0 (1 bit) -> ADC_1.areset   -   брасывает ADC, axis_dwidth_converter_0, decimator
  //SLICE1: 1...1 (1 bit) -> writer_0.areset  - сбрасывает блок writer_0, который пишет в шину axi
  //SLICE6: 2...2 (1 bit) -> ADC_1.reset_trigger  - сбрасывает триггер, если он сработал
  //SLICE7: 3...3 (1 bit) -> ADC_1.reset_max_sum  - при подаче 1 на вход сбрасывает максимум, определенны для суммы входов АЦП в ходе работы
  

  //SLICE2: 31...16 (16 bit) -> axis_decimator_0.cfg_data  - настройка децимации ? Направление битов меняется?
  //SLICE3: 63....32 (32 bit) -> writer_0.min_addr         - указывает скакого физического адреса начинать писать в память ? Направление битов меняется?
  //SLICE6: 79...64 (16 bit) -> ADC_1.trigger_level (16 bit)      <------------------ Все правильно Начиная с 64го бита + 16 бит дает 80. Но указывается конец с -1, сечет же с 0го бита. Потому 79
  
  //sta_data через xlconcat_0
  //31:0 <- ADC_1.max_sum_out (16 bit)
  //31:0 <- ADC_1.triggered_by_out (16 bit)
  //31:0 <- ADC_1.triggered_when (32 bit)
  //31:0 <- writer_0.sts_data (16 bit)
  

  //+1 означает сдвиг на 8 бит, т.к. указатели 8 бит => 64 bit address shift is 64/8 = 8
  rx_rst          = (uint8_t *)(cfg + 0);   //[0 bit shifted]   //Набор битов сброса IP блоков ПЛИС 0й - ADC_1, 1й - axis writer, 2 - флаг превышения триггера у ADC_1, 3 - сброс максимума суммы значений по каналам АЦП
  rx_rate         = (uint16_t *)(cfg + 2);  //[16 bit shift]    //Децимация
  rx_addr         = (uint32_t *)(cfg + 4);  //32 bit shifted    //Начальный адрес буфера памяти
  trg_value       = (uint16_t *)(cfg + 8);  //16 bit for mod(ADC1+ADC2) trigger value

  rx_cntr         = (uint32_t *)(sts + 0);    //через rx_cntr writer0 блок сообщает программе сколько данных он записал в память
  adc_abs_max     = (uint16_t *)(sts + 4);    //Максимальное значение после сброса, для самокалибровки триггера
  cur_adc         = (uint16_t *)(sts + 6);    //Значение сейчас
  last_detrigged  = (uint64_t *)(sts + 8);   //Последний раз caкогда переходили тригер вниз, в семплах
  first_trgged    = (uint64_t *)(sts + 16);   //Когда сработал тригер, в семплах
  adc_sent        = (uint32_t *)(sts + 24);   //Число отправленных отсчетов из блока АЦП
  trigger_activated = (uint16_t *)(sts + 28); //1 бит состояния переменной в IP
  triggers_count  = (uint16_t *)(sts + 30);
  samples_count   = (uint64_t *)(sts + 32); //Счетчик семплов (всех)
  

  //Запись в память счетчик номера семпла + значение АЦП
#pragma pack(push, 1)   // выравнивание по 1 байту
struct record {
    uint16_t marker;       // 16 бит (2 байта, например 0xA1B2)
    uint16_t sum_abs;      // 16 бит (2 байта)
    int16_t adc_b;        // 16 бит (2 байта, signed)
    int16_t adc_a;        // 16 бит (2 байта, signed)
    uint64_t counter;      // 64 бита (8 байт)
};
#pragma pack(pop)


  uint16_t trg    = 5;

  *trg_value      = trg;
  *rx_addr        = physical_address;   //начальный адрес записи У CMA GP0 это 0x8000_0000, у HP0 это 0x0000_0000

  uint32_t adc_sent_val;
  uint64_t first_trgged_val, last_detrigged_val, samples_count_val;
  uint16_t trigger_activated_val, triggers_count_val, cur_adc_val, adc_abs_max_val;

  char outbuf[4500];  //Print to

  double temp = 0;

  while(!interrupted) {

    usleep(30000);


    //clrscr();
    printf("CLEAN\n");

    printf("RESET\n"); 
    
    *rx_rst &= ~1;    //сброс первого бита в 0
    usleep(100);
    *rx_rst &= ~2;
    // set default sample rate
    
    *rx_rate = 1;    //Дециматор. Ранее стояло 29  ЕСЛИ СТОИТ 4, то будет передаваться каждый 5й отсчет, 9 -> каждый 10й, 1-каждй 2й

    signal(SIGINT, signal_handler);

    // enter normal operating mode 
    *rx_rst |= 2; //установка второго бита в 1 (axis writer)
    usleep(100);
    *rx_rst |= 1;  //установка первого бита в 1 (дециматор и другие)


usleep(20);
// Сброс триггера
*rx_rst |= (1 << 2);  // ADC_1.reset_trigger
usleep(20);
*rx_rst &= ~(1 << 2); 


// Включаем writer и ADC
*rx_rst |= 2;  // writer
usleep(20);
*rx_rst |= 1;  // ADC


    printf("CONSOLE WAIT TRIGGER > %u...\n", trg);

//    snprintf(outbuf, sizeof(outbuf), "VALUES:\n");

    while(!interrupted) {
      adc_abs_max_val         = *adc_abs_max;
      first_trgged_val        = *first_trgged;
      last_detrigged_val      = *last_detrigged;
      adc_sent_val            = *adc_sent;
      trigger_activated_val   = *trigger_activated;
      triggers_count_val      = *triggers_count;
      cur_adc_val             = *cur_adc;
      samples_count_val       = *samples_count;
      
      // read ram writer position
      prev_position = position;
      position      = *rx_cntr;

      

        if (adc_abs_max_val < *adc_abs_max) 
          adc_abs_max_val = *adc_abs_max;

      
        //if( clock_gettime( CLOCK_REALTIME, &stop) == -1 ) {
        //      perror( "clock gettime" );
        //      return EXIT_FAILURE;
        //}

        //if (stop.tv_sec - start.tv_sec >= 0 && stop.tv_nsec - start.tv_nsec > 100000) {
        clrscr();

        //printf("%li sec and %li ns\n", stop.tv_sec - start.tv_sec, stop.tv_nsec - start.tv_nsec);

        //SAVE TIME
        //if( clock_gettime( CLOCK_REALTIME, &start) == -1 ) {
        //    perror( "clock gettime" );
        //    return EXIT_FAILURE;
        //}
        
        first_trgged_val    = *first_trgged;
        last_detrigged_val  = *last_detrigged;

        printf("CMA buffer physical address: 0x%08X\n", physical_address);
        printf("Запись в памяти POS %llu\n", position);
        printf("Сдвиг по записям D_POS \033[0;31m%i\033[0m\n", (unsigned int)(position - prev_position));
        printf("TRGS_COUNT %i\n", triggers_count_val);
        printf("first_trgged_val %ju (0x%jx)\n", first_trgged_val, first_trgged_val);        
        printf("last_detrigged_val %ju (0x%jx)\n", last_detrigged_val, last_detrigged_val);
        
        double_t pulse_len       = (double_t)(last_detrigged_val-first_trgged_val)/125000.0;
        printf("Длительность импульсв, мс, PULSE_LEN %f\n", pulse_len);
        printf("ADC (MAX/NOW)= %i/%i ед. АЦП\n", adc_abs_max_val, cur_adc_val);
        printf("Отправлено в память семлов, ADC_SENT_VAL %i\n", adc_sent_val);
        printf("TRG_ACTIVE %i\n", trigger_activated_val);


        double_t samples_time       = (double_t)(samples_count_val)/125000000.0;        
        printf("Время с начала измерения, с SAPMLES_TIME %f\n", samples_time);
        printf("Число измерений АЦП (семплов) %ju\n", samples_count_val);

        static struct timespec last_temp_time = {0, 0};
        static double cached_temp = 0.0;
        struct timespec now_time;

        clock_gettime(CLOCK_MONOTONIC, &now_time);
        long diff_sec = now_time.tv_sec - last_temp_time.tv_sec;
        
        if (diff_sec >= 1) {
            struct timespec t_start, t_end;
            clock_gettime(CLOCK_MONOTONIC, &t_start);

            cached_temp = read_temperature();
            clock_gettime(CLOCK_MONOTONIC, &t_end);
            long elapsed_us = (t_end.tv_sec - t_start.tv_sec) * 1000000L + (t_end.tv_nsec - t_start.tv_nsec) / 1000L;
            //printf("Время выполнения блока (read_temperature): %ld мкс\n", elapsed_us);
            last_temp_time = now_time;
        }
        
        if (cached_temp > 47.0) {
            printf("Температура XADC: \033[0;31m%.2f °C\033[0m\n", cached_temp);
        } else {
            printf("Температура XADC: %.2f °C\n", cached_temp);
        }

        
      if (prev_position != position) {

        //snprintf(outbuf+strlen(outbuf), sizeof(outbuf)-strlen(outbuf), "START %lu -> %lu\n", prev_position, position);
        //snprintf(outbuf+strlen(outbuf), sizeof(outbuf)-strlen(outbuf), "Position %lu -> %lu\n", prev_position, position);





        printf("DUMP + RECORDS:\n");

        uint8_t *base = (uint8_t *)ram + prev_position;
        struct record *buffer = (struct record *)base;
        int i;
        



        // Вывод 3 записей
        printf("Idx  | Counter     | Dcnt    | ADC_A | ADC_B | SUM_ABS |  ABS_A+B | Marker\n");
        printf("-----+------------+------+-------+-------+--------+---------+--------\n");
        for (i = 0; i < 15; i++) {
            unsigned long counter = (unsigned long)buffer[i].counter;
            unsigned long prev_counter = (i == 0) ? 0 : (unsigned long)buffer[i-1].counter;
            int dcnt = (i == 0) ? 0 : (int)(counter - prev_counter);
            int adc_a = buffer[i].adc_a;
            int adc_b = buffer[i].adc_b;
            int sum_abs = buffer[i].sum_abs;
            int abs_sum = abs(adc_a) + abs(adc_b);
            unsigned int marker = buffer[i].marker;
            printf("%3d | %11lu | %7d | %5d | %5d | %6d | %7d | 0x%04X\n",
                i, counter, dcnt, adc_a, adc_b, sum_abs, abs_sum, marker);
        }


        snprintf(outbuf+strlen(outbuf), sizeof(outbuf)-strlen(outbuf), "END OF PORTION----\n");    

        printf("%s\n", outbuf);
        exit (0);
      
        usleep(350000);

      }   //(prev_position != position)
      else {
        printf("%s\n", outbuf);    
        usleep(150000);
      }
      

    } //Окончание цикла ожидания сигнала прерывания по CTRL-D #2

    signal(SIGINT, SIG_DFL);
  } //Окончание цикла ожидания сигнала прерывания по CTRL-D

  // enter reset mode
  *rx_rst &= ~1;
  usleep(500);
  *rx_rst &= ~2;


  return EXIT_SUCCESS;
}
*/
