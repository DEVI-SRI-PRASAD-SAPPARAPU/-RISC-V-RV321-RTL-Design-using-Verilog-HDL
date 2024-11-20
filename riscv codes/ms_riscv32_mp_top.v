`timescale 1ns / 1ps


module ms_riscv32_mp_top(
input ms_riscv32_mp_clk_in,//s2p1
input ms_riscv32_mp_rst_in,
input ms_riscv32_mp_instr_hready_in,
input [31:0]ms_riscv32_mp_dmdata_in,
input [31:0]ms_riscv32_mp_instr_in,
//input [3:0]ms_riscv32_mp_dmwr_mask_in,
input ms_riscv32_mp_hresp_in,
input [63:0]ms_riscv32_mp_rc_in,
input ms_riscv32_mp_hready_in,
input ms_riscv32_mp_eirq_in,
input ms_riscv32_mp_tirq_in,
input ms_riscv32_mp_sirq_in,

output ms_riscv32_mp_dmwr_req_out,
output [31:0] ms_riscv32_mp_imaddr_out,
output [31:0] ms_riscv32_mp_dmaddr_out,
output [31:0] ms_riscv32_mp_dmdata_out,
output [1:0]  ms_riscv32_mp_data_htrans_out,
output [3:0]  ms_riscv32_mp_dmwr_mask_out
    );


    
    wire [3:0]pc_src_in;                
    wire [31:0]epc_in, trap_address_in; 
              
                 
    wire ahb_ready_in;
    wire [31:0]i_addr_out;
    wire [31:0]pc_plus_4_out;
    wire misaligned_instr_out;    
    
    
    
    wire [31:0] pc_in;
    wire i_addr_src_in; //from decoder
    wire flush_in;
    wire rf_wr_en_reg_in;
    wire csr_wr_en_reg_in;
    wire csr_file_wr_en_out;
    wire [31:0]rs_2_out;
    wire [31:0]rs1_in;
    wire branch_taken_in;
    wire [4:0]rd_addr_out;
    wire [4:0]csr_addr_out;
    wire trap_taken_in;
    wire [2:0]wb_mux_sel_out;
    wire mem_wr_req_out;
    wire [2:0]csr_op_out;
    wire [3:0]alu_opcode_out;
    wire [1:0]load_size_out;
    wire load_unsigned_out;  
    wire alu_src_out;       
    wire iaddr_src_out;       
    wire csr_wr_en_in;       
    wire rf_wr_en_out;        
    wire illegal_instr_out;  
    wire misaligned_load_out;
    wire misaligned_store_out;
    wire [31:0]iaddr_in; 
    
    //stage2_part2 op_code_out[6:2]
    wire [2:0]funct3_in;
    wire [6:0]opcode;
    wire [6:0]funct7_in;
    wire [31:0]csr_data_out;
    wire [31:0]imm_in;
    wire [4:0]rd_addr_reg_out;        
    wire [31:0]rs2_reg_out;            
    wire [31:0]pc_plus_4_reg_out;       
    wire [3:0]alu_opcode_reg_out;      
    wire [1:0]load_size_reg_out;       
    wire load_unsigned_reg_out;   
    wire alu_src_reg_out;        
    wire csr_wr_en_reg_out;       
    wire rf_wr_en_reg_out;        
    wire [2:0]wb_mux_sel_reg_out;      
    //wire [31:0]rs2_reg_out;//stage_3 wb_mux_seL-unit
    
    //stage_3
    wire [31:0]rd_in;//wb_mux_out
    wire imm_reg_out    ;
    wire iadder_reg_out ;
    wire  op1_in        ;
    
    
    
    
    stage_3   stage_3(
    ms_riscv32_mp_hresp_in,
    ms_riscv32_mp_dmdata_in,
    iaddr_in[1:0],
    load_unsigned_out,
    load_size_out,
    wb_mux_sel_reg_out,
    alu_src_reg_out,
    imm_reg_out,//
    iadder_reg_out,//
    csr_data_out,
    pc_plus_4_reg_out,
    rs2_reg_out,
    rd_in,
    
    op1_in,//rs1_reg_out
    alu_opcode_reg_out//alu_opcodeReg_out
    
    );
    
  
  
  
  
    stage2_part_2   stage2_part2(
    ms_riscv32_mp_clk_in,
    ms_riscv32_mp_rst_in,
    ms_riscv32_mp_eirq_in, 
    ms_riscv32_mp_tirq_in, 
    ms_riscv32_mp_sirq_in, 
    illegal_instr_out,  
    misaligned_load_out, 
    misaligned_store_out,
    misaligned_instr_out,
    opcode[6:2],
    funct3_in,
    funct7_in, 
    rs1_addr_in,
    rs2_addr_in,
    rd_addr_out,
    flush_in, 
    trap_taken_in,
    pc_src_in,
    csr_file_wr_en_out,
    csr_data_out,
    ms_riscv32_mp_rc_in,
    trap_address_in,
    epc_in,
    branch_taken_in,
    csr_addr_out,
    rs1_in,
    rs_2_out,
    pc_in,
    pc_plus_4_out,
    alu_opcode_out,
    load_size_out,
    load_unsigned_out,
    //alu_opcode_out,
    alu_src_out,
    csr_wr_en_in,
    rf_wr_en_out,
    wb_mux_sel_out,
    csr_op_out,
    imm_in,
    iaddr_in,
    rd_addr_reg_out,
    rs2_reg_out,
    pc_plus_4_reg_out,
    alu_opcode_reg_out, 
    load_size_reg_out,  
    load_unsigned_reg_out,  
    alu_src_reg_out,        
    csr_wr_en_reg_out,      
    rf_wr_en_reg_out,       
    wb_mux_sel_reg_out,
    mem_wr_req_out,
    ms_riscv32_mp_instr_hready_in,
    ms_riscv32_mp_dmdata_out,   
    ms_riscv32_mp_dmaddr_out,   
    ms_riscv32_mp_dmwr_mask_out,
    ms_riscv32_mp_dmwr_req_out, 
    ms_riscv32_mp_data_htrans_out ,             
    imm_reg_out ,
    iadder_reg_out ,
    op1_in
    );
    
    
    
    
    
    
        
    
    stage_1    stage_1(
    
    ms_riscv32_mp_rst_in,
    pc_src_in[1:0], epc_in, trap_address_in, 
    branch_taken_in,iaddr_in[31:1],
    ms_riscv32_mp_hready_in, pc_in,
    ms_riscv32_mp_imaddr_out, 
    pc_plus_4_out,
    misaligned_instr_out, 
    ms_riscv32_mp_clk_in, pc_in   
    );

   
   assign iadder_src_in = iaddr_src_out;
   
   
   
   
   
   
    stage2_part1       stage_2_part1(
    
    ms_riscv32_mp_clk_in, 
    pc_in,      
    iadder_src_in,    
    flush_in,
    rf_wr_en_reg_in,  
    csr_wr_en_reg_in, 
    ms_riscv32_mp_instr_in,   
    rs1_in,
    rs2_in,
    branch_taken_out,
    trap_taken_in,
    wb_mux_sel_out,   
    mem_wr_req_out,        
    csr_op_out,       
    alu_opcode_out,   
    load_size_out,    
    load_unsigned_out,     
    alu_src_out,           
    iaddr_src_out,         
    csr_wr_en_reg_in,         
    rf_wr_en_reg_out,          
    illegal_instr_out,     
    misaligned_load_out,   
    misaligned_store_out,
    rd_in,
    rd_addr_out,
    rs_2_out,// from integer file 
    csr_file_wr_en_out,    //iaddr_in
    rd_addr_out, 
    csr_addr_out,
    //iaddr_in,
    rs1_out,//from integer file
    opcode,
    funct3_in,
    funct7_in,
    rs1_addr_in,
    rs2_addr_in,
    imm_in
    );
    
    
endmodule
