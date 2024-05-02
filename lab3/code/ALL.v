`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 11:56:37
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
    input clk_A,
    input clk_B,
    input clk_F,
    input [31:0]data_in,
    output [3:0]leds,
    output [2:0]which,
    output [7:0]seg
);

wire [31:0]res_tmp;
wire [3:0]flag_tmp;

TOP u1(clk_rst,clk_A,clk_B,clk_F,data_in,res_tmp,flag_tmp);
DISPLAY u2(clk,res_tmp,1,which,seg);
assign leds=flag_tmp;

endmodule
