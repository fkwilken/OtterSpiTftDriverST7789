`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ClkDiv2 #(param) clk1 ( .CLK(), .SCLK()); 
//////////////////////////////////////////////////////////////////////////////////

module FreqGen #(parameter FREQ = 1100)(
    input CLK,
    output logic SCLK = 0
    );
         
    int COUNT =  100000000 /((FREQ))- 1;
    logic [31:0] count = 0;
    always_ff @ (posedge CLK)
    begin
        if (count == COUNT -1 )
        begin
            SCLK <= ~SCLK;
            count <= 0;
        end
        else
            count <= count + 1;
    end
        
endmodule

