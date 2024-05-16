`timescale 1ns / 1ps
/*以下为37条RV32I指令的操作码的宏定义*/
`define op_R 7'b0110011 //R型指令的操作码，10条
`define op_I_imm 7'b0010011 //I型立即数运算指令的操作码，普通运算6条，移位运算3条，共9条
`define op_I_load 7'b0000011 //I型装数指令的操作码，5条
`define op_I_jalr 7'b1100111 //I型指令"jalr"的操作码，1条
`define op_U_lui 7'b0110111 //U型指令"lui"的操作码，1条
`define op_U_auipc 7'b0010111 //U型指令"auipc"的操作码，1条
`define op_S 7'b0100011 //S型指令的操作码，3条
`define op_B 7'b1100011 //B型指令的操作码，6条
`define op_J 7'b1101111 //J型指令"jal"的操作码，1条
/*以上为37条RV32I指令的操作码的宏定义*/

module ID1(
    inst,  //待译码的指令
    rs1,
    rs2,
    rd,
    opcode,
    funct3,
    funct7,
    imm
);

  input [31:0]inst;
  output [4:0]rs1;
  output [4:0]rs2;
  output [4:0]rd;
  output [6:0]opcode;
  output [2:0]funct3;
  output [6:0]funct7;
  output reg[31:0]imm;

  assign rs1=inst[19:15];
  assign rs2=inst[24:20];
  assign rd=inst[11:7];
  assign opcode=inst[6:0];
  assign funct3=inst[14:12];
  assign funct7=inst[31:25];

  assign imm_I_shift={27'b0,inst[24:20]};//imm_type=001
  assign imm_I_other={{20{inst[31]}},inst[31:20]};//imm_type=010
  assign imm_S={{20{inst[31]}},inst[31:25],inst[11:7]};//imm_type=011
  assign imm_B={{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};//imm_type=100
  assign imm_U={inst[31:12],12'b0};//imm_type=101
  assign imm_J={{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};//imm_type=110
  

  reg [2:0]imm_type;//立即数类型

always@(*)begin
  case(opcode)
      `op_R:
          imm_type=3'b000;
      `op_I_imm:begin
          if(funct3==3'b001||funct3==3'b101)
              imm_type=3'b001;//移位运算
          else
              imm_type=3'b010;
      end
      `op_I_load:
          imm_type=3'b010;
      `op_I_jalr:
          imm_type=3'b010;
      `op_U_lui:
          imm_type=3'b101;
      `op_U_auipc:
          imm_type=3'b101;
      `op_S:
          imm_type=3'b011;
      `op_B:
          imm_type=3'b100;
      `op_J:
          imm_type=3'b110;
      default:
          imm_type=3'b000;
  endcase

  case(imm_type)
      3'b000:
          imm=32'h0000_0000;//R型指令无立即数，默认置为0
      3'b001:
          imm=imm_I_shift;
      3'b010:
          imm=imm_I_other;
      3'b011:
          imm=imm_S;
      3'b100:
          imm=imm_B;
      3'b101:
          imm=imm_U;
      3'b110:
          imm=imm_J;
      default:
          imm=32'h0000_0000;
  endcase
end

endmodule











