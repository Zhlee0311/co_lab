`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 22:00:25
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
    input clk_dm,
    input Mem_Write,
    input [7:2]DM_Addr,
    input [31:0]M_W_Data,
    output [31:0]M_R_Data
);

RAM_B MEM(clk_dm,Mem_Write,DM_Addr,M_W_Data,M_R_Data);

endmodule
