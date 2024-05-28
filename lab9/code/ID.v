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

module ID1 (
    inst,
    rs1,
    rs2,
    rd,
    opcode,
    funct3,
    funct7,
    imm
);

  // 声明输入输出端口
  input [31:0] inst;
  output [4:0] rs1, rs2, rd;
  output [6:0] opcode, funct7;
  output [2:0] funct3;
  output reg [31:0] imm;

  // 输出端口赋值
  assign rs1 = inst[19:15];
  assign rs2 = inst[24:20];
  assign rd = inst[11:7];
  assign opcode = inst[6:0];
  assign funct3 = inst[14:12];
  assign funct7 = inst[31:25];

  // 生成各种格式的立即数
  wire [31:0] imm_I_shift, imm_I_other, imm_S, imm_B, imm_U, imm_J;  //各种格式的立即数
  assign imm_I_shift = {27'b0, inst[24:20]};  //imm_type=3'b001
  assign imm_I_other = {{20{inst[31]}}, inst[31:20]};  //imm_type=3'b010
  assign imm_S = {{20{inst[31]}}, inst[31:25], inst[11:7]};  //imm_type=3'b011
  assign imm_B = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};  //imm_type=3'b100
  assign imm_U = {inst[31:12], 12'b0};  //imm_type=3'b101
  assign imm_J = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};  //imm_type=3'b110

  reg [2:0] imm_type;  //立即数类型

  // 根据操作数选择立即数类型
  always @(*) begin
    case (opcode)
      `op_R: imm_type = 3'b000;
      `op_I_imm: begin
        if (funct3 == 3'b001 || funct3 == 3'b101) imm_type = 3'b001;  //移位运算
        else imm_type = 3'b010;
      end
      `op_I_load: imm_type = 3'b010;
      `op_I_jalr: imm_type = 3'b010;
      `op_U_lui: imm_type = 3'b101;
      `op_U_auipc: imm_type = 3'b101;
      `op_S: imm_type = 3'b011;
      `op_B: imm_type = 3'b100;
      `op_J: imm_type = 3'b110;
      default: imm_type = 3'b000;
    endcase

    case (imm_type)
      3'b000:  imm = 32'b0;
      3'b001:  imm = imm_I_shift;
      3'b010:  imm = imm_I_other;
      3'b011:  imm = imm_S;
      3'b100:  imm = imm_B;
      3'b101:  imm = imm_U;
      3'b110:  imm = imm_J;
      default: imm = 32'b0;
    endcase
  end

endmodule



module ID2 (
    opcode,
    funct3,
    funct7,
    IS_R,
    IS_IMM,
    IS_LUI,
    IS_LW,
    IS_SW,
    ALU_OP
);

  input [6:0] opcode, funct7;
  input [2:0] funct3;
  output IS_R, IS_IMM, IS_LUI, IS_LW, IS_SW;
  output reg [3:0] ALU_OP;


  assign IS_R   = (opcode == `op_R) ? 1 : 0;
  assign IS_IMM = (opcode == `op_I_imm) ? 1 : 0;
  assign IS_LUI = (opcode == `op_U_lui) ? 1 : 0;
  assign IS_LW  = (opcode == `op_I_load && funct3 == 3'b010) ? 1 : 0;
  assign IS_SW  = (opcode == `op_S && funct3 == 3'b010) ? 1 : 0;


  always @(*) begin
    if (IS_R) begin
      ALU_OP = {funct7[5], funct3};
    end else if (IS_IMM) begin
      ALU_OP = (funct3 == 3'b101) ? {funct7[5], funct3} : {1'b0, funct3};
    end else begin
      ALU_OP = 4'b0000;
    end
  end

endmodule
