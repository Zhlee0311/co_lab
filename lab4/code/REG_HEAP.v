`timescale 1ns / 1ps


module REG_HEAP (
    rst,
    clk_Regs,
    Reg_Write,
    R_Addr_A,
    R_Addr_B,
    W_Addr,
    W_Data,
    R_Data_A,
    R_Data_B
);

  input rst;
  input clk_Regs;
  input Reg_Write;
  input [4:0] R_Addr_A;
  input [4:0] R_Addr_B;
  input [4:0] W_Addr;
  input [31:0] W_Data;
  output [31:0] R_Data_A;
  output [31:0] R_Data_B;


  reg [31:0] REG_Files[0:31];

  integer i;

  always @(posedge rst or posedge clk_Regs) begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1) begin
        REG_Files[i] <= 32'h0000_0000;
      end
      REG_Files[1] <= 32'h0000_0001;
      REG_Files[2] <= 32'h0000_0002;
    end else begin
      if (Reg_Write && W_Addr != 5'b00000) REG_Files[W_Addr] <= W_Data;
    end
  end

  assign R_Data_A = (R_Addr_A == 5'b00000) ? 32'h0000_0000 : REG_Files[R_Addr_A];
  assign R_Data_B = (R_Addr_B == 5'b00000) ? 32'h0000_0000 : REG_Files[R_Addr_B];

endmodule
