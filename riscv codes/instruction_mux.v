`timescale 1ns / 1ps

module instruction_mux(
input flush_in,
input [31:0] instr_in,
output reg [6:0] opcode_out, 
output reg [2:0] funct3_out,
output reg [6:0] funct7_out,
output reg [4:0] rs1_addr_out, rs2_addr_out, rdaddr_out,
output reg [11:0] csr_addr_out,
output reg [24:0] instr_out
    );
    
    
    always @(*)
    if (flush_in)
        instr_out = 32'h13;
        
    else 
    begin
        opcode_out = instr_in[6:0];
        funct3_out = instr_in[14:12];
        funct7_out = instr_in[31:25];
        csr_addr_out = instr_in[31:20];
        rs1_addr_out = instr_in[19:15];
        rs2_addr_out = instr_in[24:20];
        rdaddr_out = instr_in[11:7];
        instr_out = instr_in[31:7];
    end  
endmodule
