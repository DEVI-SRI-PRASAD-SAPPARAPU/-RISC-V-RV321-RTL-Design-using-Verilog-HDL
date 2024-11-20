`timescale 1ns / 1ps

module msrv32_pc(
input msrv32_mp_rst_in,
input  [1:0]pc_src_in, 
input [31:0]epc_in, trap_address_in, 
input branch_taken_in, 
input  [31:1]iaddr_in,
input  ahb_ready_in,
input [31:0] pc_in,
output reg [31:0]i_addr_out, pc_plus_4_out,
output reg misaligned_instr_logic_out, 
output reg [31:0]pc_mux_out 
    );
    reg pc_mux_in;
    reg [31:0]x, y;
    parameter BOOT_ADDRESS = 0;
    wire[31:0] c,z,p;
    wire [31:0]next_pc,q;
    
    
        always@(*)
        begin 
            x = pc_in + 32'h00000004;
            pc_plus_4_out = x;
        end
    
    
    //mux2:1 branch_taken_in
        mux2_1 inst1(.a(x),.b({iaddr_in, 1'b0}),.sel(branch_taken_in),.out(next_pc));
    
    
    //mux4:1 pc_src_in
        mux_4x1 inst2(.sel(pc_src_in),.a(BOOT_ADDRESS),.b(epc_in),.c(trap_address_in), .d(next_pc),.out(z));
    
        always@(*)
        begin
            pc_mux_out = z;
        end
    
    
    //mux 2:1 ahb_ready_in
        mux2_1 inst3(.a(q),.b(pc_mux_out),.sel(ahb_ready_in),.out(p));
    
    
    //mux2:1 msrv32_rst_in
        mux2_1 inst4(.a(p),.b(BOOT_ADDRESS),.sel(msrv32_mp_rst_in),.out(q));
               
        always@(*)
        begin
            misaligned_instr_logic_out = next_pc[1]&branch_taken_in;
            i_addr_out = q;
        end 
 endmodule

    module mux2_1 (
        input sel,
    input [31:0]a,
    input [31:0]b,
    output reg [31:0]out
);

always @(*) begin
    
    out = (sel == 1'b0)?a:b;
  
end
    endmodule
    
    
    
    
    module mux_4x1(
        input [1:0]sel,
        input [31:0]a,b,c,d,
        output reg [31:0] out
    );
    
    always @(*) 
    begin
        case(sel)
        2'b00 : out = a; 
        2'b01 : out = b;
        2'b10 : out = c;
        2'b11 : out = d;
        default:begin
        out = d; 
        end
    endcase
    
    end
    
    endmodule
