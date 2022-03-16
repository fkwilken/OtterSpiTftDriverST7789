
#include <stdint.h>
#define TFT_CS 1
#define SD_CS 2
#define NONE 0

//MEMORY MAPPED IO
//If using a custom microcontroller or anything, change these values to your own MMIO locations

//Address of SPI 8 bits of data to transfer
volatile int * SPI_TRANSMIT = 0x110E0000;
//Address telling SPI to start a transfer
volatile int * SPI_START = 0x11100000;
//Address of 8 bit data in
volatile int * SPI_RECEIVE = 0x110D0000;
//Address goes high when SPI is done transfering
volatile int * SPI_DONE = 0x110F0000;
//Address mapped to Chip Select
volatile int * SPI_CS  = 0x11110000;
//Address mapped to the Data/Control pin of the ST7789 display
volatile int * TFT_DC = 0x11120000;


uint16_t delay_ms(uint8_t ms)
{
    //50mhz OTTER, 2 cycles per instruction usually --> 25mil instructions / s, 25000 instructions/ms
    //NOTE This delay function is not accurate as it depends on the clock dividers being used, but it does create a ballpark delay for waiting for things. 
    volatile uint16_t count = 0;
    uint16_t stop = 25000 * ms;
    while (count < stop){
        count++;
    }
    return count;
}

void spiInit(){
    //Set SPI start to low rather than high impedence.
    *SPI_START = 0;
}

//NOTE - This spi transfer function is not tested for SPI input, only for output. Input is still in the works, but should work. 
void ST7789_SPI_XFER(uint8_t data){
    uint8_t done = 1;
    ///Wait as long as the last transfer was not complete
    while (done){
        done = *SPI_DONE;
    }
    //Load data
    *SPI_TRANSMIT = data;
    //Start Transfer
    *SPI_START = 1;
    //When in done state, set start low
    while (!done){
        done = *SPI_DONE;
    }
    *SPI_START = 0;
    //return *SPI_RECEIVE       //NOT TESTED but in theory should return received data, just make this function uint8_t

}
//Set CS
void spiCS(uint8_t chip)
{
    *SPI_CS = chip;
}
//Set DC
void tftDc(uint8_t val)
{
    *TFT_DC = val;
}