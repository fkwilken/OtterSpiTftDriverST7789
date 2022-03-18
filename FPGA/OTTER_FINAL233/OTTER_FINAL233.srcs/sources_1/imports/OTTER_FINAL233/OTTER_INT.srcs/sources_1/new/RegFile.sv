`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2022 12:41:29 PM
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input clk,
    input [4:0] adr1,
    input [4:0] adr2,
    input [4:0] wa,
    input en,
    input [31:0] wd,
    output logic [31:0] rs1,
    output logic [31:0] rs2
    );
    
    logic [31:0] ram [0:31]; 
    
    always_comb 
    begin
    rs1 = 32'd0;
    rs2 = 32'd0;
    if (adr1) rs1 = ram[adr1];
    if (adr2) rs2 = ram[adr2];
    end
    
    always_ff @ (posedge clk)
    begin
    if (en) begin
        ram[wa] <= wd;
        end
    end
endmodule
