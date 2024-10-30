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

#define clrscr() printf("\e[1;1H\e[2J")

#define CMA_ALLOC _IOWR('Z', 0, uint32_t)
#define N 138 //N 4194304

int interrupted = 0;

void signal_handler(int sig)
{
  interrupted = 1;
}

int main ()
{
  int fd, sock_server, sock_client;
  int position, limit, offset;
  volatile uint32_t *rx_addr, *rx_cntr;
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

  size = 2048*sysconf(_SC_PAGESIZE);

  if(ioctl(fd, CMA_ALLOC, &size) < 0)
  {
    perror("ioctl");
    return EXIT_FAILURE;
  }

  ram = mmap(NULL, 2048*sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);

  //+1 eq 8 bit => 64 bit address shift is 64/8 = 8
  rx_rst = (uint8_t *)(cfg + 0); //[0 bit shifted]
  rx_rate = (uint16_t *)(cfg + 2);  //[16 bit shift]
  rx_addr = (uint32_t *)(cfg + 4);  //32 bit shifted
  trg_value = (uint16_t *)(cfg + 8);  //16 bit for mod(ADC1+ADC2) trigger value

  rx_cntr = (uint32_t *)(sts + 0);

  uint16_t trg = 90;


  *trg_value = trg;

  *rx_addr = size;


  printf("WAIT TRIGGER >%i", trg);

  while(!interrupted)
  {
    /* enter reset mode */
    *rx_rst &= ~1;
    usleep(100);
    *rx_rst &= ~2;
    /* set default sample rate */
    *rx_rate = 40;

    signal(SIGINT, signal_handler);

    /* enter normal operating mode */
    *rx_rst |= 2;
    usleep(100);
    *rx_rst |= 1;

    limit = 32*1024;

    while(!interrupted)
    {
      /* read ram writer position */
      position = *rx_cntr;

      /* send 4 MB if ready, otherwise sleep 1 ms */
      if((limit > 0 && position > limit) || (limit == 0 && position < 32*1024))
      {
        offset = limit > 0 ? 0 : 4096*1024;
        limit = limit > 0 ? 0 : 32*1024;
        //if(send(sock_client, ram + offset, 4096*1024, MSG_NOSIGNAL) < 0) break;
        uint16_t *buffer = (uint16_t *)(ram + offset);

        /* обработаем данные в структуру */
        clrscr();
        for(uint16_t i = 0; i < N; i += 4)  // 4 16-битных числа на каждую структуру (64-бита)
        {

          // Попробуем объединить старшие и младшие 16 бит с учетом возможного порядка байтов
          /*uint32_t counter      = ((uint32_t)buffer[i+1] << 16) | (uint32_t)buffer[i]; 
          int16_t adc_valueA    = (int16_t)buffer[i+2];   // 16-битное значение производной. со знаком
          int16_t adc_valueB    = (int16_t)buffer[i+3];   // 16-битное значение АЦП

          printf("Counter (i=%4i): %16u\t dS: %5i\t Sum(Mod(ADC)): %5i\n", i, counter, adc_valueA, adc_valueB);*/

          int16_t adc    = (int16_t)buffer[i];
          printf("Counter (i=%4i): %6u\n", i, adc);
        }

      }
      else
      {
        usleep(1000);
      }
    }

    signal(SIGINT, SIG_DFL);
    close(sock_client);
  }

  /* enter reset mode */
  *rx_rst &= ~1;
  usleep(100);
  *rx_rst &= ~2;

  close(sock_server);

  return EXIT_SUCCESS;
}
