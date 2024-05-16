`timescale 1ns / 1ps

//PC模块
module PC (
    rst,  //复位信号
    clk,  //PC的时钟信号
    en,  //PC的写使能信号
    out  //PC输出给IM的信号
);

  input rst;
  input clk;
  input en;
  output reg [5:0] out;


  wire [31:0]in;      //写入PC的信号
  reg [31:0] PC_tmp;  //作为PC的暂存信号，用于自增


  ADDER adder (
      .in (PC_tmp),
      .out(in)
  );


  always @(posedge rst or posedge clk) begin
    if (rst) begin
      PC_tmp <= 32'h0000_0000;
      out <= 6'b000000;
    end else if (en) begin
      PC_tmp <= in;
      out <= in[7:2];
    end
  end

endmodule


//PC的加法器模块
module ADDER (
    in,
    out
);
  input [31:0] in;
  output [31:0] out;
  assign out = (in == 32'h0000_00FC) ? 32'h0000_0000 : in + 32'h0000_0004;
endmodule
