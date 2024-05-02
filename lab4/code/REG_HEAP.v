`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 13:18:05
// Design Name: 
// Module Name: REG_HEAP
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


module REG_HEAP(
    input clk_rst,
    input clk_Regs,
    input Reg_Write,
    input [4:0]R_Addr_A,
    input [4:0]R_Addr_B,
    input [4:0]W_Addr,
    input [31:0]W_Data,
    output [31:0]R_Data_A,
    output [31:0]R_Data_B
);

reg [31:0]REG_Files[0:31];

integer i;

initial begin
    for(i=0;i<=31;i=i+1)begin
        REG_Files[i]=32'b0;
    end
    REG_Files[1]=1;
    REG_Files[2]=2;//测试数据
end


always@(negedge clk_rst or posedge clk_Regs)begin
    if(!clk_rst)begin
        for(i=0;i<=31;i=i+1)begin
            REG_Files[i]<=32'b0;
        end
        REG_Files[1]<=1;
        REG_Files[2]<=2;
    end
    else begin
        if(Reg_Write && W_Addr!=0)begin
            REG_Files[W_Addr]<=W_Data;
        end
    end
end

assign R_Data_A=REG_Files[R_Addr_A];

assign R_Data_B=REG_Files[R_Addr_B];

endmodule
