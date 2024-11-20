`timescale 1ns / 1ps

module store_unit(
input [1:0]funct3_in,
input [31:0]iadder_in, rs2_in,
input mem_wr_req_in, ahb_ready_in,
output reg  [31:0]data_out,
output  [31:0] addr_out,
output reg [3:0]wr_mask_out,
output  wr_req_out,
output reg [1:0]ahb_htrans_out
    );
    
   reg [31:0]b_data_out, h_data_out; 
   reg [3:0]byte_wr_mask, halfword_wr_mask;
   //reg [31:0]d_addr = 0;
  
    assign wr_req_out = mem_wr_req_in;  
     assign addr_out = {iadder_in[31:2], 2'b0}; 
    always @(*)
    begin
       case(iadder_in[1:0])
            2'b00: b_data_out = {8'b0,8'b0,8'b0, rs2_in[7:0]}; 
            2'b01: b_data_out = {8'b0,8'b0,rs2_in[15:8],8'b0};  
            2'b10: b_data_out = {8'b0,rs2_in[23:16],8'b0,8'b0};
            2'b11: b_data_out = {rs2_in[31:24],8'b0,8'b0,8'b0};        
            default : begin end
        endcase
  //end 
  
  //always @(*)
   //begin 
        case(iadder_in[1])
            1'b0: h_data_out = {8'b0,8'b0,rs2_in[15:8],rs2_in[7:0]}; 
            1'b1: h_data_out = {rs2_in[31:24],rs2_in[23:16],8'b0,8'b0};
            default : begin h_data_out = 0; end
        endcase
   //end
   
    begin
      if(ahb_ready_in)
      begin
        case(funct3_in[1:0])
            2'b00: data_out = b_data_out ; 
            2'b01: data_out = h_data_out ;       
            default : begin data_out = rs2_in;  end
        endcase
        ahb_htrans_out  = 2'b10;
      end  
      
      else 
        ahb_htrans_out  = 2'b00;
    end
    
    if(ahb_ready_in)
      begin 
        case(funct3_in[1:0])
            2'b00: wr_mask_out = byte_wr_mask ; 
            2'b01: wr_mask_out = halfword_wr_mask ;       
            default : begin wr_mask_out = {4{mem_wr_req_in}};  end
        endcase
       ahb_htrans_out  = 2'b10;
      end  
      
      else begin 
        ahb_htrans_out  = 2'b00;
        end

    begin 
        case(iadder_in[1:0])
            2'b00: byte_wr_mask = {3'b0,mem_wr_req_in}; 
            2'b01: byte_wr_mask = {2'b0,mem_wr_req_in,1'b0};  
            2'b10: byte_wr_mask = {1'b0,mem_wr_req_in,2'b0};
            2'b11: byte_wr_mask = {mem_wr_req_in,3'b0};
            default : begin end
        endcase
    end 
    begin 
        case(iadder_in[1])
            1'b0: halfword_wr_mask = {2'b0,{2{mem_wr_req_in}}}; 
            1'b1: halfword_wr_mask = {{2{mem_wr_req_in}},2'b0};
            default : begin halfword_wr_mask = {4{mem_wr_req_in}}; end
        endcase  
    end  
   end
    
   
endmodule
