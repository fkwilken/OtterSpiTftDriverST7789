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


module testReg(
     );
     logic clk = 0;
     logic [4:0] adr1;
    logic [4:0] adr2;
    logic [4:0] wa;
    logic en = 0;
    logic [31:0] wd;
    logic [31:0] rs1;
    logic [31:0] rs2;
     RegFile testRegister (.*);
   always begin
      #5  clk =  ! clk; 
    end
    initial begin
        adr1 = 0;
        en=1;
        wd = 12'hABC;
        wa = 0;
        #20
        en=0;
        adr1 = 0;
        wd = 12'hABC;
        wa = 5'h1F;
        #20
        en=1;
        adr2 = 5'h1F;
        
        
    end
endmodule
