`timescale 1ns / 1ps


module alu #(parameter  
    ADD = 4'b0000 ,
    SUB = 4'b1000 ,
    SLT = 4'b0010 ,
    SLTU = 4'b0011 ,
    AND = 4'b0111 ,
    OR = 4'b0110 ,
    XOR = 4'b0100 ,
    SLL = 4'b0001 ,
    SRL = 4'b0101 ,
    SRA = 4'b1101 )(
    input [31:0] op_1_in,
    input [31:0] op_2_in,
    input [3:0] opcode_in,
    output reg [31:0] result_out
    );
    always @(*)
    begin
    case(opcode_in)
    ADD : result_out = op_1_in + op_2_in;
    SUB : result_out = op_1_in - op_2_in;
    SLT : result_out = (op_1_in < op_2_in);
    SLTU : result_out = (op_1_in < op_2_in);
    AND : result_out = op_1_in & op_2_in;
    OR  : result_out = op_1_in | op_2_in;
    XOR : result_out = op_1_in ^ op_2_in;
    SLL : result_out = op_1_in <<< op_2_in;
    SRL : result_out = op_1_in >>> op_2_in;
    SRA : result_out = op_1_in >> op_2_in;
    default  : begin result_out = 0; end      
    endcase
    end
endmodule









