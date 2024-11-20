`timescale 1ns / 1ps



// csr_file_wr_out
module stage2_part1(
input clk_in,
input [31:0]pc_in,
input iadder_src_in,
input flush_in,// wr_en_generator, instruction_mux
input rf_wr_en_reg_in,
input csr_wr_en_reg_in,
input [31:0]instr_in,

// branch_unit
input [31:0]rs1_in,
input [31:0]rs2_in,

output  branch_taken_out,

//decoder
input trap_taken_in,

output  [2:0]wb_mux_sel_out,
output  mem_wr_req_out,
output  [2:0]csr_op_out,
output  [3:0]alu_opcode_out,
output  [1:0]load_size_out,
output  load_unsigned_out,
output  alu_src_out,
output  iaddr_src_out,
output  csr_wr_en_out,
output  rf_wr_en_out,
output  illegal_instr_out,
output  misaligned_load_out,
output  misaligned_store_out,

input [31:0]rd_in,//integerfile
input [4:0]rd_addr_in,//integerfile
output  [31:0]rs_2_out,//integerfile
output  csr_file_wr_en_out,
output  [4:0]rdaddr_out,
output  [11:0]csr_addr_out,
output [31:0]rs1_out,
output [6:0]opcode,
output [2:0]funct3_in,
output [6:0]funct7_in,
output [4:0]rs1_addr_in,
output [4:0]rs2_addr_in,
output [31:0]imm_in
//output a
    );
   
   
 //imm_generator   
  wire [24:0]gen_instr_in_instruction_mux_instr_out;
  wire [2:0]imm_type_in_decoder_imm_type_out;
  wire [31:0]imm_gen_to_immadder_out_imm_in;
  wire [31:0]int_file_rs_1toimm_adder;
  wire [31:0]iadder_to_decoder_iadder_out;
  wire wr_en_gen_to_Intfile_wr_en_in;
  wire [4:0]instr_to_intfile_rs1_addr;
  wire [4:0]instr_to_intfile_rs2_addr;
  wire [6:0]insrt_mux_to_decoder_opcode;
  wire [2:0]insrt_mux_to_decoder_funct3;
  wire [6:0]insrt_mux_to_decoder_funct7;
  
  assign rs1_out = int_file_rs_1toimm_adder;
  assign opcode =insrt_mux_to_decoder_opcode;
  assign funct3_in = insrt_mux_to_decoder_funct3;
  assign funct7_in = insrt_mux_to_decoder_funct7;
  assign rs1_addr_in = instr_to_intfile_rs1_addr;
  assign rs2_addr_in = instr_to_intfile_rs2_addr;
  assign imm_in = imm_gen_to_immadder_out_imm_in;
  
    imm_generator dut1(.instr_in(gen_instr_in_instruction_mux_instr_out),
    .imm_type_in(imm_type_in_decoder_imm_type_out),.imm_out(imm_gen_to_immadder_out_imm_in)
        );
    
    immediate_adder dut2(imm_gen_to_immadder_out_imm_in, pc_in, iadder_src_in, int_file_rs_1toimm_adder, iadder_to_decoder_iadder_out);
    
    integer_file dut3(.rd_in(rd_in),.wr_en_in(wr_en_gen_to_Intfile_wr_en_in),
    .rd_addr_in(rd_addr_in),.rs_1_addr_in(instr_to_intfile_rs1_addr),.rs_2_addr_in(instr_to_intfile_rs2_addr),
    .rs_1_out(int_file_rs_1toimm_adder), .clk_in(clk_in), .rst_in(rst_in), .rs_2_out(rs_2_out)
        );
    
    wr_en_generator dut4(flush_in, rf_wr_en_reg_in, csr_wr_en_reg_in, wr_en_gen_to_Intfile_wr_en_in,csr_file_wr_en_out);
    
    instruction_mux dut5(flush_in, instr_in, insrt_mux_to_decoder_opcode,
     insrt_mux_to_decoder_funct3, 
    insrt_mux_to_decoder_funct7, instr_to_intfile_rs1_addr, instr_to_intfile_rs2_addr,
     rdaddr_out, csr_addr_out,gen_instr_in_instruction_mux_instr_out
    );
    
   
    
    branch_unit dut6(rs1_in, rs2_in, insrt_mux_to_decoder_opcode[6:2],
     insrt_mux_to_decoder_funct3[2:0], branch_taken_out);
    
    decoder dut7(.opcode_in(insrt_mux_to_decoder_opcode),
    .funct3_in(insrt_mux_to_decoder_funct3),
    .trap_taken_in(trap_taken_in), 
    .funct7_5_in(insrt_mux_to_decoder_funct7[5]),
    .iaddr_out_1_to_0_in(iadder_to_decoder_iadder_out[1:0]),
    .wb_mux_sel_out(wb_mux_sel_out), 
    .imm_type_out(imm_type_in_decoder_imm_type_out),
    .mem_wr_req_out(mem_wr_req_out),
    .csr_op_out(csr_op_out), 
    .alu_opcode_out(alu_opcode_out), 
    .load_size_out(load_size_out), 
    .load_unsigned_out(load_unsigned_out),    
    .alu_src_out( alu_src_out),
    .iaddr_src_out( iaddr_src_out),
    .csr_wr_en_out( csr_wr_en_out),
    .rf_wr_en_out( rf_wr_en_out),
    .illegal_instr_out( illegal_instr_out),
    .misaligned_load_out ( misaligned_load_out),
    .misaligned_store_out( misaligned_store_out)
    );
    
    
    
endmodule
