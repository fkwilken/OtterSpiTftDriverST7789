`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2022 06:17:20 PM
// Design Name: 
// Module Name: CU_Decoder
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


module CU_Decoder(
    input br_eq,
    input br_lt,
    input br_ltu,
    input intTaken,
    input [6:0] op,
    input [2:0] funct3,
    input [6:0] funct7,
    output logic [3:0] alu_fun,
    output logic alu_srcA,
    output logic [1:0] alu_srcB,
    output logic [2:0] pcSource,
    output logic [1:0] rf_wr_sel
    );
    typedef enum logic [6:0] {
        LUI = 7'b0110111,
        AUIPC = 7'b0010111,
        JAL = 7'b1101111,
        JALR = 7'b1100111,
        BRANCH = 7'b1100011,
        LOAD = 7'b0000011,
        STORE = 7'b0100011,
        OP_IMM = 7'b0010011,
        OP = 7'b0110011,
        CSR = 7'b1110011
    } opcode_t;
    opcode_t OPCODE;
    assign OPCODE = opcode_t'(op);
    
    always_comb
    begin
    alu_fun = 4'd0;
    alu_srcA = 1'd0;
    alu_srcB = 2'd0;
    pcSource = 3'd0;
    rf_wr_sel = 2'd0;
    
    if (intTaken) pcSource = 3'd4;
    else begin
    
    case (OPCODE)
        LUI: begin
            alu_fun = 1001;
            alu_srcA = 1'b1;
            rf_wr_sel = 2'd3;
            end
        
        AUIPC: begin
            alu_srcA = 1'b1;
            alu_srcB = 2'd3;
            rf_wr_sel = 2'd3;
            end
        
        JAL: begin
            pcSource = 3'd3;
            end
        
        JALR: begin
            pcSource = 3'd1;
            rf_wr_sel = 2'd0;
            end
            
        BRANCH: begin
            if      (funct3 == 3'b000 && br_eq)   pcSource = 3'd2; //beq
            else if (funct3 == 3'b001 && !br_eq)  pcSource = 3'd2; //bne
            else if (funct3 == 3'b100 && br_lt)   pcSource = 3'd2; //blt
            else if (funct3 == 3'b101 && !br_lt)  pcSource = 3'd2; //bge
            else if (funct3 == 3'b110 && br_ltu)  pcSource = 3'd2; //bltu
            else if (funct3 == 3'b111 && !br_ltu) pcSource = 3'd2; //bgeu
            
            end
            
        LOAD: begin
            rf_wr_sel = 2'd2;
            alu_srcB = 2'd1;
            end
            
        STORE: begin
            alu_srcB = 2'd2;
            end
            
        OP_IMM: begin
            rf_wr_sel = 2'd3;
            alu_srcB = 2'd1;
            if      (funct3 == 3'd0)                            alu_fun = 4'b0000; //addi
            else if (funct3 == 3'b010)                          alu_fun = 4'b0010; //slti
            else if (funct3 == 3'b011)                          alu_fun = 4'b0011; //sltiu
            else if (funct3 == 3'b100)                          alu_fun = 4'b0100; //xori
            else if (funct3 == 3'b110)                          alu_fun = 4'b0110; //ori
            else if (funct3 == 3'b111)                          alu_fun = 4'b0111; //andi
            else if (funct3 == 3'b101 && funct7 == 7'd0)        alu_fun = 4'b0101; //srli
            else if (funct3 == 3'b001)                          alu_fun = 4'b0001; //slli
            else if (funct3 == 3'b101 && funct7 == 7'b0100000)  alu_fun = 4'b1101; //srai
            
            
            end
            
        OP: begin
            rf_wr_sel = 2'd3;
            if      (funct3 == 3'd0 && funct7 == 7'd0)          alu_fun = 4'b0000; //add
            else if (funct3 == 3'd0 && funct7 == 7'b0100000)    alu_fun = 4'b1000; //sub
            else if (funct3 == 3'b001)                          alu_fun = 4'b0001; //sll
            else if (funct3 == 3'b010)                          alu_fun = 4'b0010; //slt
            else if (funct3 == 3'b011)                          alu_fun = 4'b0011; //sltu
            else if (funct3 == 3'b100)                          alu_fun = 4'b0100; //xor
            else if (funct3 == 3'b101 && funct7 == 7'd0)        alu_fun = 4'b0101; //srl
            else if (funct3 == 3'b101 && funct7 == 7'b0100000)  alu_fun = 4'b1101; //sra
            else if (funct3 == 3'b110)                          alu_fun = 4'b0110; //or
            else if (funct3 == 3'b111)                          alu_fun = 4'b0111; //and
        
            end
            
        CSR: begin
            if (funct3 == 3'b000) pcSource = 3'd5 ;             //mret
            else if (funct3 == 3'b001) begin  //csrrw
                rf_wr_sel = 2'd1;
                alu_fun = 4'b1001;         
                end
            end
    
    
    endcase
    end
    end
endmodule
