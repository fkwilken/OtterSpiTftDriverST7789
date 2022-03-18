# OtterSpiTftDriverST7789
This repo contains an SPI module in System Verilog and driver made for FPGA-based RISCV systems. It is specifically designed for Cal Poly SLO's OTTER microcontroller.

Overview: RISC-V Otter SPI Driver

https://user-images.githubusercontent.com/74398368/158500395-fdc94592-0766-4f5f-a09d-42ed75d6537a.mp4

This project involves adding Serial Peripheral Interfacing to the OTTER, Cal Poly SLO's proprietary RV32 microcontroller. The SPI controller is a modified version of a controller originally published on opencores.org by Santhosh G. I modified it to get rid of the latches it relied on and also made it wait for its start signal to go low before trying to start up again. At max speed, it was able to run alongside the rest of the OTTER at 25MHZ, letting it transfer at a rate of about 3 MB/s. This clock speed can be upped by reducing the clock dividers throughout the system, and this was able to work just fine but for stability reasons I stuck with the slightly slower clock rate. Future updates to this project may include finding the upper limits of this transfer to see how fast a display can be written to.


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
   
See the Otter Wrapper
