#ifndef OTTER_SPI_H
#define OTTER_SPI_H
#define TFT_CS 1
#define SDCARD_CS 2
#define NONE 0

// void main();
uint16_t delay_ms(uint8_t ms);
void spiInit();
void ST7789_SPI_XFER(uint8_t data);

void spiCS(uint8_t chip);
void tftDc(uint8_t val);
#endif