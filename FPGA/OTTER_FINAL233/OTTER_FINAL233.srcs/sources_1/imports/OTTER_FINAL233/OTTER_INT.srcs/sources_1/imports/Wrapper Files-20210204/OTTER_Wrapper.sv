`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: J. Calllenes
//           P. Hummel
// 
// Create Date: 01/20/2019 10:36:50 AM
// Description: OTTER Wrapper (with Debounce, Switches, LEDS, and SSEG
//////////////////////////////////////////////////////////////////////////////////

module OTTER_Wrapper(
   input CLK,
   input BTNL,
   input BTNC,
   input [15:0] SWITCHES,
   input SPI_SDI,
   output logic [15:0] LEDS,
   output [7:0] CATHODES,
   output [3:0] ANODES,
   output SPI_SCLK,
   output SPI_TFT_CS,
   output SPI_SD_CS,
   output logic TFT_DC,
   output SPI_SDO   
   );
       
   
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more MMIO, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_AD = 32'h11000000;
    localparam SPI_RECEIVE_AD = 32'h110D0000;
    localparam SPI_DONE_AD    = 32'h110F0000;
              
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more MMIO
    localparam LEDS_AD      = 32'h11080000;
    localparam SSEG_AD     = 32'h110C0000;
    localparam SPI_TRANSMIT_AD = 32'h110E0000;
    localparam SPI_START_AD = 32'h11100000;
    localparam SPI_CS_AD = 32'h11110000;
    localparam TFT_DC_AD = 32'h11120000;
   
    
   // Signals for connecting OTTER_MCU to OTTER_wrapper /////////////////////////
   logic s_interrupt, btn_int;
   logic s_reset,s_load;
   logic sclk;// = 1'b0;   
   
 
   logic [15:0]  r_SSEG;// = 16'h0000;
     
   logic [31:0] IOBUS_out,IOBUS_in,IOBUS_addr;
   logic IOBUS_wr;
   
   assign s_interrupt = btn_int;
   
   
    // Declare OTTER_CPU ///////////////////////////////////////////////////////
   OTTER_MCU MCU (.RST(s_reset),.INTR(s_interrupt), .CLK(sclk), 
                   .IOBUS_OUT(IOBUS_out),.IOBUS_IN(IOBUS_in),.IOBUS_ADDR(IOBUS_addr),.IOBUS_WR(IOBUS_wr));

   // Declare Seven Segment Display /////////////////////////////////////////
   SevSegDisp SSG_DISP (.DATA_IN(r_SSEG), .CLK(CLK), .MODE(1'b0),
                       .CATHODES(CATHODES), .ANODES(ANODES));
   
   // Declare Debouncer One Shot  ///////////////////////////////////////////
   debounce_one_shot DB(.CLK(sclk), .BTN(BTNL), .DB_BTN(btn_int));
   
       
   clk_div clkDIv(CLK, sclk);//CLKDIV 
//   assign sclk = CLK;   
  
   assign s_reset = BTNC;
   
   //SPI INTERFACE ADDITION
   logic spi_clk;
   logic [1:0] SPI_CS_MEM;
   logic SPI_CS;
//   FreqGen #(14000000) SPIClockGen(.CLK(CLK), .SCLK(spi_clk)); //Upper Limit around 15mhz
    assign spi_clk = sclk;
   logic SPI_START, SPI_DONE;
   logic [7:0] SPI_TDATA;
   logic [7:0] SPI_RDATA;
   spi_master_2 SPI (.rstb(~s_reset),.clk(spi_clk),.mlb(1'b1),.start(SPI_START), .tdat(SPI_TDATA), .cdiv(2'b00),.din(SPI_SDI), 
        .ss(SPI_CS),.sck(SPI_SCLK),.dout(SPI_SDO),.done(SPI_DONE),.rdata(SPI_RDATA));
   
   assign SPI_TFT_CS = SPI_CS | ~SPI_CS_MEM[0]; 
   assign SPI_SD_CS = SPI_CS | ~SPI_CS_MEM[1]; 
   
     // Connect Board peripherals (Memory Mapped IO devices) to IOBUS /////////////////////////////////////////
    always_ff @ (posedge sclk)
    begin
     
        if(IOBUS_wr)
            case(IOBUS_addr)
                LEDS_AD: LEDS <= IOBUS_out;    
                SSEG_AD: r_SSEG <= IOBUS_out[15:0];
                SPI_TRANSMIT_AD: SPI_TDATA <= IOBUS_out[7:0];
                SPI_START_AD: SPI_START <= IOBUS_out[0];
                SPI_CS_AD: SPI_CS_MEM <= IOBUS_out[1:0];
                TFT_DC_AD: TFT_DC <= IOBUS_out[0];
             
            endcase
          
    end
   
    always_comb
    begin
        IOBUS_in=32'b0;
        case(IOBUS_addr)
            SWITCHES_AD: IOBUS_in[15:0] = SWITCHES;
            SPI_RECEIVE_AD: IOBUS_in[7:0] = SPI_RDATA;
            SPI_DONE_AD: IOBUS_in[0] = SPI_DONE;
            default: IOBUS_in=32'b0;
        endcase
    end
   endmodule

