`timescale 1ns / 1ps

module Mux2_1 # (parameter WIDTH = 4)(
    input [WIDTH-1:0] ZERO, ONE,
    input SEL,
//////////////////////////////////////////////////////////////////////////////////
// Mux2_1 #(param) mux2_1a (.ZERO(), .ONE(), .SEL(), .MUX_OUT());
//////////////////////////////////////////////////////////////////////////////////

    output [WIDTH-1:0] MUX_OUT
    
    );
    assign MUX_OUT = SEL ? ONE : ZERO;
endmodule
