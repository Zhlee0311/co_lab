`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 10:26:22
// Design Name: 
// Module Name: TOP
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


module TOP(
    input clk_rst,
    input clk_A,
    input clk_B,
    input clk_F,
    input [31:0]data,
    output [31:0]result,
    output [3:0]flag
);

wire [31:0]A;
wire [31:0]B;
wire [31:0]F;
wire [3:0]flag_tmp;

REG32 getA(clk_rst,clk_A,data,A);
REG32 getB(clk_rst,clk_B,data,B);
ALU    alu(A,B,data[3:0],F,flag_tmp);
REG32 getF(clk_rst,clk_F,F,result);
REG4  getFR(clk_rst,clk_F,flag_tmp,flag);


endmodule
