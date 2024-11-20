`timescale 1ns / 1ps


module stage2_part_2(
    
    //machine_control
    
    input ms_riscv32_mp_clk_in,
    input ms_riscv32_mp_rst_in,
    input ms_riscv32_mp_eirq_in,
    input ms_riscv32_mp_tirq_in,
    input ms_riscv32_mp_sirq_in,
    
    input illegal_instr_in,
    input misaligned_load_in,
    input misaligned_store_in,
    input misaligned_instr_in,
    input [6:2]opcode_6_to_2_in,
    
    input [2:0]funct3_in,
    input [6:0]funct7_in,
    input [4:0]rs1_addr_in, 
    input [4:0]rs2_addr_in ,
    input [4:0]rd_addr_in,
    
    output flush_out,
    output trap_taken_out,
    output [3:0]pc_src_out,
    
    //csr_file
    /*
    input ms_riscv32_mp_clk_in,
    input ms_riscv32_mp_rst_in,
    input ms_riscv32_mp_eirq_in,
    input ms_riscv32_mp_tirq_in,
    input ms_riscv32_mp_sirq_in,
    */
    input  wr_en_in,
    output [31:0]csr_data_out,
    
    output [63:0]msrv32_mp_rc_in,
    output [31:0]trap_address_out,
    output [31:0]epc_out,
    
    //reg_block2  mie_in
    
   /* input ms_riscv32_mp_clk_in,
    input ms_riscv32_mp_rst_in,*/
    input branch_taken_in, 
    input [11:0] csr_addr_in,
    
    input [31:0] rs1_in, rs2_in, pc_in, pc_plus_4_in,
    input [3:0]  alu_opcode_in,
    input [1:0]  load_size_in,
    
    input load_unsigned_in,
    input alu_src_in,
    input csr_wr_en_in, 
    input rf_wr_en_in,
    input [2:0] wb_mux_sel_in,
    
    input [2:0] csr_op_in,
    input [31:0]imm_in,
    input [31:0]iadder_in,
    
     
    
    //output reg [11:0]csr_addr_out,
    output  [4:0]rd_addr_reg_out, 
    //output reg [31:0] rs1_out, 
    output  [31:0]rs2_reg_out,  pc_plus_4_reg_out, 
    
    // output pc_out,
    output  [3:0]alu_opcode_reg_out,
    output  [1:0]load_size_reg_out,
    output  load_unsigned_reg_out,
    output  alu_src_reg_out,
    output  csr_wr_en_reg_out, 
    output  rf_wr_en_reg_out,
    output  [2:0]wb_mux_sel_reg_out,
    //output reg [2:0]csr_op_out,
    //output reg [31:0]imm_out
    //output reg [31:0]iadder_in_reg_out 
    
    //store_unit
    //input [1:0]funct3_in,
    //input [31:0]iadder_in, rs2_in,
    input mem_wr_req_in, ahb_ready_in,
    output  [31:0]  mp_riscv32_mp_dmdata_out,
    output [31:0]   mp_riscv32_mp_dmaddr_out,
    output [3:0]    mp_riscv32_mp_dmwr_mask_out,
    output          mp_riscv32_mp_dmwr_req_out,
    output [1:0]    ahb_htrans_out,
    
    //reg_block_2
    output [31:0]imm_reg_out,//
    output [31:0]iadder_reg_out,
    output [31:0]rs1_reg_out 
    //output a    
    
    );
    
    
    //machine control to csr file 
    wire i_or_e_out     ;
    wire cause_out      ;
    wire instret_inc_out;
    wire mie_clear_out  ;
    wire mie_set_out    ;
    wire misaligned_exception_out;
    wire set_epc_out    ;
    wire set_cause_out  ;
   
    wire meie_in;
    wire mtie_in;
    wire msie_in;
    wire meip_in;
    wire mtip_in;
    wire msip_in;
    wire mie_in;
    //csr_file to reg_block2
    wire [11:0]csr_addr;
    wire [31:0]rs1;
    wire [31:0]pc;
    wire [2:0]csr_op;
    wire [31:0]imm_out;
    wire [4:0] csr_uimm_in;
    wire [31:0]csr_data_in;
    wire [31:0]iadder;
    
    assign imm_reg_out = imm_out; 
    assign iadder_reg_out = iadder;
    assign  op1_in = rs1;
    
    
    
    reg_block2 reg_block_2(
    branch_taken_in, 
    csr_addr_in,                         
    rs1_in, rs2_in, pc_in, pc_plus_4_in,
    alu_opcode_in,                       
    load_size_in,                        
    load_unsigned_in, 
    alu_src_in,        
    csr_wr_en_in,      
    rf_wr_en_in,       
    wb_mux_sel_in,  
    csr_op_in,       
    imm_in,          
    iadder_in, 
    csr_addr,
     rd_addr_reg_out, 
     csr_data_in, 
     rs2_reg_out,  
     pc_plus_4_reg_out,
     pc,  
     alu_opcode_reg_out,                
     load_size_reg_out,                 
     load_unsigned_reg_out, 
     alu_src_reg_out,       
     csr_wr_en_reg_out,     
     rf_wr_en_reg_out,      
     wb_mux_sel_reg_out,
     csr_op,
     csr_uimm_in,
     iadder
     );
     
    
    
    msrv32_csr_file csr_file(ms_riscv32_mp_clk_in,ms_riscv32_mp_rst_in,
    wr_en_in,csr_addr,csr_op, csr_uimm_in, csr_data_in, pc, iadder,
    ms_riscv32_mp_eirq_in,
    ms_riscv32_mp_tirq_in,
    ms_riscv32_mp_sirq_in,
    i_or_e_out, 
    set_cause_out, 
    set_epc_out,
    instret_inc_out,
    mie_clear_out,
    mie_set_out,
    cause_out,
    msrv32_mp_rc_in,
    misaligned_exception_out,
    csr_data_out,
    mie_in,
    msrv32_epc_out,
    trap_address_out,
    meie_in,
    mtie_in,
    msie_in,
    meip_in,
    mtip_in,
    msip_in
    );
    
    
    msrv32_machine_control machine_control(ms_riscv32_mp_clk_in,ms_riscv32_mp_rst_in,
    illegal_instr_in,   
    misaligned_load_in, 
    misaligned_store_in,
    misaligned_instr_in,
    opcode_6_to_2_in,
    funct3_in,       
    funct7_in,       
    rs1_addr_in,     
    rs2_addr_in ,    
    rd_addr_in,      
    ms_riscv32_mp_eirq_in,
    ms_riscv32_mp_tirq_in,
    ms_riscv32_mp_sirq_in,
    mie_in,
    meie_in,
    mtie_in,
    msie_in,
    meip_in,
    mtip_in,
    msip_in,
    i_or_e_out, 
    set_epc_out  ,    
    set_cause_out,
    cause_out,      
    instret_inc_out,
    mie_clear_out ,
    mie_set_out ,   
    misaligned_exception_out,
    
    flush_out,      
    trap_taken_out,   
    pc_src_out//pc_src_put
    
     );
     
     store_unit store_unit(
     funct3_in[1:0], 
     iadder_in, 
     rs2_in, 
     mem_wr_req_in, 
     ahb_ready_in,
     mp_riscv32_mp_dmdata_out,    
     mp_riscv32_mp_dmaddr_out,    
     mp_riscv32_mp_dmwr_mask_out, 
     mp_riscv32_mp_dmwr_req_out,  
     ahb_htrans_out               
     );
     
    
endmodule
