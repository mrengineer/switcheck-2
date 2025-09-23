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

// Установить бит n
#define SET_BIT(var, n)    ((var) |=  (1U << (n)))

// Сбросить бит n
#define CLEAR_BIT(var, n)  ((var) &= ~(1U << (n)))

// Инвертировать бит n
#define TOGGLE_BIT(var, n) ((var) ^=  (1U << (n)))

// Проверить бит n (вернёт 0 или 1)
#define CHECK_BIT(var, n)  (((var) >> (n)) & 1U)




#define clrscr() printf("\e[1;1H\e[2J")

#define CMA_ALLOC _IOWR('Z', 0, uint32_t)

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

  
  volatile uint32_t *rx_addr, *rx_cntr;
  volatile uint16_t *adc_abs_max, *cur_adc;
  volatile uint64_t *last_detrigged, *first_trgged, *samples_count;

  volatile uint16_t *rx_rate, *trg_value;
  volatile int16_t *bias_ch_A, *bias_ch_B;

  volatile uint8_t *limiter;
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


  бит номерация (MSB слева)       байт (cfg+N)      назначение
----------------------------------------------------------------
[159:152]  cfg[19]   резерв / будущее
[151:144]  cfg[18]   резерв / будущее
[143:136]  cfg[17]   резерв / будущее
[135:128]  cfg[16]   резерв / будущее
[127:120]  cfg[15]   резерв / будущее
[119:112]  cfg[14]   резерв / будущее
[111:104]  cfg[13]   резерв / будущее
[103:96 ]  cfg[12]   резерв / будущее
[95 :88 ]  cfg[11]   резерв / будущееbase
[87 :80 ]  cfg[10]   limiter (8 бит → limiter[7:0])
[79 :64 ]  cfg[8..9] trigger_level (16 бит → trg_value[15:0])
[63 :32 ]  cfg[4..7] rx_addr (32 бит → начальный адрес буфера)
[31 :16 ]  cfg[2..3] rx_rate (16 бит → децимация)
[15 :8  ]  cfg[1]    резерв / выравнивание
[7  :0  ]  cfg[0]    rx_rst (битовое поле сбросов)

  */

  //+1 означает сдвиг на 8 бит, т.к. указатели 8 бит => 64 bit address shift is 64/8 = 8
  rx_rst          = (uint8_t *)(cfg + 0);   //[0 bit shifted]   Набор битов сброса IP блоков 
                                                  // 0й - ПЛИС 0й - ADC_1, сброс нулем
                                                  // 1й - axis writer,  сброс нулем
                                                  // 2й - флаг превышения триггера у ADC_1,  сброс нулем
                                                  // 3й - сброс максимума суммы значений по каналам АЦП,  сброс нулем
  rx_rate         = (int16_t *)(cfg + 2);   //[16 bit shift]    //Децимация
  rx_addr         = (uint32_t *)(cfg + 4);  //32 bit shifted    //Начальный адрес буфера памяти
  trg_value       = (uint16_t *)(cfg + 8);  //16 bit for mod(ADC1+ADC2) trigger value
  limiter         = (uint8_t *)(cfg + 10);  //максимальное число семплов на серию (ограничение. степень 2)

  bias_ch_A       = (int16_t *)(cfg + 12); //16 bit for bias_ch_A
  bias_ch_B       = (int16_t *)(cfg + 14); //16 bit

  // 160 бит = 20 байт



  rx_cntr         = (uint32_t *)(sts + 0);    //через rx_cntr writer0 блок сообщает программе сколько данных он записал в память
  adc_abs_max     = (uint16_t *)(sts + 4);    //Максимальное значение после сброса, для самокалибровки триггера
  cur_adc         = (uint16_t *)(sts + 6);    //Значение сейчас
  last_detrigged  = (uint64_t *)(sts + 8);   //Последний раз когда переходили триггер вниз, в семплах
  first_trgged    = (uint64_t *)(sts + 16);   //Когда сработал триггер, в семплах


  samples_count   = (uint64_t *)(sts + 32); //Счетчик семплов (всех)
  

  // строгое соответствие выравниванию в железе
  #pragma pack(push, 1)
  typedef struct {
      uint32_t rx_cntr;            // 0x00
      uint16_t adc_abs_max;        // 0x04
      uint16_t cur_adc;            // 0x06
      uint64_t last_detrigged;     // 0x08
      uint64_t first_trgged;       // 0x10
      uint32_t adc_sent;           // 0x18
      uint16_t trigger_activated;  // 0x1C
      uint16_t triggers_count;     // число срабатываний триггера
      uint64_t samples_count;      // число семплов всего

      int16_t cur_adc_a;
      int16_t cur_adc_b;
  } sts_pack_t;
  #pragma pack(pop)


  volatile sts_pack_t *ssts = (volatile sts_pack_t *)sts;

  uint16_t trg    = 2000;   //Уровень срабатывания триггера (для АЦП 12 бит, максимум 4095)

  uint32_t adc_sent_val;
  uint64_t first_trgged_val, last_detrigged_val, samples_count_val;
  uint16_t trigger_activated_val, triggers_count_val, cur_adc_val, adc_abs_max_val;

  char outbuf[4500];  //Print to

  double temp = 0;

    clrscr();
    

    CLEAR_BIT(*rx_rst, 0); //сброс первого бита в 0 (сборс ацп)
    CLEAR_BIT(*rx_rst, 1); //сброс axi writer (1й  бит)

    *bias_ch_A = -140;
    *bias_ch_B = -105;

    *trg_value      = trg;
    *limiter        = 16;   //максимальное число семплов на серию (ограничение. степень 2) 2^1 = 2 2^2 = 4 2^3 = 8
    *rx_addr        = physical_address;   //начальный адрес записи У CMA GP0 это 0x8000_0000, у HP0 это 0x0000_0000    

    *rx_rate = 1;    //Дециматор. Ранее стояло 29  ЕСЛИ СТОИТ 4, то будет передаваться каждый 5й отсчет, 9 -> каждый 10й, 1-каждй 2й

    usleep(250);

    signal(SIGINT, signal_handler);

    /* enter normal operating mode */

    SET_BIT(*rx_rst, 0); //установка 1 первого бита (отмена сборса ацп)
    SET_BIT(*rx_rst, 1); //отмена сброса axi writer (1й  бит)

    SET_BIT(*rx_rst, 3); //отмена сброса max_sum

    usleep(10);

    
    // Сброс триггера (сбрасывается лог 0!) 
    CLEAR_BIT(*rx_rst, 2);            //сброс
    usleep(20);
    SET_BIT(*rx_rst, 2);            //отмена сброса
      
    printf("CONSOLE WAIT TRIGGER > %u...\n", trg);

//    snprintf(outbuf, sizeof(outbuf), "VALUES:\n");

    usleep(60000);

    while(!interrupted) {
      adc_abs_max_val         = *adc_abs_max;
      first_trgged_val        = *first_trgged;
      last_detrigged_val      = *last_detrigged;
      cur_adc_val             = *cur_adc;
      samples_count_val       = *samples_count;
      
      /* read ram writer position */
      prev_position = position;         //В словах (32 бита)
      position      = *rx_cntr;

      if (adc_abs_max_val < *adc_abs_max) 
        adc_abs_max_val = *adc_abs_max;

      clrscr();

      first_trgged_val    = *first_trgged;
      last_detrigged_val  = *last_detrigged;

      printf("CMA buffer physical address: 0x%08X\n", physical_address);
      printf("Запись в памяти POS %llu / %llu\n", position, ssts->rx_cntr);
      printf("Сдвиг по записям D_POS \033[0;31m%i\033[0m\n", (unsigned int)(position - prev_position));
      printf("TRGS_COUNT %i / %i\n", triggers_count_val, ssts->triggers_count);
      printf("first_trgged_val %ju (0x%jx)\n", first_trgged_val, first_trgged_val);        
      printf("last_detrigged_val %ju (0x%jx)\n", last_detrigged_val, last_detrigged_val);
      
      double_t pulse_len       = (double_t)(last_detrigged_val-first_trgged_val)/125000.0;
      printf("Длительность импульсв, мс, PULSE_LEN %f\n", pulse_len);
      printf("ADC (MAX/NOW)= %i (%i)/%i ед. АЦП\n", adc_abs_max_val, cur_adc_val, ssts->adc_abs_max);
      printf("ADC A %i\n", ssts->cur_adc_a);
      printf("ADC B %i\n", ssts->cur_adc_b);
      printf("Отправлено в память семлов, ADC_SENT_VAL %i\n", ssts->adc_sent);
      printf("TRG_ACTIVE %i\n", ssts->trigger_activated);

      double_t samples_time       = (double_t)(samples_count_val)/125000000.0;
      printf("Время с начала измерения, с SAPMLES_TIME %f\n", samples_time);
      printf("Число измерений АЦП (семплов) %ju\n", ssts->samples_count);

      static struct timespec last_temp_time = {0, 0};
      static double cached_temp = 0.0;
      struct timespec now_time;

      clock_gettime(CLOCK_MONOTONIC, &now_time);
      long diff_sec = now_time.tv_sec - last_temp_time.tv_sec;
      
      if (diff_sec >= 1) {
          struct timespec t_start, t_end;
          clock_gettime(CLOCK_MONOTONIC, &t_start);

          double temp_val = read_temperature();
          clock_gettime(CLOCK_MONOTONIC, &t_end);
          long elapsed_us = (t_end.tv_sec - t_start.tv_sec) * 1000000L + (t_end.tv_nsec - t_start.tv_nsec) / 1000L;
          //printf("Время выполнения блока (read_temperature): %ld мкс\n", elapsed_us);
          if (temp_val > -60.0) {
              cached_temp = temp_val;
              last_temp_time = now_time;
          }
      }
      
      if (cached_temp > 47.0) {
          printf("Температура XADC: \033[0;31m%.2f °C\033[0m\n", cached_temp);
      } else {
          printf("Температура XADC: %.2f °C\n", cached_temp);
      }    


      if (prev_position != position) {
          usleep(10000);

          uint32_t *buf32 = (uint32_t *)ram;

          
          // формируем имя файла по текущему времени
          time_t now = time(NULL);
          struct tm *t = localtime(&now);
          char filename[128];
          strftime(filename, sizeof(filename), "/tmp/%Y-%m-%d_%H_%M_%S.csv", t);

          FILE *csv = fopen(filename, "w");
          if (!csv) {
              perror("fopen");
              close(fd);
              exit(1);
          }

          // заголовок в csv
          fprintf(csv, "Ix|Type|A|B\n");

          
          printf("Ix | Type |   A (signed)  |   B (signed)\n");
          for (int i = 0; i < 65536+4; ++i) {
              uint32_t word = buf32[i];
              uint8_t type = (word >> 30) & 0x3;
              int16_t a = (int16_t)((word >> 15) & 0x7FFF); // 15 бит
              int16_t b = (int16_t)(word & 0x7FFF);         // 15 бит
              // Преобразование 15-битного знакового числа
              if (a & 0x4000) a |= 0x8000; // sign extend
              if (b & 0x4000) b |= 0x8000; // sign extend
              //printf("%2d |  %2u  | %13d | %13d\n", i, type, a, b);
              
              fprintf(csv, "%2d|%2u|%d|%d\n", i, type, a, b);
          }

          printf("DONE\n");

          fclose(csv);
          close(fd); // закрытие дескриптора CMA
          exit(0);
        } else {
            usleep(500); 
        }
      

    } //Окончание цикла ожидания сигнала прерывания по CTRL-D #2

    signal(SIGINT, SIG_DFL);
  

  /* enter reset mode */
  *rx_rst &= ~1;
  usleep(500);
  *rx_rst &= ~2;


  return EXIT_SUCCESS;
}

