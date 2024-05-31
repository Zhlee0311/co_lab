`timescale 1ns / 1ps

module RIUSJB_CPU (
    rst,
    clk,
    ST,
    FR,
    IS_R,
    IS_IMM,
    IS_LUI,
    IS_LW,
    IS_SW,
    IS_BEQ,
    IS_JAL,
    IS_JALR,
    PC_Write,
    PC0_Write,
    IR_Write,
    Reg_Write,
    Mem_Write,
    rs2_imm_s,
    w_data_s,
    PC_s,
    ALU_OP,
    OP,
    PC_now,
    PC_out,
    IM_out,
    DM_out,
    MDR_out,
    funct3,
    funct7,
    opcode,
    rs1,
    rs2,
    rd,
    inst,
    imm,
    Data_A,
    Data_B,
    A,
    B,
    F,
    W_Data
);

  input rst, clk;
  wire clk_n;
  assign clk_n = ~clk;  //clk的反相信号

  output [3:0] ST, FR;
  output IS_R, IS_IMM, IS_LUI, IS_LW, IS_SW, IS_BEQ, IS_JAL, IS_JALR;
  output PC_Write, PC0_Write, IR_Write, Reg_Write, Mem_Write, rs2_imm_s;
  output [1:0] w_data_s, PC_s;
  output [3:0] ALU_OP, OP;

  output [31:0] PC_now;
  output [5:0] PC_out;
  output [31:0] IM_out, DM_out, MDR_out;

  output [2:0] funct3;
  output [6:0] funct7, opcode;
  output [4:0] rs1, rs2, rd;
  output [31:0] inst, imm;

  output [31:0] Data_A, Data_B, A, B, F;
  output reg [31:0] W_Data;

  always @(*) begin
    case (w_data_s)
      2'b00:   W_Data = F;
      2'b01:   W_Data = imm;
      2'b10:   W_Data = MDR_out;
      2'b11:   W_Data = PC_now;
      default: W_Data = 32'h0000_0000;
    endcase
  end

  PC pc (
      .rst(rst),
      .clk(clk_n),
      .en_PC(PC_Write),
      .en_PC0(PC0_Write),
      .PC_s(PC_s),
      .imm(imm),
      .F(F),
      .PC_now(PC_now),
      .out(PC_out)
  );


  ROM im (
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


  ID2 id2 (
      .opcode(opcode),
      .funct3(funct3),
      .funct7(funct7),
      .IS_R(IS_R),
      .IS_IMM(IS_IMM),
      .IS_LUI(IS_LUI),
      .IS_LW(IS_LW),
      .IS_SW(IS_SW),
      .IS_BEQ(IS_BEQ),
      .IS_JAL(IS_JAL),
      .IS_JALR(IS_JALR),
      .ALU_OP(ALU_OP)
  );


  CU cu (
      .rst(rst),
      .clk(clk),
      .IS_R(IS_R),
      .IS_IMM(IS_IMM),
      .IS_LUI(IS_LUI),
      .IS_LW(IS_LW),
      .IS_SW(IS_SW),
      .IS_BEQ(IS_BEQ),
      .IS_JAL(IS_JAL),
      .IS_JALR(IS_JALR),
      .ALU_OP(ALU_OP),
      .ZF(FR[3]),
      .PC_Write(PC_Write),
      .PC0_Write(PC0_Write),
      .IR_Write(IR_Write),
      .Reg_Write(Reg_Write),
      .Mem_Write(Mem_Write),
      .rs2_imm_s(rs2_imm_s),
      .w_data_s(w_data_s),
      .PC_s(PC_s),
      .OP(OP),
      .ST(ST)
  );


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

  RAM dm (
      .clka (clk),
      .wea  (Mem_Write),
      .addra(F[7:2]),
      .dina (B),
      .douta(DM_out)
  );


  MDR mdr (
      .rst(rst),
      .clk(clk_n),
      .in (DM_out),
      .out(MDR_out)
  );

endmodule
