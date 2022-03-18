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


module testALU(
     );
     logic CLK;
     logic [31:0] A, B, out;
     logic [3:0] alu_fun;
     
     ALU MyAlu (.A(A), .B(B), .alu_fun(alu_fun), .out(out));
    
//   always  
//      #5  clk =  ! clk; 

    initial begin
    //add
        A = 32'hAA;
        B = 32'hAA;
        alu_fun = 4'b0000;
        #20
        //sub
        A = 32'hC8;
        B = 32'h37;
        alu_fun = 4'b1000;
        #20
        //or
        A = 32'hC8;
        B = 32'h64;
        alu_fun = 4'b0110;
        #20
        //and
        A = 32'h12c8;
        B = 32'h12c8;
        alu_fun = 4'b0111;
        #20
        //xor
        A = 32'hAAAABBBB;
        B = 32'hFFFFFFFF;
        alu_fun = 4'b0100;
        #20
        //srl
        A = 32'hAAAA;
        B = 32'h0A;
        alu_fun = 4'b0101;
        #20
        //sll
        A = 32'hAA;
        B = 32'h0C;
        alu_fun = 4'b0001;
        #20
        //sra
        A = 32'hAA;
        B = 32'h03;
        alu_fun = 4'b1101;
        #20
        A = -20;
        B = 2;
        alu_fun = 4'b1101;
        #20
        //slt
        A = 32'hAA;
        B = 32'hAA;
        alu_fun = 4'b0010;
        #20
        A = -5;
        B = -10;
        alu_fun = 4'b0010;
        #20
        //sltu
        A = 32'hAA;
        B = 32'h55;
        alu_fun = 4'b0011;
        #20
        //copy
        A = 32'hABC12301;
        B = 32'h12345678;
        alu_fun = 4'b1001;
        #20
      $finish;
    end
endmodule
