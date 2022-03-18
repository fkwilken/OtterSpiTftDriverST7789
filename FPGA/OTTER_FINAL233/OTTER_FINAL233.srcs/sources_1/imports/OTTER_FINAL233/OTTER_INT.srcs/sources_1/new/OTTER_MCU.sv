`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2022 09:56:08 PM
// Design Name: 
// Module Name: OTTER_MCU
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


module OTTER_MCU(
    input CLK,
    input INTR,
    input RST,
    input [31:0] IOBUS_IN,
    output [31:0] IOBUS_OUT,
    output [31:0] IOBUS_ADDR,
    output IOBUS_WR
    );
    //instruction
    logic [31:0] IR;
    logic [31:0] alu_out;
    logic [31:0] rs1;
    logic [31:0] rs2;
    //Start with PC and all its needs
    logic [2:0] pcSource;
    logic pcWrite;
    logic [31:0] pc;
    logic [31:0] pcPlus4;
    ProgramCounter PC(.clk(CLK), .count(pc), .reset(RST), .*);
    
    //next Mem and its needs









     logic [31:0] MEM_DOUT2;
     logic memRead1;
     logic memRead2;
     logic memWrite;
     
    OTTER_mem_byte Mem(.MEM_CLK(CLK), .MEM_SIGN(IR[14]), .MEM_DOUT1(IR),
        .MEM_READ1(memRead1), .MEM_READ2(memRead2), .MEM_WRITE2(memWrite),
        .MEM_ADDR1(pc),.MEM_SIZE(IR[13:12]), .MEM_ADDR2(alu_out), .IO_IN(IOBUS_IN), 
        .IO_WR(IOBUS_WR), .MEM_DIN2(rs2), .*);
    
    //Register File
    logic [31:0] CSR_REG;
    logic [1:0] rf_wr_sel;
    logic ERR;
    logic [31:0] wd;
    Mux4_1 #(32) RegMux (.A(pcPlus4), .B(CSR_REG), .C(MEM_DOUT2), .D(alu_out),
        .sel(rf_wr_sel), .MUX_OUT(wd));

    RegFile RegF (.clk(CLK), .en(regWrite), .adr1(IR[19:15]),
        .adr2(IR[24:20]), .wa(IR[11:7]), .*); 
    
    //Immediate Gen
     logic [31:0] UType;
     logic [31:0] IType;
     logic [31:0] SType;
     logic [31:0] jalr;
     logic [31:0] branch;
     logic [31:0] jal;
    ImmedTargetGen ITG (.IR(IR[31:7]), .*);
    
    
    //ALU
    logic [31:0] A;
    logic [31:0] B;
    logic [3:0] alu_fun;
    logic alu_srcA;
    logic [1:0] alu_srcB;
    
    Mux2_1 #(32) ALU_A (.ZERO(rs1), .ONE(UType), .SEL(alu_srcA), .MUX_OUT(A));
    Mux4_1 #(32) ALU_B (.A(rs2), .B(IType), .C(SType), .D(pc), .sel(alu_srcB), .MUX_OUT(B));
    ALU RiscAlu (.out(alu_out), .*);
    
    
    // CSR/INTR
    logic intTaken;
    logic csrWrite; 
    logic [31:0] mepc;
    logic [31:0] mtvec;   
    logic mie;      
    CSR OTTER_CSR (.ADDR(IR[31:20]), .WD(alu_out), .WR_EN(csrWrite), .RD(CSR_REG), .PC(pc),
        .CSR_MEPC(mepc), .CSR_MTVEC(mtvec), .CSR_MIE(mie), .INT_TAKEN(intTaken), .*);
    
    //Control Unit
    logic br_eq, br_lt, br_ltu;
    logic interrupt;
    assign interrupt = INTR & mie;
    logic [2:0] funct3;
    assign funct3 = IR[14:12];
    BranchCondGen BCG (.*);
    CU_Decoder CUD (.op(IR[6:0]), .funct7(IR[31:25]), .*);
    ControlFSM CUFSM (.clk(CLK), .opcode(IR[6:0]), .INTR(interrupt), .*);
    
    //Misc
    
    assign IOBUS_OUT = rs2;
    assign IOBUS_ADDR = alu_out;
    
    
endmodule
