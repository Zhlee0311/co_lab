`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/03 09:01:00
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

module TOP (
    input clk,//芯片时钟
    input clk_dm,//存储器时钟
    input Mem_Write,//读写信号
    input [7:2]DM_Addr,//访问的地址
    input [1:0]MW_Data_s,//开关，用于选择写入的数据
    output [2:0]which,//位选
    output [7:0]seg//段选
);

wire [31:0]M_R_Data;//读数据
reg [31:0]M_W_Data;//写数据

always@(*)begin
    if(Mem_Write)begin
        case(MW_Data_s)
            2'b00:M_W_Data=32'h12345678;
            2'b01:M_W_Data=32'h87654321;
            2'b10:M_W_Data=32'h00001111;
            2'b11:M_W_Data=32'hFFFF1111;
        endcase
    end
end//组合逻辑电路：当信号Mem_Write=1时，根据MW_Data_s选择M_W_Data

RAM_B u1(clk_dm,Mem_Write,DM_Addr,M_W_Data,M_R_Data);

DISPLAY u2(clk,M_R_Data,1,which,seg);

endmodule
