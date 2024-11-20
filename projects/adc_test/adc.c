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



#define clrscr() printf("\e[1;1H\e[2J")

#define CMA_ALLOC _IOWR('Z', 0, uint32_t)
#define N 50000 //900000 //N 4194304

int interrupted = 0;

void signal_handler(int sig) {
  interrupted = 1;
}

int main () {
  int fd, sock_server, sock_client;
  int position, limit, offset;
  volatile uint32_t *rx_addr, *rx_cntr, *triggered_when;
  volatile int32_t *adc_abs_max, *triggered_by;

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
  rx_rst        = (uint8_t *)(cfg + 0);   //[0 bit shifted]
  rx_rate       = (uint16_t *)(cfg + 2);  //[16 bit shift]
  rx_addr       = (uint32_t *)(cfg + 4);  //32 bit shifted
  trg_value     = (uint16_t *)(cfg + 8);  //16 bit for mod(ADC1+ADC2) trigger value

  rx_cntr       = (uint32_t *)(sts + 0);
  adc_abs_max   = (int32_t *)(sts + 4);
  triggered_by  = (int32_t *)(sts + 8);
  triggered_when  = (int32_t *)(sts + 12);

  uint16_t trg = 300;

  *trg_value = trg;
  *rx_addr = size;


  while(!interrupted) {

    usleep(30000);
    usleep(30000);
    usleep(30000);
    usleep(30000);
    

        //clrscr();
        printf("CLEAN\n");

    printf("RESET\n"); 
    /* enter reset mode */
    *rx_rst &= ~1;    //сброс первого бита в 0
    usleep(100);
    *rx_rst &= ~2;
    /* set default sample rate */
    
    *rx_rate = 29;

    signal(SIGINT, signal_handler);

    /* enter normal operating mode */
    *rx_rst |= 2; //установка второго бита в 1 (axis writer)
    usleep(100);
    *rx_rst |= 1;  //установка первого бита в 1 (дециматор и другие)


    limit = 32*1024;


    printf("CONSOLE WAIT TRIGGER > %u...\n", trg);
    int32_t cur_adc_abs_max;
    int32_t triggered_by_val;
    uint32_t triggered_when_val;
    cur_adc_abs_max = *adc_abs_max;
    printf("TRIGGER %d\n", cur_adc_abs_max); 
  

    while(!interrupted) {

      if (cur_adc_abs_max < *adc_abs_max){
        cur_adc_abs_max = *adc_abs_max;
        printf("TRIGGER %d\n", cur_adc_abs_max); 
      }

      /* read ram writer position */
      position = *rx_cntr;

      /* send 4 MB if ready, otherwise sleep 1 ms */
      if((limit > 0 && position > limit) || (limit == 0 && position < 32*1024)) {
        offset = limit > 0 ? 0 : 4096*1024;
        limit = limit > 0 ? 0 : 32*1024;

        uint16_t *buffer = (uint16_t *)(ram + offset);

        /* обработаем данные в структуру */

        triggered_by_val = *triggered_by;
        triggered_when_val = *triggered_when;
        printf("TRIGGEREDBY %d at %u SMP\n", triggered_by_val, triggered_when_val);

        //SAVE TO FILE
        //char filename[40];
        //struct tm *timenow;

        //time_t now = time(NULL);
        //timenow = gmtime(&now);

        //strftime(filename, sizeof(filename), "%Y-%m-%d_%H:%M:%S.txt", timenow);

        //FILE *fp = fopen(filename, "w");

          for(uint32_t i = 0; i < N; i += 1) {
            int16_t adc    = (int16_t)buffer[i];
						//fprintf(fp, "%i %d\n", i, adc);
            printf("D %i %d\n", i, adc);
          }

				//fclose(fp);

        printf("DRAW\n");
        //interrupted = 1;

        break; //exit while to wait new trigger

      }
      else
      {
        usleep(100);
      }
    }

    signal(SIGINT, SIG_DFL);
  }

  /* enter reset mode */
  *rx_rst &= ~1;
  usleep(100);
  *rx_rst &= ~2;

  return EXIT_SUCCESS;
}



