`timescale 1ns / 1ps

module TOP (
    clk,  //芯片时钟信号
    rst,  //复位信号
    clk_RR,  //ALU暂存器时钟信号
    clk_F,
    clk_WB,  //Write Back时钟信号
    R_Addr_A,
    R_Addr_B,
    W_Addr,
    ALU_OP,
    Reg_Write,
    leds,  //标志位接入led灯
    which,
    seg
);

  input clk, rst, clk_RR, clk_F, clk_WB;
  input [4:0] R_Addr_A, R_Addr_B, W_Addr;
  input [3:0] ALU_OP;
  input Reg_Write;
  output [3:0] leds;
  output [3:0] which;
  output [7:0] seg;



  wire [31:0] Data_A, Data_B, A, B, F;


  REG_HEAP u1 (
      .rst(rst),
      .clk_Regs(clk_WB),
      .Reg_Write(Reg_Write),
      .R_Addr_A(R_Addr_A),
      .R_Addr_B(R_Addr_B),
      .W_Addr(W_Addr),
      .W_Data(F),
      .R_Data_A(Data_A),
      .R_Data_B(Data_B)
  );


  ALU_REG u2 (
      .ALU_OP(ALU_OP),
      .Data_A(Data_A),
      .Data_B(Data_B),
      .rst(rst),
      .clk_RR(clk_RR),
      .clk_F(clk_F),
      .A(A),
      .B(B),
      .F(F),
      .FR(leds)
  );


  DISPLAY u3 (
      .clk  (clk),
      .data (F),
      .which(which),
      .seg  (seg)
  );


endmodule
