`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 15:09:31
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
    input clk_RR,
    input clk_F,
    input clk_WB,
    input [4:0]R_Addr_A,
    input [4:0]R_Addr_B,
    input [4:0]W_Addr,
    input [3:0]ALU_OP,
    input Reg_Write,
    output [31:0]F,
    output [3:0]FR
);

wire [31:0]A;
wire [31:0]B;

REG_HEAP u1(clk_rst,clk_WB,Reg_Write,R_Addr_A,R_Addr_B,W_Addr,F,A,B);

ALU_TOP u2(clk_rst,clk_RR,clk_F,ALU_OP,A,B,F,FR);

endmodule
