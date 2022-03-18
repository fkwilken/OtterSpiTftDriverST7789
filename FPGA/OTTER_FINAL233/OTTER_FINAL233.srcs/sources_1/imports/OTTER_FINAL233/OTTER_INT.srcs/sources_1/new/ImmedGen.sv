`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2022 09:25:43 PM
// Design Name: 
// Module Name: ImmedGen
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


module ImmedTargetGen(
    input [31:7] IR,
    input [31:0] pc,
    input [31:0] rs1,
    output logic [31:0] UType,
    output logic [31:0] IType,
    output logic [31:0] SType,
    output logic [31:0] jalr,
    output logic [31:0] branch,
    output logic [31:0] jal
    );
    
    always_comb
    begin
    UType = {IR[31:12], 12'b0};
    IType = {{20{IR[31]}},IR[31:20]};
    SType = {{20{IR[31]}}, IR[31:25], IR[11:7]};
    jal = pc + {{12{IR[31]}}, IR[19:12], IR[20], IR[30:21],1'b0};
    branch = pc + {{20{IR[31]}},IR[7], IR[30:25], IR[11:8], 1'b0};
    jalr = rs1 + IType;
    end
    
endmodule
