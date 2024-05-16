`timescale 1ns / 1ps


module IR (
    rst,  //复位信号
    clk,  //IR的时钟信号
    en,  //IR的写使能信号
    in,  //写入IR的信号
    out  //IR输出给ID1的信号
);
  input rst;
  input clk;
  input en;
  input [31:0] in;
  output reg [31:0] out;

  always @(posedge rst or posedge clk) begin
    if (rst) begin
      out <= 32'h0000_0013;  //riscv的空操作码：addi x0,x0,0
    end else if (en) begin
      out <= in;
    end
  end

endmodule
