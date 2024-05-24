`timescale 1ns / 1ps

`define Idle 3'b000
`define S1 3'b001
`define S2 3'b010
`define S3 3'b011
`define S4 3'b100
`define S5 3'b101
`define S6 3'b110


module CU (
    rst,
    clk,
    IS_R,
    IS_IMM,
    IS_LUI,
    ALU_OP,
    PC_Write,
    IR_Write,
    Reg_Write,
    rs2_imm_s,
    w_data_s,
    OP,
    ST
);

  input rst, clk;
  input IS_R, IS_IMM, IS_LUI;
  input [3:0] ALU_OP;
  output reg PC_Write, IR_Write, Reg_Write;
  output reg rs2_imm_s, w_data_s;
  output reg [3:0] OP;
  output reg [2:0] ST;


  reg [2:0] Next_ST;

  //状态更新
  always @(posedge rst or posedge clk) begin
    if (rst) begin
      ST <= `Idle;
    end else begin
      ST <= Next_ST;
    end
  end


  //状态转移
  always @(*) begin
    Next_ST = `Idle;
    case (ST)
      `Idle: begin
        Next_ST = `S1;
      end
      `S1: begin
        if (IS_LUI) Next_ST = `S6;
        else Next_ST = `S2;
      end
      `S2: begin
        if (IS_R) Next_ST = `S3;
        else Next_ST = `S5;
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
      default: Next_ST = `S1;
    endcase
  end


  //控制信号序列
  always @(posedge rst or posedge clk) begin
    if (rst) begin
      PC_Write <= 1'b0;
      IR_Write <= 1'b0;
      Reg_Write <= 1'b0;
      rs2_imm_s <= 1'b0;
      w_data_s <= 1'b0;
      OP <= 4'b0000;
    end else begin
      case (Next_ST)
        `S1: begin
          PC_Write <= 1'b1;
          IR_Write <= 1'b1;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b0;
          w_data_s <= 1'b0;
          OP <= 4'b0000;
        end
        `S2: begin
          PC_Write <= 1'b0;
          IR_Write <= 1'b0;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b0;
          w_data_s <= 1'b0;
          OP <= 4'b0000;
        end
        `S3: begin
          PC_Write <= 1'b0;
          IR_Write <= 1'b0;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b0;
          w_data_s <= 1'b0;
          OP <= ALU_OP;
        end
        `S4: begin
          PC_Write <= 1'b0;
          IR_Write <= 1'b0;
          Reg_Write <= 1'b1;
          rs2_imm_s <= 1'b0;
          w_data_s <= 1'b0;
          OP <= 4'b0000;
        end
        `S5: begin
          PC_Write <= 1'b0;
          IR_Write <= 1'b0;
          Reg_Write <= 1'b0;
          rs2_imm_s <= 1'b1;
          w_data_s <= 1'b0;
          OP <= ALU_OP;
        end
        `S6: begin
          PC_Write <= 1'b0;
          IR_Write <= 1'b0;
          Reg_Write <= 1'b1;
          rs2_imm_s <= 1'b0;
          w_data_s <= 1'b1;
          OP <= 4'b0000;
        end
      endcase
    end
  end


endmodule
