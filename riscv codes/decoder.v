`timescale 1ns / 1ps


module decoder(
input trap_taken_in, funct7_5_in,
input [6:0]opcode_in,
input [2:0]funct3_in,
input [1:0]iaddr_out_1_to_0_in,
output [2:0]wb_mux_sel_out, imm_type_out, 
output  [2:0]csr_op_out,
output  mem_wr_req_out,
output  [3:0]alu_opcode_out,
output  [1:0]load_size_out,
output  load_unsigned_out, alu_src_out, iaddr_src_out, csr_wr_en_out, rf_wr_en_out, illegal_instr_out, misaligned_load_out, misaligned_store_out 
    );
    //funct7_5_in
    reg branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem;
    reg addi, slti, sltiu, andi, ori, xori ;
    wire csr;
    wire mal_word, mal_half;
    
    always @(*)
    begin    
      case(opcode_in[6:2])
        11000:{branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem }= {1'b1,10'b0};
        11011:{branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem }= {1'b0,1'b1,9'b0}; 
        11001:{branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem }= {2'b0,1'b1,8'b0};
        00101:{branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem }= {3'b0,1'b1,7'b0};
        01101:{branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem }= {4'b0,1'b1,6'b0};
        01100:{branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem }= {5'b0,1'b1,5'b0};
        00100:{branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem }= {6'b0,1'b1,4'b0};
        00000:{branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem }= {7'b0,1'b1,3'b0};
        01000:{branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem }= {8'b0,1'b1,2'b0};
        11100:{branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem }= {9'b0,1'b1,1'b0};
        00011:{branch, jal, jalr, auipc, lui, op, op_imm, load, store, system, misc_mem }= {10'b0,1'b1};
        default : begin end   
     endcase
    
     case(funct3_in)
        3'b000: {addi, slti, sltiu, andi, ori, xori} = {op_imm, 5'b0}; 
        3'b010: {addi, slti, sltiu, andi, ori, xori} = {1'b0,op_imm,4'b0} ;
        3'b100: {addi, slti, sltiu, andi, ori, xori} = {2'b0,op_imm,3'b0} ;
        3'b101: {addi, slti, sltiu, andi, ori, xori} = {3'b0,op_imm,2'b0} ;
        3'b110: {addi, slti, sltiu, andi, ori, xori} = {4'b0,op_imm,1'b0} ;
        3'b111: {addi, slti, sltiu, andi, ori, xori} = {5'b0,op_imm} ;
        default : begin end 
     endcase 
    
    end  
    
    assign alu_opcode_out[3] = funct7_5_in & ~(addi|slti|sltiu|andi|ori| xori);
    assign alu_opcode_out[2:0] = funct3_in;     

    assign load_size_out = (funct3_in[1:0])?1'b1:1'b0;     
    assign load_unsigned_out = funct3_in[2];
    assign alu_src_out = opcode_in[4];
    assign iaddr_src_out = (load||store||jalr) ? 1'b1:1'b0 ;  
    assign csr_wr_en_out = csr ? 1'b1:1'b0;
    
    assign rf_wr_en_out = lui|auipc|jalr|jal|op|load|csr|op_imm;
    assign wb_mux_sel_out = {(jalr|jal|csr), (lui|auipc), (load|auipc|jal|jalr)  };
    assign imm_type_out = {lui|auipc|jal|csr, store|branch|csr, op_imm|load|jalr|branch|jal};
    assign is_implemented_instr = (branch|jal|jalr|auipc|lui|op|op_imm|load|store|system|misc_mem)? 1'b1:1'b0;  
    
    assign csr_op_out = (funct3_in) ? 1'b1:1'b0;
    assign misaligned_load_out = ((mal_word|mal_half) && load)?1'd1:1'd0;     
    //assign misaligned_wr_req_out = store&&(!(trap_taken_in||mal_word||mal_half)) ? 1'b1:1'b0;
    assign misaligned_store_out = ((mal_word|mal_half)&& store)?1'd1:1'd0; 
    assign mem_wr_req_out = ((store)&&(trap_taken_in == 1'd0 && mal_word == 1'd0 && mal_half == 1'd0))?1'd1:1'd0;     
    assign mal_word = ((funct3_in == 3'b010)&(!(iaddr_out_1_to_0_in)))? 1'b0 : 1'b1;
    assign mal_half = ((funct3_in == (3'b100|3'b101))&& iaddr_out_1_to_0_in[0])? 1'b0 : 1'b1;
    assign csr = system & (|funct3_in);
    
    assign csr_op_out = funct3_in ? 1'b1:1'b0;
    assign illegal_instr_out = ~(is_implemented_instr&opcode_in[0]&opcode_in[1]);
           
endmodule
    /*
    case(funct3_in)
    3'b000: addi = op_imm && (funct3_in == 3'b000); 
    3'b010: slti = op_imm && (funct3_in == 3'b010);
    3'b100: sltiu = op_imm && (funct3_in == 3'b100);
    3'b101: andi = op_imm && (funct3_in == 3'b101);
    3'b110: ori = op_imm && (funct3_in == 3'b110);
    3'b111: xori =op_imm && (funct3_in == 3'b111) ;
    default : begin end 
    endcase
    */

/*
    assign alu_opcode_out[3] = (funct7_5_in)&(~(addi|slti|sltiu|andi|ori|xori));
    assign alu_opcode_out[2:0] = funct3_in;     
    assign load_size_out = (funct3_in[1:0])?1'd1:1'd0;     
    assign load_unsigned_out = (funct3_in[2])?1'd1:1'd0;     
    assign is_csr = (system)&(funct3_in[2]|funct3_in[1]|funct3_in[0]);     
    assign csr_wr_en_out = (is_csr)?1'd1:1'd0;     
    assign alu_src_out = (opcode_in[5])?1'd1:1'd0;     
    assign iadder_src_out = (load||store||jal)?1'd1:1'd0;     
    
    wire is_immplemented_instr; 
    assign is_immplemented_instr = (branch||jal||jalr||auipc||lui||op||op_imm||load||store||system||misc_mem)?1'd1:1'd0; 
 
    assign illegal_instr_out = (~is_immplemented_instr|~opcode_in[1]|~opcode_in[0]);     
    assign rf_wr_en_out = (lui|auipc|jalr|jal|op|load|csr|op_imm); 
    
    
    //wb mux selec on out     
    assign wb_mux_sel_out[0] = (load|auipc|jal|jalr);     
    assign wb_mux_sel_out[1] = (lui|auipc);     
    assign wb_mux_sel_out[2] = (csr|jal|jalr); 
    
    
    // imm_type_out     
    assign imm_type_out[0] = (op_imm|load|jalr|branch|jal);     
    assign imm_type_out[1] = (store|branch|is_csr);     
    assign imm_type_out[2] = (lui|auipc|jal|is_csr); 
    assign csr_op_out = (funct3_in)?1'd1:1'd0; 
 
    //internal wires     wire mal_word,mal_half;     
    assign mal_word = ((funct3_in == 3'b100) && (iaddr_out_1_to_0_in != 2'b00))?1'd1:1'd0;  
    assign mal_half = ((funct3_in == 3'b010) && (iaddr_out_1_to_0_in[0] != 1'b0))?1'd1:1'd0; 
 
    assign misaligned_load_out = ((mal_word|mal_half) && load)?1'd1:1'd0;     
    assign misaligned_store_out = ((mal_word|mal_half)&& store)?1'd1:1'd0;
    assign mem_wr_req_out = ((store)&&(trap_taken_in == 1'd0 && mal_word == 1'd0 && mal_half == 1'd0))?1'd1:1'd0; 
    */
        