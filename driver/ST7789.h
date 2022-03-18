
#ifndef ST7789_H_
#define ST7789_H_

#include <stdint.h>
#ifndef bool
#define bool uint8_t
#endif
//*************************** User Functions ***************************//
void tft_init(void);
void imageToScreen(const uint16_t image[], uint16_t imgWidth, uint16_t imgHeight, uint8_t scaleFactor);
void drawPixel(uint16_t x, uint16_t y, uint16_t color);
void drawHLine(uint16_t x, uint16_t y, uint16_t w, uint16_t color);
void drawVLine(uint16_t x, uint16_t y, uint16_t h, uint16_t color);
void fillRect(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint16_t color);
void fillScreen(uint16_t color);
void setRotation(uint8_t m);
void invertDisplay(bool i);
void pushColor(uint16_t color);

//************************* Non User Functions *************************//
void startWrite(void);
void endWrite(void);
void displayInit(uint8_t *addr);
void writeCommand(uint8_t cmd);
void setAddrWindow(uint16_t x, uint16_t y, uint16_t w, uint16_t h);


#endif