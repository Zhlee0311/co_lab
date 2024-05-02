`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 13:55:58
// Design Name: 
// Module Name: REG32
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


module REG32(
    input clk_rst,
    input clk_in,
    input [31:0]data_in,
    output[31:0]data_out
);
reg [31:0]tmp;

always@(negedge clk_rst or posedge clk_in)
begin
    if(!clk_rst)
        tmp<=32'b0;
    else
        tmp<=data_in;
end

assign data_out=tmp;

endmodule
