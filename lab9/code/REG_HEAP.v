`timescale 1ns / 1ps

module REG_HEAP (
    rst,
    clk,
    en,
    R_Addr_A,
    R_Addr_B,
    W_Addr,
    W_Data,
    R_Data_A,
    R_Data_B
);

  input rst, clk, en;
  input [4:0] R_Addr_A, R_Addr_B, W_Addr;
  input [31:0] W_Data;
  output [31:0] R_Data_A, R_Data_B;


  reg [31:0] REG_Files[0:31];


  integer i;

  always @(posedge rst or posedge clk) begin
    if (rst) begin
      for (i = 0; i <= 31; i = i + 1) begin
        REG_Files[i] <= 32'h0000_0000;
      end
    end else begin
      if (en && W_Addr != 0) REG_Files[W_Addr] <= W_Data;
    end
  end

  assign R_Data_A = (R_Addr_A == 5'b00000) ? 32'h0000_0000 : REG_Files[R_Addr_A];
  assign R_Data_B = (R_Addr_B == 5'b00000) ? 32'h0000_0000 : REG_Files[R_Addr_B];


endmodule
