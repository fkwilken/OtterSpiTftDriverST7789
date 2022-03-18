`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2022 05:39:15 PM
// Design Name: 
// Module Name: BranchCondGen
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


module BranchCondGen(
    input [31:0] rs1,
    input [31:0] rs2,
    output logic br_eq,
    output logic br_lt,
    output logic br_ltu
    );
    
    always_comb 
    begin
    br_eq = rs1 == rs2;
    br_lt = $signed(rs1) < $signed(rs2);
    br_ltu = rs1 < rs2;
    end
endmodule
