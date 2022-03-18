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


module simCuDecoder(
     );
     logic [6:0] op;
     logic [6:0] funct7;
     logic [2:0] funct3;
     logic br_eq;
 
     CU_Decoder Decoder (.op(op), .funct7(funct7), .funct3(funct3), .br_eq(br_eq) );
       typedef enum logic [6:0] {
        LUI = 7'b0110111,
        AUIPC = 7'b0010111,
        JAL = 7'b1101111,
        JALR = 7'b1100111,
        BRANCH = 7'b1100011,
        LOAD = 7'b0000011,
        STORE = 7'b0100011,
        OP_IMM = 7'b0010011,
        OP = 7'b0110011
    } opcode_t;
    opcode_t OPCODE;
    assign OPCODE = opcode_t'(op);
   initial begin
    
    //test sub
    op = 7'b0110011;
    funct3 = 3'b000;
    funct7 = 7'b0100000;
    #20
    //test xori 
    op = 7'b0010011;
    funct3 = 3'b100;
    #20
    //test br_eq
    op = 7'b1100011;
    funct3 = 3'b000;
    br_eq = 0;
    #20
    br_eq = 1;
    
    #20
    //test LUI
    op = 7'b0110111;
    #20
    //test AUIPC
    op = 7'b0010111;
    #20
    //test jal
    op = 7'b1101111;
    
    #20
    //test jalr
    op = 7'b1100111;
    #20
    //test load
    op = 7'b0000011;
    #20
    //test store
    op = 7'b0100011;

    end
    initial begin

        
        
    end
endmodule
