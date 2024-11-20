`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2023 15:30:54
// Design Name: 
// Module Name: mux_4x1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



/*
module mux_4x1_gen #(parameter n= 31)(
input [n:0]a, b, c,  d,
input [1:0]sel,
output  [n:0]out 
    );
    genvar i;
    generate
    for(i=0; i<=n; i=i+1)
    begin 
    mux_4x1 inst(.S(sel),.A(a[i]),.B(b[i]),.C(c[i]), .D(d[i]),.Y(out[i]));
    end 
    endgenerate
    
    
endmodule
*/