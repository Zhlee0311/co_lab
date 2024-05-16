`timescale 1ns / 1ps


module IF (
    rst,  //复位信号
    clk,  //整个取指令模块的时钟信号
    IR_Write,
    PC_Write,
    inst
);

  input rst;
  input clk;
  input IR_Write;
  input PC_Write;
  output [31:0] inst;


  assign clk_n = ~clk;
  wire [ 5:0] PC_out;
  wire [31:0] IM_out;


  PC pc (
      .rst(rst),
      .clk(clk_n),
      .en (PC_Write),
      .out(PC_out)
  );

  ROM_B rom_b (
      .clka (clk),
      .addra(PC_out),
      .douta(IM_out)
  );

  IR ir (
      .rst(rst),
      .clk(clk_n),
      .en (IR_Write),
      .in (IM_out),
      .out(inst)
  );


endmodule
