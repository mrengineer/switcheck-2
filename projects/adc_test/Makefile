CC=arm-linux-gnueabihf-gcc
CFLAGS=-static -O3 -march=armv7-a -mtune=cortex-a9 -mfpu=neon -mfloat-abi=hard -D_GNU_SOURCE
LDFLAGS=-lm -lpthread

SRC=adc.c xadc_temp.c
OBJ=$(SRC:.c=.o)

all: adc

adc: $(SRC)
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) -o adc

clean:
	rm -f adc *.o
