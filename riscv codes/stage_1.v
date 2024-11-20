`timescale 1ns / 1ps


module stage_1(
input    rst_in,
input   [1:0]pc_src_in, 
input   [31:0]epc_in, trap_address_in, 
input    branch_taken_in, 
input   [31:1]iaddr_in,
input   ahb_ready_in,
input   [31:0] pc_in,
output  [31:0]i_addr_out, 
output  [31:0]pc_plus_4_out,
output  misaligned_instr_logic_out, 
//output [31:0]pc_mux_out,
//input wire [31:0]pc_mux_in,
input clk_in, 
output  [31:0]pc_out    );

wire [31:0]pc_mux_in;
    
    msrv32_pc inst1(rst_in, pc_src_in, epc_in, trap_address_in, branch_taken_in,iaddr_in, ahb_ready_in,
    pc_in, i_addr_out, pc_plus_4_out,misaligned_instr_logic_out,pc_mux_in);     
    msrv32_reg_block_1 inst2(pc_mux_in,clk_in,rst_in,pc_out);
     
endmodule
