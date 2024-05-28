`timescale 1ns / 1ps

module sim;

  reg rst, clk;

  wire [3:0] ST, FR;
  wire IS_R, IS_IMM, IS_LUI, IS_LW, IS_SW;
  wire PC_Write, IR_Write, Reg_Write, Mem_Write, rs2_imm_s;
  wire [1:0] w_data_s;
  wire [3:0] ALU_OP, OP;
  wire [5:0] PC_out;
  wire [31:0] IM_out, DM_out;
  wire [31:0] MDR_out;
  wire [ 2:0] funct3;
  wire [6:0] funct7, opcode;
  wire [4:0] rs1, rs2, rd;
  wire [31:0] inst, imm;
  wire [31:0] Data_A, Data_B, A, B, F, W_Data;

  RIUS_CPU uut (
      .rst(rst),
      .clk(clk),
      .ST(ST),
      .FR(FR),
      .IS_R(IS_R),
      .IS_IMM(IS_IMM),
      .IS_LUI(IS_LUI),
      .IS_LW(IS_LW),
      .IS_SW(IS_SW),
      .PC_Write(PC_Write),
      .IR_Write(IR_Write),
      .Reg_Write(Reg_Write),
      .Mem_Write(Mem_Write),
      .rs2_imm_s(rs2_imm_s),
      .w_data_s(w_data_s),
      .ALU_OP(ALU_OP),
      .OP(OP),
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

  initial begin
    rst = 1;
    clk = 0;
    #2 rst = 0;
    repeat (10000) begin
      #10 clk = ~clk;
    end
  end



endmodule
