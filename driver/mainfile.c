#include "ST7789.h"
#include "otterSpiDriver.h"

//PICTURES located in images, stored as 16bit arrays of colors
// #include "otterhighres.h"
#include "../images/elmo1.h"
#include "../images/elmo2.h"
#include "../images/elmo3.h"
#include "../images/elmo4.h"

void main(){
    //Inittialize SPI by setting start to low
    spiInit();
    //Initialize ST7789 Display by sending series of startup commands
    tft_init();

    //Write 60 by 80 images scaled up by 4 to the screen, the while loop plays a gif
    while(1){
        imageToScreen(elmof1, 60, 80, 4);
        imageToScreen(elmof2, 60, 80, 4);
        imageToScreen(elmof3, 60, 80, 4);
        imageToScreen(elmof4, 60, 80, 4);
        imageToScreen(elmof3, 60, 80, 4);
        imageToScreen(elmof2, 60, 80, 4);
    }
}
    ///**********Testing Functions for Writing to Screen ************
    
    // uint16_t color = 0x0000;

    // uint16_t x = 0;
    // uint16_t y = 0;
    // uint16_t color = 0;
    // // fillScreen(0);
    // // filflRect(100, 100, 100, 100, 0xF800);

    // setAddrWindow(0, 0, 240, 320);
    // for (uint16_t i = 0; i < 120*160; i+=1){
    //     uint16_t color = otter[i]; //(uint16_t)otter[i] <<8 + otter[i+1];
    //     // color += 10;
    //     fillRect(x,y, 3, 3, color);
    //     x += 2;
    //     if (x>= 240){
    //         x = 0;
    //         y+=2;
    //     }
    // }
    // setAddrWindow(0, 0, 240, 320);
    // for (uint16_t row = 0; row<120*160; row+=120){
    //     for (uint8_t col = 0; col < 120; col+=1){
    //         uint16_t color = otter[row+col];
    //         ST7789_SPI_XFER(color);
    //         ST7789_SPI_XFER(color);
    //     }
    //     for (uint8_t col = 0; col < 120; col+=1){
    //         uint16_t color = otter[row+col];
    //         ST7789_SPI_XFER(color);
    //         ST7789_SPI_XFER(color);
    //     }
    
    // }


