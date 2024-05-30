`timescale 1ns / 1ps


module MDR (
    rst,
    clk,
    in,
    out
);

  input rst, clk;
  input [31:0] in;
  output reg [31:0] out;

  always @(posedge rst or posedge clk) begin
    if (rst) begin
      out <= 32'h0000_0000;
    end else begin
      out <= in;
    end
  end

endmodule