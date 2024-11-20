`timescale 1ns / 1ps


module reg_block2(
input clk_in, rst_in,
input branch_taken_in, 
input [4:0]rd_addr_in, 
input [11:0]csr_addr_in,
input [31:0] rs1_in, rs2_in, pc_in, pc_plus_4_in,
input [3:0]alu_opcode_in,
input [1:0]load_size_in,
input load_unsigned_in,
input alu_src_in,
input csr_wr_en_in, 
input rf_wr_en_in,
input [2:0]wb_mux_sel_in,
input [2:0]csr_op_in,
input [31:0]imm_in,
input [31:0]iaddr_in, 


    output reg [11:0]csr_addr_out,
    output reg [4:0]rd_addr_out, 
    output reg [31:0] rs1_out, 
    output reg [31:0]rs2_out,  pc_plus_4_out, 
    output reg [31:0]pc_out,
    output reg [3:0]alu_opcode_out,
    output reg [1:0]load_size_out,
    output reg load_unsigned_out,
    output reg alu_src_out,
    output reg csr_wr_en_out, 
    output reg rf_wr_en_out,
    output reg [2:0]wb_mux_sel_out,
    output reg [2:0]csr_op_out,
    output reg [31:0]imm_out,
    output reg [31:0]iaddr_in_out 
    );
        
   
    always @(posedge clk_in )
     begin
        if(rst_in == 1'b1)
        begin
        rd_addr_out <= 5'b0;
        csr_addr_out <= 12'b0;
        rs1_out<=32'b0;
        rs2_out<=32'b0;
        pc_out<=32'b0;
        pc_plus_4_out<=32'b0;
        iaddr_in_out<=32'b0;
        alu_opcode_out<=4'b0;
        load_size_out<=2'b0;
        load_unsigned_out<=1'b0;
        alu_src_out<=1'b0;
        csr_wr_en_out<=1'b0; 
        rf_wr_en_out<=1'b0;
        wb_mux_sel_out<=3'b0;
        csr_op_out<=3'b0;
        imm_out<=32'b0;
        end
    
        else 
        begin 
        rd_addr_out <= rd_addr_in;
        csr_addr_out <= csr_addr_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        rs2_out <= rs2_in;
        pc_out<=pc_in;
        pc_plus_4_out <= pc_plus_4_in;
        iaddr_in_out[31:0] <= branch_taken_in ? {iaddr_in[31:1],1'b0 }:{iaddr_in[31:0] } ;
        alu_opcode_out <= alu_opcode_in;
        load_size_out <= load_size_in;
        load_unsigned_out <= load_unsigned_in;
        alu_src_out <= alu_src_in;
        csr_wr_en_out <= csr_wr_en_in; 
        rf_wr_en_out <= rf_wr_en_in;
        wb_mux_sel_out <= wb_mux_sel_in;
        csr_op_out <= csr_op_in;
        imm_out <= imm_in;
        end
        end
endmodule
