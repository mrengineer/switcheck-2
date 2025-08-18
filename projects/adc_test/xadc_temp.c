#include "xadc_temp.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define XADC_PATH "/sys/bus/iio/devices/iio:device0"

static int64_t read_int64(const char *filename) {
    char path[256];
    FILE *f;
    int64_t val = 0;
    snprintf(path, sizeof(path), "%s/%s", XADC_PATH, filename);
    f = fopen(path, "r");
    if (!f) {
        perror(path);
        exit(EXIT_FAILURE);
    }
    if (fscanf(f, "%lld", &val) != 1) {
        fprintf(stderr, "Ошибка чтения %s\n", path);
        fclose(f);
        exit(EXIT_FAILURE);
    }
    fclose(f);
    return val;
}

double read_temperature(void) {
    int64_t off = read_int64("in_temp0_offset");
    int64_t raw = read_int64("in_temp0_raw");
    int64_t scl = read_int64("in_temp0_scale");
    return ((double)(off + raw) * (double)scl) / 1000.0;
}
