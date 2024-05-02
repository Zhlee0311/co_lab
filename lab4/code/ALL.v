`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 15:39:41
// Design Name: 
// Module Name: ALL
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


module ALL(
    input clk,
    input clk_rst,
    input clk_RR,
    input clk_F,
    input clk_WB,
    input [4:0]R_Addr_A,
    input [4:0]R_Addr_B,
    input [4:0]W_Addr,
    input [3:0]ALU_OP,
    input Reg_Write,
    output [3:0]leds,
    output [2:0]which,
    output [7:0]seg
);

wire [31:0]F_tmp;

TOP U1(clk_rst,clk_RR,clk_F,clk_WB,R_Addr_A,R_Addr_B,W_Addr,ALU_OP,Reg_Write,F_tmp,leds);
DISPLAY U2(clk,F_tmp,1,which,seg);

endmodule
