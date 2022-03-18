`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2022 01:16:26 PM
// Design Name: 
// Module Name: ProgramCounterTop
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


module ProgramCounter(
    input [2:0] pcSource,
    input clk,
    input reset,
    input pcWrite,
    input [31:0] jalr,
    input [31:0] branch,
    input [31:0] jal,
    input [31:0] mtvec,
    input [31:0] mepc,
    output logic [31:0] count = 0,
    output logic [31:0] pcPlus4
    );
    logic [31:0] newCount = 0;
    
    always_ff @(posedge clk) begin
    count <= newCount;
    end
    
    always_comb
    begin 
    pcPlus4 = count + 4;
    if (reset) newCount = 0;
    else if (pcWrite) begin
        case (pcSource)
            3'd0: newCount = pcPlus4;
            3'd1: newCount = jalr;
            3'd2: newCount = branch;
            3'd3: newCount = jal;
            3'd4: newCount = mtvec;
            3'd5: newCount = mepc;
            default: newCount = pcPlus4;
        endcase
    end
    else newCount = count;
    end
    
endmodule
