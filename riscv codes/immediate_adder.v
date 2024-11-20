`timescale 1ns / 1ps


module immediate_adder(
input [31:0]imm_in, pc_in,  
input iaddr_src_in,
input [31:0] rs_1_in, 

output reg [31:0] iaddr_out  
    );
    wire [31:0]mux_out;
    
    mux_2x1 inst(iaddr_src_in, pc_in, rs_1_in, mux_out);
    
    always@(*)
    begin 
    iaddr_out = mux_out + imm_in;    
    end
endmodule

module mux_2x1 (
    input sel,
    input [31:0]a,
    input [31:0]b,
    output reg [31:0]out
);

always @(*) begin
    
    out = (sel == 1'b0)?a:b;
  
end

endmodule
