`timescale 1ns / 1ps

module sim;

  reg rst, clk;

  wire clk_n_test;
  wire [2:0] ST;
  wire [3:0] FR;
  wire IS_R, IS_IMM, IS_LUI;
  wire PC_Write, IR_Write, Reg_Write;
  wire rs2_imm_s, w_data_s;
  wire [3:0] ALU_OP, OP;

  wire [ 5:0] PC_out;
  wire [31:0] IM_out;

  wire [ 2:0] funct3;
  wire [6:0] opcode, funct7;
  wire [4:0] rs1, rs2, rd;
  wire [31:0] inst, imm;

  wire [31:0] Data_A, Data_B;
  wire [31:0] A, B, F, W_Data;

  TOP_SIM uut (
      .rst(rst),
      .clk(clk),
      .clk_n_test(clk_n_test),
      .ST(ST),
      .FR(FR),
      .IS_R(IS_R),
      .IS_IMM(IS_IMM),
      .IS_LUI(IS_LUI),
      .PC_Write(PC_Write),
      .IR_Write(IR_Write),
      .Reg_Write(Reg_Write),
      .rs2_imm_s(rs2_imm_s),
      .w_data_s(w_data_s),
      .ALU_OP(ALU_OP),
      .OP(OP),
      .PC_out(PC_out),
      .IM_out(IM_out),
      .funct3(funct3),
      .opcode(opcode),
      .funct7(funct7),
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

  initial begin
    rst = 1;
    clk = 0;
    #2 rst = 0;
    repeat (100000) begin
      #10 clk = ~clk;
    end
  end


endmodule



module TOP_SIM (
    rst,
    clk,
    clk_n_test,
    ST,
    FR,
    IS_R,
    IS_IMM,
    IS_LUI,
    PC_Write,
    IR_Write,
    Reg_Write,
    rs2_imm_s,
    w_data_s,
    ALU_OP,
    OP,
    PC_out,
    IM_out,
    funct3,
    opcode,
    funct7,
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
  output clk_n_test;
  output [2:0] ST;
  output [3:0] FR;
  output IS_R, IS_IMM, IS_LUI;
  output PC_Write, IR_Write, Reg_Write;
  output rs2_imm_s, w_data_s;
  output [3:0] ALU_OP, OP;
  output [5:0] PC_out;
  output [31:0] IM_out;
  output [2:0] funct3;
  output [6:0] opcode, funct7;
  output [4:0] rs1, rs2, rd;
  output [31:0] inst, imm;
  output [31:0] Data_A, Data_B;
  output [31:0] A, B, F, W_Data;

  wire clk_n;
  assign clk_n = ~clk;
  assign clk_n_test = clk_n;

  assign W_Data = (w_data_s == 1) ? imm : F;

  //PC-程序计数器
  PC pc (
      .rst(rst),
      .clk(clk_n),
      .en (PC_Write),
      .out(PC_out)
  );

  //IM-指令存储器
  ROM_B rom_b (
      .clka (clk),
      .addra(PC_out),
      .douta(IM_out)
  );

  //IR-指令寄存器
  IR ir (
      .rst(rst),
      .clk(clk_n),
      .en (IR_Write),
      .in (IM_out),
      .out(inst)
  );

  //ID1-初级译码
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

  //ID2-次级译码
  ID2 id2 (
      .opcode(opcode),
      .funct3(funct3),
      .funct7(funct7),
      .IS_R  (IS_R),
      .IS_IMM(IS_IMM),
      .IS_LUI(IS_LUI),
      .ALU_OP(ALU_OP)
  );

  //CU-控制单元
  CU cu (
      .rst(rst),
      .clk(clk),
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

  //REG_HEAP-寄存器堆
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

  //ALU_REG-带有暂存器的ALU
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
