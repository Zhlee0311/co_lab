`timescale 1ns / 1ps

module ALU_REG (
    OP,
    rs2_imm_s,
    Data_A,
    Data_B,
    imm,
    rst,
    clk_RR,
    clk_F,
    A,
    B,
    F,
    FR
);
  input [3:0] OP;
  input rs2_imm_s;
  input [31:0] Data_A, Data_B, imm;
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
      .OP(OP),
      .X (A),
      .Y (rs2_imm_s ? imm : B),
      .F (F_tmp),
      .ZF(ZF),
      .CF(CF),
      .OF(OF),
      .SF(SF)
  );

  REG R_F (
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





module ALU (
    OP,
    X,  //第一个运算数
    Y,  //第二个运算数
    F,  //运算结果
    ZF,
    CF,
    OF,
    SF
);

  input [3:0] OP;
  input [31:0] X, Y;
  output reg [31:0] F;
  output ZF, CF, OF, SF;

  integer i;
  reg C;

  assign ZF = (F == 32'h0000_0000) ? 1 : 0;
  assign CF = C;
  assign OF = X[31] ^ Y[31] ^ C ^ F[31];
  assign SF = F[31];


  always @(*) begin
    case (OP)
      4'b0000: {C, F} = {1'b0, X} + {1'b0, Y};
      4'b0001: F = X << Y;
      4'b0010: F = $signed(X) < $signed(Y) ? 1 : 0;
      4'b0011: F = X < Y ? 1 : 0;
      4'b0100: F = X ^ Y;
      4'b0101: F = X >> Y;
      4'b0110: F = X | Y;
      4'b0111: F = X & Y;
      4'b1000: {C, F} = {1'b0, X} - {1'b0, Y};
      4'b1101: begin
        F = X;
        for (i = 0; i < Y && i < 32; i = i + 1'b1) begin
          F = {F[31], F[31:1]};
        end
      end
      default: F = 0;
    endcase
  end

endmodule


module REG (
    clk,
    rst,
    in,
    out
);

  input clk, rst;
  input [31:0] in;
  output reg [31:0] out;

  always @(posedge rst or posedge clk) begin
    if (rst) out <= 32'h0000_0000;
    else out <= in;
  end
endmodule
