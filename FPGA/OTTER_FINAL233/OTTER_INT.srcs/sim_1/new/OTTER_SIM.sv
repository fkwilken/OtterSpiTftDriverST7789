`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2018 08:37:20 AM
// Design Name: 
// Module Name: simTemplate
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OTTER_SIM();
    logic CLK = 1;
    logic SCLK = 1;
   logic BTNL = 0;
   logic BTNC = 0;
   logic [15:0] SWITCHES = 16'd0;
   logic [15:0] LEDS;
   logic [7:0] CATHODES;
   logic [3:0] ANODES;
   logic SPI_SDI;
   logic SPI_SCLK;
   logic SPI_CS;
   logic SPI_SDO;
   
    OTTER_Wrapper Otter(.*);
   
    always begin
    CLK = ~CLK;
    #5;
    end
    
    always begin
    SCLK = ~SCLK;
    #20;
    end
    
    initial begin
    
    #2000
    BTNL = 1;
    #2000
    BTNL = 0;
    end

endmodule
