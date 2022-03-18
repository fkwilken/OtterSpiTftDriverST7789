`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2022 08:36:45 PM
// Design Name: 
// Module Name: ControlFSM
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


module ControlFSM(
    input INTR,
    input clk,
    input RST,
    input [6:0] opcode,
    input [2:0] funct3,
    output logic pcWrite,
    output logic regWrite,
    output logic memWrite,
    output logic memRead1,
    output logic memRead2,
    output logic csrWrite,
    output logic intTaken
  
    );
    
    enum {Fetch, Decode, WriteBack, Interrupt} NS, PS=Fetch;
        
    always_ff @ (posedge clk)
    begin
        PS <= NS;
    end
    
    always_comb
    begin
    pcWrite = 0;
    regWrite = 0;
    memWrite = 0;
    memRead1 = 0;
    memRead2 = 0;
    intTaken = 0;
    csrWrite = 0;
    NS = Fetch;
    if (RST) NS = Fetch;
    else begin
    case (PS)
        Fetch:
            begin
            memRead1 = 1;
            NS = Decode;
            end
        
        Decode:
            begin

            if (opcode == 7'b0100011) memWrite = 1; //Store
            else if (opcode != 7'b1100011) regWrite = 1; //if not store or branch, regwrite
            if (opcode == 7'b0000011) begin
                NS = WriteBack; //Load
                memRead2 = 1;
                end
            else 
                begin
                NS = Fetch;
                pcWrite = 1;
                end
            if (opcode == 7'b1110011 && funct3 == 3'b001) csrWrite = 1;
            if (INTR) NS = Interrupt;            
            end
        
        WriteBack:
            begin
            regWrite = 1;
            pcWrite = 1;
            NS = Fetch;
            if (INTR) NS = Interrupt;
            end
            
        Interrupt:
            begin
            intTaken = 1;
            pcWrite = 1;
            NS = Fetch;
            end     
            
    endcase
    end
    end
        
endmodule

