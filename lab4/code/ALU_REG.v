`timescale 1ns / 1ps

module ALU_REG (
    ALU_OP,
    Data_A,
    Data_B,
    rst,
    clk_RR,
    clk_F,
    A,
    B,
    F,
    FR
);

  input [3:0] ALU_OP;
  input [31:0] Data_A, Data_B;
  input rst, clk_RR, clk_F;
  output [31:0] A, B, F;
  output [3:0] FR;


  wire [31:0] F_tmp;
  wire ZF, CF, OF, SF;


  REG R_A (
      .clk(clk_RR),
      .rst(rst),
      .in (Data_A),
      .out(A)
  );

  REG R_B (
      .clk(clk_RR),
      .rst(rst),
      .in (Data_B),
      .out(B)
  );

  ALU alu (
      .OP(ALU_OP),
      .A (A),
      .B (B),
      .F (F_tmp),
      .ZF(ZF),
      .CF(CF),
      .OF(OF),
      .SF(SF)
  );

  REG REG_F (
      .clk(clk_F),
      .rst(rst),
      .in (F_tmp),
      .out(F)
  );


  REG R_FR (
      .clk(clk_F),
      .rst(rst),
      .in ({28'b0, ZF, CF, OF, SF}),
      .out(FR)
  );


endmodule
