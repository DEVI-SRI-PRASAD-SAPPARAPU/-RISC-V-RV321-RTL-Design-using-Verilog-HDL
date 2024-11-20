`timescale 1ns / 1ps


module wb_mux_sel_unit(
input alu_src_reg_in,
    input [2:0] wb_mux_sel_reg_in,
    input [31:0] alu_result_in,
    input [31:0] lu_output_in,
    input [31:0] imm_reg_in,
    input [31:0] iaddr_out_reg_in,
    input [31:0] csr_data_in,
    input [31:0] pc_plus_4_reg_in,
    input [31:0] rs2_reg_in,
    output reg [31:0] wb_mux_out,
    output reg [31:0] alu_2nd_src_mux_out  );
    
    parameter WB_ALU = 3'd0, WB_LU = 3'd1, WB_IMM = 3'd2, WB_IADDER_OUT = 3'd3, WB_CSR = 3'd4, WB_PC_PLUS = 3'd5;
    always @(*)
    begin
        case(wb_mux_sel_reg_in)
            WB_ALU : wb_mux_out = alu_result_in;
            WB_LU  : wb_mux_out = lu_output_in;
            WB_IMM : wb_mux_out = imm_reg_in;
            WB_IADDER_OUT : wb_mux_out = iaddr_out_reg_in;
            WB_CSR : wb_mux_out = csr_data_in;
            WB_PC_PLUS : wb_mux_out = pc_plus_4_reg_in;
            default : wb_mux_out = alu_result_in;
        endcase        
        alu_2nd_src_mux_out = alu_src_reg_in ? rs2_reg_in : imm_reg_in;
    end    
endmodule
