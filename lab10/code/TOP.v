`timescale 1ns / 1ps


module TOP (
    clk_H4,  //数码管的时钟信号
    rst,
    clk,
    SW,
    FR,
    ST,
    which,
    seg
);
  input clk_H4, rst, clk;
  input [3:0] SW;

  output [3:0] FR, ST;
  output [3:0] which;
  output [7:0] seg;

  wire IS_R, IS_IMM, IS_LUI, IS_LW, IS_SW, IS_BEQ, IS_JAL, IS_JALR;
  wire PC_Write, PC0_Write, IR_Write, Reg_Write, Mem_Write, rs2_imm_s;
  wire [1:0] w_data_s, PC_s;
  wire [3:0] ALU_OP, OP;

  wire [31:0] PC_now;
  wire [ 5:0] PC_out;
  wire [31:0] IM_out, DM_out, MDR_out;

  wire [2:0] funct3;
  wire [6:0] funct7, opcode;
  wire [4:0] rs1, rs2, rd;
  wire [31:0] inst, imm;

  wire [31:0] Data_A, Data_B, A, B, F, W_Data;


  reg [31:0] data;
  always @(*) begin
    case (SW)
      4'b0000: data = inst;  //当前指令
      4'b0001: data = imm;  //当前指令对应的立即数
      4'b0010: data = PC_now;  //PC（下一条指令的地址，32位）
      4'b0011: data = {26'b0, PC_out};  //PC的字地址（6位，因为存储器只有64个存储单元）
      4'b0100: data = IM_out;  //下一条指令
      4'b0101: data = A;
      4'b0110: data = B;
      4'b0111: data = F;
      4'b1000: data = MDR_out;
      4'b1001: data = W_Data;
      default: data = 32'h0000_0000;
    endcase
  end


  RIUSJB_CPU riusjb_cpu (
      .rst(rst),
      .clk(clk),
      .ST(ST),
      .FR(FR),
      .IS_R(IS_R),
      .IS_IMM(IS_IMM),
      .IS_LUI(IS_LUI),
      .IS_LW(IS_LW),
      .IS_SW(IS_SW),
      .IS_BEQ(IS_BEQ),
      .IS_JAL(IS_JAL),
      .IS_JALR(IS_JALR),
      .PC_Write(PC_Write),
      .PC0_Write(PC0_Write),
      .IR_Write(IR_Write),
      .Reg_Write(Reg_Write),
      .Mem_Write(Mem_Write),
      .rs2_imm_s(rs2_imm_s),
      .w_data_s(w_data_s),
      .PC_s(PC_s),
      .ALU_OP(ALU_OP),
      .OP(OP),
      .PC_now(PC_now),
      .PC_out(PC_out),
      .IM_out(IM_out),
      .DM_out(DM_out),
      .MDR_out(MDR_out),
      .funct3(funct3),
      .funct7(funct7),
      .opcode(opcode),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .inst(inst),
      .imm(imm),
      .Data_A(Data_A),
      .Data_B(Data_B),
      .A(A),
      .B(B),
      .F(F),
      .W_Data(W_Data)
  );

  DISPLAY display (
      .clk  (clk_H4),
      .data (data),
      .which(which),
      .seg  (seg)
  );



endmodule
