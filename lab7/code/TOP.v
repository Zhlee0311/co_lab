`timescale 1ns / 1ps


module TOP (
    rst,  //复位信号
    clk_im,  //整个模块的时钟信号
    clk,  //板卡芯片的时钟信号
    IR_Write,
    PC_Write,
    rs1,
    rs2,
    rd,
    opcode,
    funct3,
    funct7,
    which,
    seg
);

  input rst, clk_im, clk, IR_Write, PC_Write;
  output [4:0] rs1, rs2, rd;
  output [6:0] opcode;
  output [2:0] funct3;
  output [6:0] funct7;
  output [3:0] which;
  output [7:0] seg;


wire [31:0]inst;
wire [31:0]imm;


IF u_if(
    .rst(rst),
    .clk(clk_im),
    .IR_Write(IR_Write),
    .PC_Write(PC_Write),
    .inst(inst)
);

ID1 u_id1(
    .inst(inst),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .imm(imm)
);

DISPLAY u_display(
    .clk(clk),
    .data(imm),
    .which(which),
    .seg(seg)
);


endmodule
