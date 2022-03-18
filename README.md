# OtterSpiTftDriverST7789
This repo contains an SPI module in System Verilog and driver made for FPGA-based RISCV systems. It is specifically designed for Cal Poly SLO's OTTER microcontroller.

Overview: RISC-V Otter SPI Driver

https://user-images.githubusercontent.com/74398368/158500395-fdc94592-0766-4f5f-a09d-42ed75d6537a.mp4

![image](https://user-images.githubusercontent.com/74398368/159055266-62357980-2c35-4f75-b845-37a28566b6bf.png)

This project involves adding Serial Peripheral Interfacing to the OTTER, Cal Poly SLO's proprietary RV32 microcontroller. The SPI controller is a modified version of a controller originally published on opencores.org by Santhosh G. I modified it to get rid of the latches it relied on and also made it wait for its start signal to go low before trying to start up again. At max speed, it was able to run alongside the rest of the OTTER at 25MHZ, letting it transfer at a rate of about 3 MB/s. This clock speed can be upped by reducing the clock dividers throughout the system, and this was able to work just fine but for stability reasons I stuck with the slightly slower clock rate. Future updates to this project may include finding the upper limits of this transfer to see how fast a display can be written to, as ideally at 50 MHZ with an efficient picture-writing algorithm, the system should be able to reach upwards of 30fps. Currently it gets about 5fps due to slower clocks and an imperfect pixel-writing algorithm that is still a bit of a work in progress.


To incorporate this file into your own OTTER or any FPGA, add the spi_master_2.v file under your topfile. For the OTTER, it uses the following memory mapped IO locations:

    // INPUT PORT IDS //
    localparam SWITCHES_AD = 32'h11000000;
    localparam SPI_RECEIVE_AD = 32'h110D0000;
    localparam SPI_DONE_AD    = 32'h110F0000;
              
    // OUTPUT PORT IDS //
    localparam LEDS_AD      = 32'h11080000;
    localparam SSEG_AD     = 32'h110C0000;
    localparam SPI_TRANSMIT_AD = 32'h110E0000;
    localparam SPI_START_AD = 32'h11100000;
    localparam SPI_CS_AD = 32'h11110000;
    localparam TFT_DC_AD = 32'h11120000;

   
See the Otter Wrapper in the FPGA folder for exactly how it is all hooked up. Note that the FPGA folder contains the entire Vivado project in OTTER_FINAL233 as well to run yourself, or just the wrapper and SPI module to incorporate onto your own board.

Hardware Layout:
<img width="1614" alt="SPI" src="https://user-images.githubusercontent.com/74398368/159061662-4eeab9bb-89a2-4d8b-b515-a6bc565d3601.png">

All of the memory mapped IO is controlled by the driver c code located in the driver folder. The code contains several parts. The otterSpiDriver.c file contains the OTTER-specifc memory mapped IO controls. The code is well commented and may be read to be understood. All of the functions specific to the ST7789 display are in the ST7789.c file. This file was once a C++ driver written by adafruit, that someone ported to CCS-C (a specifc C variant) which I then ported to normal c. To compile it, make sure you have the 32 bit RISCV GCC toolchain installed and just use make on the provided makefile. This will create a build folder with all the files you need after compiling everything in driver. The makefile was based on one provided in class by Profesor J. Callenes-Sloan.

The 240w by 320h display is set up to take 16-bit colors stored in RGB 565 format. To turn a picture into this format, you can use the included ImageConverter565 tool. It was written by Henning Karlsen. Save your image as a .c made for ChipKit, which will give you a huge const 16 bit array. Copy that array to a C header and include it, and now those pixels can be written to the display! Call the imageToScreen() function as outlined in ST7789.c. See the mainfile.c in driver as an example. Another useful command is the fillRect() function that draws a rectangle to any spot on the screen. Combine a bunch of these and you have all you need to create a pixel based game.  

Link to Display:
https://www.ebay.com/itm/324442623660
