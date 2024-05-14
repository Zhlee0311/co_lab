`timescale 1ns / 1ps

module REG (
    clk,
    rst,
    in,
    out
);

  input clk, rst;
  input [31:0] in;
  output reg [31:0] out;

  always @(posedge rst or posedge clk) begin
    if (rst) out <= 32'h0000_0000;
    else out <= in;
  end
endmodule
