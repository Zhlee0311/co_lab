`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 15:40:02
// Design Name: 
// Module Name: DISPLAY
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


module DISPLAY(
    input clk,//芯片时钟
    input [31:0]data,//数据
    output enable,//译码器使能信号
    output [2:0]which,//位选
    output reg[7:0]seg//段选
);
reg which_temp=0;
reg [14:0]count=0;
reg [3:0]digit;

always@(posedge clk)count<=count+1'b1;
always@(negedge clk)begin
    if(&count)
        begin
            which_temp<=which_temp+1'b1;
        end
end

always@(*)begin
    case(which_temp)
        3'b000:digit<=data[31:28];
        3'b001:digit<=data[27:24];
        3'b010:digit<=data[23:20];
        3'b011:digit<=data[19:16];
        3'b100:digit<=data[15:12];
        3'b101:digit<=data[11:8];
        3'b110:digit<=data[7:4];
        3'b111:digit<=data[3:0];
    endcase
end

always@(*)begin
    case(digit)
        4'h0:seg<=8'b0000_0011;
        4'h1:seg<=8'b1001_1111;
        4'h2:seg<=8'b0010_0101;
        4'h3:seg<=8'b0000_1101;
        4'h4:seg<=8'b1001_1001;
        4'h5:seg<=8'b0100_1001;
        4'h6:seg<=8'b0100_0001;
        4'h7:seg<=8'b0001_1111;
        4'h8:seg<=8'b0000_0001;
        4'h9:seg<=8'b0000_1001;
        4'hA:seg<=8'b0001_0001;
        4'hB:seg<=8'b1100_0001;
        4'hC:seg<=8'b0110_0011;
        4'hD:seg<=8'b1000_0101;
        4'hE:seg<=8'b0110_0001;
        4'hF:seg<=8'b0111_0001;
    endcase
end

assign which=which_temp;

endmodule

