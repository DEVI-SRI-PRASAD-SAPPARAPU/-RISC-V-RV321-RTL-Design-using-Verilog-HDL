`timescale 1ns / 1ps


module msrv32_reg_block_1(
input [31:0]pc_mux_in,
input msrv32_mp_clk_in, msrv32_mp_rst_in,
output reg [31:0]pc_out     //to reg_block_2, immediate_adder & pc_mux
    );
    
    always@(posedge msrv32_mp_clk_in )//, msrv32_mp_rst_in
    
    if(!msrv32_mp_rst_in)
        pc_out <= pc_mux_in;
    
    else
        pc_out <= pc_out;
        
endmodule
