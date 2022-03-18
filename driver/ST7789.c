///////////////////////////////////////////////////////////////////////////
////                                                                   ////
////                              ST7789.c                             ////
////                                                                   ////
////                     ST7789 display driver rewritten in C          ////
////                                                                   ////
///////////////////////////////////////////////////////////////////////////
////                                                                   ////
////          Ported from Adafruit's Drivers by Francisco Wilken       ////
////                                                                   ////
///////////////////////////////////////////////////////////////////////////
/**************************************************************************
  This is a library for several Adafruit displays based on ST77* drivers.

  Works with the Adafruit 1.8" TFT Breakout w/SD card
    ----> http://www.adafruit.com/products/358
  The 1.8" TFT shield
    ----> https://www.adafruit.com/product/802
  The 1.44" TFT breakout
    ----> https://www.adafruit.com/product/2088
  as well as Adafruit raw 1.8" TFT display
    ----> http://www.adafruit.com/products/618

  Check out the links above for our tutorials and wiring diagrams.
  These displays use SPI to communicate, 4 or 5 pins are required to
  interface (RST is optional).

  Adafruit invests time and resources providing this open source code,
  please support Adafruit and open-source hardware by purchasing
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.
  MIT license, all text above must be included in any redistribution
 **************************************************************************/

#include <stdint.h>
#include "otterSpiDriver.h"
#ifndef bool
#define bool uint8_t
#endif

//Define ST7789 and ST77XX driver chip commands

#define ST_CMD_DELAY      0x80    // special signifier for command lists

#define ST77XX_NOP        0x00
#define ST77XX_SWRESET    0x01
#define ST77XX_RDDID      0x04
#define ST77XX_RDDST      0x09

#define ST77XX_SLPIN      0x10
#define ST77XX_SLPOUT     0x11
#define ST77XX_PTLON      0x12
#define ST77XX_NORON      0x13

#define ST77XX_INVOFF     0x20
#define ST77XX_INVON      0x21
#define ST77XX_DISPOFF    0x28
#define ST77XX_DISPON     0x29
#define ST77XX_CASET      0x2A
#define ST77XX_RASET      0x2B
#define ST77XX_RAMWR      0x2C
#define ST77XX_RAMRD      0x2E

#define ST77XX_PTLAR      0x30
#define ST77XX_COLMOD     0x3A
#define ST77XX_MADCTL     0x36

#define ST77XX_MADCTL_MY  0x80
#define ST77XX_MADCTL_MX  0x40
#define ST77XX_MADCTL_MV  0x20
#define ST77XX_MADCTL_ML  0x10
#define ST77XX_MADCTL_RGB 0x00

#define ST77XX_RDID1      0xDA
#define ST77XX_RDID2      0xDB
#define ST77XX_RDID3      0xDC
#define ST77XX_RDID4      0xDD

// Some ready-made 16-bit ('565') color settings:
#define   ST7789_BLACK   0x0000
#define   ST7789_BLUE    0x001F
#define   ST7789_RED     0xF800
#define   ST7789_GREEN   0x07E0
#define   ST7789_CYAN    0x07FF
#define   ST7789_MAGENTA 0xF81F
#define   ST7789_YELLOW  0xFFE0
#define   ST7789_WHITE   0xFFFF

// #ifndef ST7789_SPI_XFER
// #define ST7789_SPI_XFER(x) SPI_XFER(ST7789, x)
// #endif

uint16_t
  _width,     ///< Display width as modified by current rotation
  _height;    ///< Display height as modified by current rotation
 uint8_t
  _xstart,    ///< Internal framebuffer X offset
  _ystart,    ///< Internal framebuffer Y offset
  _colstart,  ///< Some displays need this changed to offset
  _rowstart,  ///< Some displays need this changed to offset
  rotation;   ///< Display rotation (0 thru 3)


#define ST7789_240x240_XSTART 0
#define ST7789_240x240_YSTART 0 //used to be 80


/**************************************************************************/
/*!
    @brief  Call before issuing command(s) or data to display. Performs
            chip-select (if required). Required
            for all display types; not an SPI-specific function.
*/
/**************************************************************************/
void startWrite(void) {
  #ifdef TFT_CS
    spiCS(TFT_CS);
  #endif
}

/**************************************************************************/
/*!
    @brief  Call after issuing command(s) or data to display. Performs
            chip-deselect (if required). Required
            for all display types; not an SPI-specific function.
*/
/**************************************************************************/
void endWrite(void) {
  #ifdef TFT_CS
    spiCS(NONE);
  #endif
}

/**************************************************************************/
/*!
    @brief  Write a single command byte to the display. Chip-select and
            transaction must have been previously set -- this ONLY sets
            the device to COMMAND mode, issues the byte and then restores
            DATA mode. There is no corresponding explicit writeData()
            function -- just use ST7789_SPI_XFER().
    @param  cmd  8-bit command to write.
*/
/**************************************************************************/
void writeCommand(uint8_t cmd) {
  tftDc(0);    //Set D/C low to indicate cmd
  ST7789_SPI_XFER(cmd);
  tftDc(1);
}


/**************************************************************************/
/*!
    @brief  Initialization code for ST7789 display
*/
/**************************************************************************/
void tft_init(void) {


  #ifdef TFT_CS
    spiCS(NONE);
  #endif
  // output_drive(TFT_DC);
  // displayInit(cmd_240x240);
  //Rewriting displayInit cuz roms dont exist in c
  startWrite();
  writeCommand(ST77XX_SWRESET);   //Reset
  delay_ms(500);
  writeCommand(ST77XX_SLPOUT);    //Sleep OFF
  delay_ms(500);
  writeCommand(ST77XX_COLMOD);    // 16 bit color mode
  ST7789_SPI_XFER(0x55);
  writeCommand(ST77XX_MADCTL);     // Memory Address Control Mode
  ST7789_SPI_XFER(0x08);
  delay_ms(10);
  writeCommand(ST77XX_INVOFF); //Invert Off
  delay_ms(10);
  writeCommand(ST77XX_NORON);    //Normal Mode on
  delay_ms(10);
  writeCommand(ST77XX_DISPON);     //Display On
  delay_ms(200);

  endWrite();



  _colstart = ST7789_240x240_XSTART;
  _rowstart = ST7789_240x240_YSTART;
  _height   = 320;
  _width    = 240;
  //Portrait Mode
  setRotation(0);
}

/**************************************************************************/
/*!
  @brief  SPI displays set an address window rectangle for blitting pixels
  @param  x  Top left corner x coordinate
  @param  y  Top left corner x coordinate
  @param  w  Width of window
  @param  h  Height of window
*/
/**************************************************************************/
void setAddrWindow(uint16_t x, uint16_t y, uint16_t w, uint16_t h) {
  // x += _xstart;
  // y += _ystart;
  // uint32_t xa = ((uint32_t)x << 16) | (x + w - 1);
  // uint32_t ya = ((uint32_t)y << 16) | (y + h - 1);
  uint16_t xe = x + w - 1;
  uint16_t ye = y + h - 1;
  writeCommand(ST77XX_CASET); // Column addr set
  ST7789_SPI_XFER(x>>8);
  ST7789_SPI_XFER(x);
  ST7789_SPI_XFER(xe>>8);
  ST7789_SPI_XFER(xe);
  


  writeCommand(ST77XX_RASET); // Row addr set
  ST7789_SPI_XFER(y>>8);
  ST7789_SPI_XFER(y);
  ST7789_SPI_XFER(ye>>8);
  ST7789_SPI_XFER(ye);

  writeCommand(ST77XX_RAMWR); // write to RAM
}

/**************************************************************************/
/*!
    @brief  Set origin of (0,0) and orientation of TFT display
    @param  m  The index for rotation, from 0-3 inclusive
*/
/**************************************************************************/
void setRotation(uint8_t m) {
  uint8_t madctl = 0;

  rotation = m & 3; // can't be higher than 3

  switch (rotation) {
   case 0:
     madctl  = ST77XX_MADCTL_MX | ST77XX_MADCTL_MY | ST77XX_MADCTL_RGB;
     _xstart = _colstart;
     _ystart = _rowstart;
     break;
   case 1:
     madctl  = ST77XX_MADCTL_MY | ST77XX_MADCTL_MV | ST77XX_MADCTL_RGB;
     _xstart = _rowstart;
     _ystart = _colstart;
     break;
  case 2:
     madctl  = ST77XX_MADCTL_RGB;
     _xstart = 0;
     _ystart = 0;
     break;
   case 3:
     madctl  = ST77XX_MADCTL_MX | ST77XX_MADCTL_MV | ST77XX_MADCTL_RGB;
     _xstart = 0;
     _ystart = 0;
     break;
  }
  startWrite();
  writeCommand(ST77XX_MADCTL);
  ST7789_SPI_XFER(madctl);
  endWrite();
}

void drawPixel(uint16_t x, uint16_t y, uint16_t color) {
  if((x < _width) && (y < _height)) {
    startWrite();
    setAddrWindow(x, y, 1, 1);
    ST7789_SPI_XFER(color >> 8);
    ST7789_SPI_XFER(color & 0xFF);
    endWrite();
  }
}

/**************************************************************************/
/*!
   @brief    Draw a perfectly horizontal line (this is often optimized in a subclass!)
    @param    x   Left-most x coordinate
    @param    y   Left-most y coordinate
    @param    w   Width in pixels
   @param    color 16-bit 5-6-5 Color to fill with
*/
/**************************************************************************/
void drawHLine(uint8_t x, uint8_t y, uint8_t w, uint16_t color) {
  if( (x < _width) && (y < _height) && w) {   
    uint8_t hi = color >> 8, lo = color;

    if((x >= _width) || (y >= _height))
      return;
    if((x + w - 1) >= _width)  
      w = _width  - x;
    startWrite();
    setAddrWindow(x, y, w, 1);
    while (w--) {
      ST7789_SPI_XFER(hi);
      ST7789_SPI_XFER(lo);
    }
    endWrite();
  }
}

/**************************************************************************/
/*!
   @brief    Draw a perfectly vertical line (this is often optimized in a subclass!)
    @param    x   Top-most x coordinate
    @param    y   Top-most y coordinate
    @param    h   Height in pixels
   @param    color 16-bit 5-6-5 Color to fill with
*/
/**************************************************************************/
void drawVLine(uint8_t x, uint8_t y, uint8_t h, uint16_t color) {
  if( (x < _width) && (y < _height) && h) {  
    uint8_t hi = color >> 8, lo = color;
    if((y + h - 1) >= _height) 
      h = _height - y;
    startWrite();
    setAddrWindow(x, y, 1, h);
    while (h--) {
      ST7789_SPI_XFER(hi);
      ST7789_SPI_XFER(lo);
    }
    endWrite();
  }
}

/**************************************************************************/
/*!
   @brief    Fill a rectangle completely with one color. Update in subclasses if desired!
    @param    x   Top left corner x coordinate
    @param    y   Top left corner y coordinate
    @param    w   Width in pixels
    @param    h   Height in pixels
   @param    color 16-bit 5-6-5 Color to fill with
*/
/**************************************************************************/
void fillRect(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint16_t color) {
  if(w && h) {                            // Nonzero width and height?  
    uint8_t hi = color >> 8, lo = color;
    if((x >= _width) || (y >= _height))
      return;
    if((x + w - 1) >= _width)  
      w = _width  - x;
    if((y + h - 1) >= _height) 
      h = _height - y;
    startWrite();
    setAddrWindow(x, y, w, h);
    // setAddrWindow(0,0,240,320);
    uint32_t px = w * h;
    while (px--) {
      ST7789_SPI_XFER(hi);
      ST7789_SPI_XFER(lo);
    }
    endWrite();
  }
}

/**************************************************************************/
/*!
   @brief    Fill the screen completely with one color. Update in subclasses if desired!
    @param    color 16-bit 5-6-5 Color to fill with
*/
/**************************************************************************/
void fillScreen(uint16_t color) {
    fillRect(0, 0, _width, _height, color);
}

/**************************************************************************/
/*!
    @brief  Invert the colors of the display (if supported by hardware).
            Self-contained, no transaction setup required.
    @param  i  true = inverted display, false = normal display.
*/
/**************************************************************************/
void invertDisplay(bool i) {
    startWrite();
    writeCommand(i ? ST77XX_INVON : ST77XX_INVOFF);
    endWrite();
}

/*!
    @brief  Essentially writePixel() with a transaction around it. I don't
            think this is in use by any of our code anymore (believe it was
            0x110D0000Color(uint16_t color) {
    uint8_t hi = color >> 8, lo = color;
    startWrite();
    ST7789_SPI_XFER(hi);
    ST7789_SPI_XFER(lo);
    endWrite();
}
*/

// WRITTEN BY CISCO
//These are three different algorithms for writng a 60*80 or 120*160 image to a 240*320 screen.
// The last one is slowest but was the only one I could get working properly, for now.

// void imageToScreen(const uint16_t image[], uint16_t imgWidth, uint16_t imgHeight, uint8_t scaleFactor){
//     startWrite();
//     setAddrWindow(0, 0, 240, 320);
//     for (uint16_t row = 0; row<imgWidth*imgHeight; row+=imgWidth){
//         for (uint8_t count = 0; count < scaleFactor; count +=1){
//             for (uint8_t col = 0; col < imgWidth; col+=1){
//                 uint16_t color = image[row+col];
//                  for (uint8_t count2 = 0; count < scaleFactor; count +=1){
//                     ST7789_SPI_XFER(color >> 8);
//                     ST7789_SPI_XFER(color);
//                  }
//             }
//         }
//     }
//     endWrite();
// }
// void imageToScreen(const uint16_t image[], uint16_t imgWidth, uint16_t imgHeight, uint8_t scaleFactor){
//   uint16_t col = 0;
//   uint16_t row = 0;
//   uint16_t addr = 0;
//   startWrite();
//   setAddrWindow(0, 0, 240, 320);
//   while (addr < imgWidth*imgHeight){
//       // color += 10;
//       // fillRect(x,y, scaleFactor+1, scaleFactor+1, color);
//       uint16_t color = image[addr]; //(uint16_t)otter[i] <<8 + otter[i+1];
//       ST7789_SPI_XFER(color >> 8);
//       ST7789_SPI_XFER(color);
//       col += 1;
//       if (col>= 240){
//           col = 0;
//           row += 1;
//       addr = col / scaleFactor + imgWidth * (row / scaleFactor);

//       }
//     }
//   endWrite();
// }
void imageToScreen(const uint16_t image[], uint16_t imgWidth, uint16_t imgHeight, uint8_t scaleFactor){
  uint16_t x = 0;
  uint16_t y = 0;
  setAddrWindow(0, 0, 240, 320);
  for (uint16_t i = 0; i < imgWidth*imgHeight; i+=1){
      uint16_t color = image[i];
      fillRect(x,y, scaleFactor+1, scaleFactor+1, color);
      x += scaleFactor;
      if (x>= 240){
          x = 0;
          y+=scaleFactor;
      }
    }
}
// end of code.
