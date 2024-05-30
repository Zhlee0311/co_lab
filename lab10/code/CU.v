`timescale 1ns / 1ps

`define Idle 4'b0000
`define S1 4'b0001
`define S2 4'b0010
`define S3 4'b0011
`define S4 4'b0100
`define S5 4'b0101
`define S6 4'b0110
`define S7 4'b0111
`define S8 4'b1000
`define S9 4'b1001
`define S10 4'b1010
`define S11 4'b1011
`define S12 4'b1100
`define S13 4'b1101
`define S14 4'b1110


module CU (
    rst,
    clk,
    IS_R,
    IS_IMM,
    IS_LUI,
    IS_LW,
    IS_SW,
    IS_BEQ,
    IS_JAL,
    IS_JALR,
    ALU_OP,
    ZF,
    PC_Write,
    PC0_Write,
    IR_Write,
    Reg_Write,
    Mem_Write,
    rs2_imm_s,
    w_data_s,
    PC_s,
    OP,
    ST
);

  input rst, clk;
  input IS_R, IS_IMM, IS_LUI, IS_LW, IS_SW, IS_BEQ, IS_JAL, IS_JALR;
  input [3:0] ALU_OP;
  input ZF;

  output reg PC_Write, PC0_Write, IR_Write, Reg_Write, rs2_imm_s;
  output Mem_Write;  //由于Mem_Write需要连续赋值，因此将其定义为wire型
  output reg [1:0] w_data_s, PC_s;
  output reg [3:0] OP, ST;

  reg [3:0] Next_ST;
  assign Mem_Write = (Next_ST == `S10);

  always @(posedge rst or posedge clk) begin
    if (rst) begin
      ST <= `Idle;
    end else begin
      ST <= Next_ST;
    end
  end


  always @(*) begin
    Next_ST = `Idle;
    case (ST)
      `Idle: begin
        Next_ST = `S1;
      end
      `S1: begin
        if (IS_LUI) begin
          Next_ST = `S6;
        end else if (IS_JAL) begin
          Next_ST = `S11;
        end else begin
          Next_ST = `S2;
        end
      end
      `S2: begin
        if (IS_R) begin
          Next_ST = `S3;
        end else if (IS_IMM) begin
          Next_ST = `S5;
        end else if (IS_BEQ) begin
          Next_ST = `S13;
        end else begin
          Next_ST = `S7;
        end
      end
      `S3: begin
        Next_ST = `S4;
      end
      `S4: begin
        Next_ST = `S1;
      end
      `S5: begin
        Next_ST = `S4;
      end
      `S6: begin
        Next_ST = `S1;
      end
      `S7: begin
        if (IS_LW) begin
          Next_ST = `S8;
        end else if (IS_SW) begin
          Next_ST = `S10;
        end else begin
          Next_ST = `S12;
        end
      end
      `S8: begin
        Next_ST = `S9;
      end
      `S9: begin
        Next_ST = `S1;
      end
      `S10: begin
        Next_ST = `S1;
      end
      `S11: begin
        Next_ST = `S1;
      end
      `S12: begin
        Next_ST = `S1;
      end
      `S13: begin
        Next_ST = `S14;
      end
      `S14: begin
        Next_ST = `S1;
      end
      default: Next_ST = `S1;
    endcase
  end


  always @(posedge rst or posedge clk) begin
    if (rst) begin
      PC_Write  <= 1'b0;
      PC0_Write <= 1'b0;
      IR_Write  <= 1'b0;
      Reg_Write <= 1'b0;
      rs2_imm_s <= 1'b0;
      w_data_s  <= 2'b00;
      PC_s      <= 2'b00;
      OP        <= 4'b0000;
    end else begin
      case (Next_ST)
        `S1: begin
          PC_Write  <= 1'b1;
          PC0_Write <= 1'b1;
          IR_Write  <= 1'b1;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b00;
          PC_s      <= 2'b00;
          OP        <= 4'b0000;
        end
        `S2: begin
          PC_Write  <= 1'b0;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b00;
          PC_s      <= 2'b00;
          OP        <= 4'b0000;
        end
        `S3: begin
          PC_Write  <= 1'b0;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b00;
          PC_s      <= 2'b00;
          OP        <= ALU_OP;
        end
        `S4: begin
          PC_Write  <= 1'b0;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b1;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b00;
          PC_s      <= 2'b00;
          OP        <= 4'b0000;
        end
        `S5: begin
          PC_Write  <= 1'b0;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b1;
          w_data_s  <= 2'b00;
          PC_s      <= 2'b00;
          OP        <= ALU_OP;
        end
        `S6: begin
          PC_Write  <= 1'b0;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b1;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b01;
          PC_s      <= 2'b00;
          OP        <= 4'b0000;
        end
        `S7: begin
          PC_Write  <= 1'b0;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b1;
          w_data_s  <= 2'b00;
          PC_s      <= 2'b00;
          OP        <= 4'b0000;
        end
        `S8: begin
          PC_Write  <= 1'b0;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b00;
          PC_s      <= 2'b00;
          OP        <= 4'b0000;
        end
        `S9: begin
          PC_Write  <= 1'b0;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b1;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b10;
          PC_s      <= 2'b00;
          OP        <= 4'b0000;
        end
        `S10: begin
          PC_Write  <= 1'b0;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b00;
          PC_s      <= 2'b00;
          OP        <= 4'b0000;
        end
        `S11: begin
          PC_Write  <= 1'b1;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b1;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b11;
          PC_s      <= 2'b01;
          OP        <= 4'b0000;
        end
        `S12: begin
          PC_Write  <= 1'b1;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b1;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b11;
          PC_s      <= 2'b10;
          OP        <= 4'b0000;
        end
        `S13: begin
          PC_Write  <= 1'b0;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b00;
          PC_s      <= 2'b00;
          OP        <= 4'b1000;
        end
        `S14: begin
          PC_Write  <= ZF;
          PC0_Write <= 1'b0;
          IR_Write  <= 1'b0;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b0;
          w_data_s  <= 2'b00;
          PC_s      <= 2'b01;
          OP        <= 4'b0000;
        end
      endcase
    end
  end

endmodule

