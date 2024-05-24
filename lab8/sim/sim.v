`timescale 1ns / 1ps

module sim;

  reg clk_H4;
  reg clk;
  reg rst;
  reg [2:0] SW;
  wire [3:0] FR;
  wire [2:0] ST;
  wire [3:0] which;
  wire [7:0] seg;
  wire [31:0] inst_test;



  TOP_TEST uut (
      .clk_H4(clk_H4),
      .clk(clk),
      .rst(rst),
      .SW(SW),
      .FR(FR),
      .ST(ST),
      .which(which),
      .seg(seg),
      .inst_test(inst_test)
  );

  always begin
    #2 clk_H4 = ~clk_H4;
  end


  initial begin
    clk_H4 = 0;
    clk = 0;
    rst = 1;
    SW = 3'b001;
    #1 rst = 0;
    repeat (100000) begin
      #10 clk = ~clk;
    end
  end

endmodule


module TOP_TEST (
    clk_H4,  //数码管扫描时钟
    clk,
    rst,
    SW,
    FR,
    ST,
    which,
    seg,
    inst_test
);


  input clk_H4, clk, rst;
  input [2:0] SW;
  output [3:0] FR;
  output [2:0] ST;
  output [3:0] which;
  output [7:0] seg;


  wire clk_n;
  assign clk_n = ~clk;


  wire IS_R, IS_IMM, IS_LUI;
  wire PC_Write, IR_Write, Reg_Write;
  wire rs2_imm_s, w_data_s;
  wire [ 3:0] OP;
  wire [ 3:0] ALU_OP;
  wire [ 5:0] PC_out;
  wire [31:0] IM_out;


  wire [ 2:0] funct3;
  wire [6:0] opcode, funct7;
  wire [4:0] rs1, rs2, rd;
  wire [31:0] imm;
  wire [31:0] inst;
  wire [31:0] W_Data;

  wire [31:0] Data_A, Data_B;
  wire [31:0] A, B, F;

  reg [31:0] data;


  output [31:0] inst_test;
  assign inst_test = inst;


  always @(*) begin
    case (SW)
      3'b000:  data = {26'b0, PC_out};
      3'b001:  data = inst;
      3'b010:  data = W_Data;
      3'b011:  data = A;
      3'b100:  data = B;
      3'b101:  data = F;
      default: data = 32'h0000_0000;
    endcase
  end


  assign W_Data = (w_data_s == 1) ? imm : F;


  //数码管显示
  DISPLAY display (
      .clk  (clk_H4),
      .data (data),
      .which(which),
      .seg  (seg)
  );


  //控制单元
  CU cu (
      .rst(rst),
      .clk(clk_n),
      .IS_R(IS_R),
      .IS_IMM(IS_IMM),
      .IS_LUI(IS_LUI),
      .ALU_OP(ALU_OP),
      .PC_Write(PC_Write),
      .IR_Write(IR_Write),
      .Reg_Write(Reg_Write),
      .rs2_imm_s(rs2_imm_s),
      .w_data_s(w_data_s),
      .OP(OP),
      .ST(ST)
  );

  //程序计数器
  PC pc (
      .rst(rst),
      .clk(clk_n),
      .en (PC_Write),
      .out(PC_out)
  );


  //指令存储器
  ROM_B rom_b (
      .clka (clk),
      .addra(PC_out),
      .douta(IM_out)
  );

  //指令寄存器
  IR ir (
      .rst(rst),
      .clk(clk_n),
      .en (IR_Write),
      .in (IM_out),
      .out(inst)
  );

  //初级译码
  ID1 id1 (
      .inst(inst),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .opcode(opcode),
      .funct3(funct3),
      .funct7(funct7),
      .imm(imm)
  );

  //二级译码
  ID2 id2 (
      .opcode(opcode),
      .funct3(funct3),
      .funct7(funct7),
      .IS_R  (IS_R),
      .IS_IMM(IS_IMM),
      .IS_LUI(IS_LUI),
      .ALU_OP(ALU_OP)
  );

  //寄存器堆
  REG_HEAP reg_heap (
      .rst(rst),
      .clk(clk_n),
      .en(Reg_Write),
      .R_Addr_A(rs1),
      .R_Addr_B(rs2),
      .W_Addr(rd),
      .W_Data(W_Data),
      .R_Data_A(Data_A),
      .R_Data_B(Data_B)
  );


  ALU_REG alu_reg (
      .OP(OP),
      .rs2_imm_s(rs2_imm_s),
      .Data_A(Data_A),
      .Data_B(Data_B),
      .imm(imm),
      .rst(rst),
      .clk_RR(clk_n),
      .clk_F(clk_n),
      .A(A),
      .B(B),
      .F(F),
      .FR(FR)
  );


endmodule
