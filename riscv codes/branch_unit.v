`timescale 1ns / 1ps


module branch_unit(
    input [31:0] rs1_in,
    input [31:0] rs2_in,
    input [4:0] opcode_6_to_2_in,
    input [2:0] funct3_in,
    output reg branch_taken_out
    );
    
    
    
   
    always @(*)
    begin
    case({opcode_6_to_2_in, funct3_in } )    
    8'b11000000 : if (rs1_in == rs2_in) branch_taken_out = 1; 
    8'b11000001 : if (rs1_in != rs2_in) branch_taken_out = 1; 
    8'b11000100 : if (rs1_in < rs2_in) branch_taken_out = 1; 
    8'b11000101 : if (rs1_in >= rs2_in) branch_taken_out = 1;
    8'b11000110 : if (rs1_in < rs2_in) branch_taken_out = 1; 
    8'b11000111 : if (rs1_in >= rs2_in) branch_taken_out = 1;
    
    default : branch_taken_out = 0;
    endcase
    end

endmodule
