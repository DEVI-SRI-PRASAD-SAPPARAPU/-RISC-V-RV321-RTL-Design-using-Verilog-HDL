`timescale 1ns / 1ps


module load_unit(
input ahb_resp_in, 
input [31:0]data_in,
input [1:0]iadder_out_1_to_0_in,
input load_unsigned_in, 
input [1:0]load_size_in,
output reg [31:0]lu_output_out 
    );

reg signed [31:0]a;
reg [23:0]temp_output2;
reg [7:0]temp_output1;
reg [15:0]temp_byte_out;
reg [15:0]temp_hw_out;
reg [15:0]half_word;
reg [7:0]byte;


    always @(*)
        begin 
        case(load_unsigned_in)
            1'b0 : begin 
                         temp_byte_out = a ;
                         temp_hw_out = 16'b0; 
                   end
            1'b1 : begin 
                          temp_hw_out = {8'b0,half_word};
                          temp_byte_out = 16'b0 ;
                          end
            default : begin  end
        endcase
        
        a = data_in[31:8];
        temp_output2 = half_word;
        temp_output1 = byte;
      
     begin 
        if(ahb_resp_in)
        case(load_size_in)
            2'b00 : lu_output_out = {temp_byte_out, temp_output1};
            2'b01 : lu_output_out = {temp_hw_out, temp_output2};
            2'b10 : lu_output_out = data_in;
            2'b11 : lu_output_out = data_in;
        default : begin end
        endcase
        else
          lu_output_out = 32'bz;
    end 
    
        if(iadder_out_1_to_0_in[1])
            half_word = data_in[15:0];
        else
            half_word = data_in[31:16];
        
        case(iadder_out_1_to_0_in)
            2'b00 : byte = data_in[7:0];
            2'b01 : byte = data_in[15:8];
            2'b10 : byte = data_in[23:16];
            2'b11 : byte = data_in[31:24];
        endcase
    
   end
endmodule
