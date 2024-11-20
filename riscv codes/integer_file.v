`timescale 1ns / 1ps

module integer_file(
input clk_in, rst_in,
input [4:0]rs_2_addr_in, rd_addr_in,  rs_1_addr_in,
input wr_en_in,
input [31:0] rd_in,
output  [31:0] rs_1_out, rs_2_out     );

reg [31:0]reg_file[31:0];
integer i,j;  
    assign rs_1_out = (rd_addr_in == rs_1_addr_in)&&wr_en_in? rd_in:reg_file[rs_1_addr_in];
    assign rs_2_out = (rd_addr_in == rs_2_addr_in)&&wr_en_in? rd_in:reg_file[rs_2_addr_in];
    always @(posedge clk_in)
    begin 
    if(!rst_in)
        begin
         if(wr_en_in)
           begin 
             reg_file[rd_addr_in] <= rd_in;
           end            
        end
     else
         begin 
            for ( i=0; i<= 31; i=i+1)
               for ( j=0; j<= 31; j=j+1)
               begin
                 reg_file[i][j] <= 1'h0;
               end
         end
     end  
endmodule
