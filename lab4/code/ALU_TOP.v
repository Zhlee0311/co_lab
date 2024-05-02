`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 15:03:00
// Design Name: 
// Module Name: ALU_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_TOP(
    input clk_rst,
    input clk_RR,
    input clk_F,
    input  [3:0]ALU_OP,
    input  [31:0]data_A,
    input  [31:0]data_B,
    output [31:0]result,
    output [3:0]flag
);


wire [31:0]A;
wire [31:0]B;
wire [31:0]F;
wire [3:0]flag_tmp;


REG32 getA(clk_rst,clk_RR,data_A,A);
REG32 getB(clk_rst,clk_RR,data_B,B);
ALU   alu(A,B,ALU_OP,F,flag_tmp);
REG32 getF(clk_rst,clk_F,F,result);
REG4 getFR(clk_rst,clk_F,flag_tmp,flag);

endmodule