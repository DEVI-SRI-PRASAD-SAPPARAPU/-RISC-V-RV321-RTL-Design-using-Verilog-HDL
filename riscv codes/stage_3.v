`timescale 1ns / 1ps


module stage_3(

//load_unit
input       ahb_resp_in,//
input [31:0]dmdata_in,
input [1:0] iadder_out_1_to_0_in,
input       load_unsigned_in,
input [1:0] load_size_in,

//wb-mux_sel_unit
input [2:0] wb_mux_sel_reg_in,
input       alu_src_reg_in,
input [31:0]imm_reg_in,iadder_out_reg_in,csr_data_in,  pc_plus_4_reg_in, rs2_reg_in,
output [31:0]wb_mux_out,


//alu
input [31:0]op_1_in,
input [3:0]opcode_in

    );
    
    wire [31:0]lu_to_wb_mux_sel_out_lu_output;
    wire [31:0]lu_to_wb_mux_sel_out_result;
    wire [31:0]wb_mux_sel_out_to_alu_alu_2nd_src_mux_out;
    
    
    load_unit load_unit_inst(
                        ahb_resp_in,          
                        dmdata_in,            
                        iadder_out_1_to_0_in, 
                        load_unsigned_in,     
                        load_size_in,         
                        lu_to_wb_mux_sel_out_lu_output
                        
                        );

    wb_mux_sel_unit wb_mux_sel_unit_inst(       wb_mux_sel_reg_in,
                        alu_src_reg_in, 
                        lu_to_wb_mux_sel_out_result, 
                        lu_to_wb_mux_sel_out_lu_output,  
                        imm_reg_in,       
                        iadder_out_reg_in,
                        csr_data_in,      
                        pc_plus_4_reg_in, 
                        rs2_reg_in,       
                        wb_mux_out,
                        wb_mux_sel_out_to_alu_alu_2nd_src_mux_out
                        
                     );
    
    alu alu_inst (    op_1_in,
                        wb_mux_sel_out_to_alu_alu_2nd_src_mux_out,
                        opcode_in,
                        lu_to_wb_mux_sel_out_result
                    
                    );
    
    
    
    
    
    
endmodule
