`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 10:20:39
// Design Name: 
// Module Name: REG4
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


module REG4(
    input clk_rst,
    input clk_in,
    input [3:0]data_in,
    output [3:0]data_out
);
reg [3:0]tmp;

always@(negedge clk_rst or posedge clk_in)
begin
    if(!clk_rst)
        tmp<=4'b0;
    else
        tmp<=data_in;
end

assign data_out=tmp;

endmodule
