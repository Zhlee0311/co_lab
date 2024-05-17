`timescale 1ns / 1ps

//取指令模块的仿真
module sim_IF;
  reg rst;  //复位信号
  reg clk;  //时钟信号
  reg IR_Write = 1;
  reg PC_Write = 1;

  wire [31:0] inst;  //取指令模块的输出

  //取指令模块的实例化
  IF uut (
      .rst(rst),
      .clk(clk),
      .IR_Write(IR_Write),
      .PC_Write(PC_Write),
      .inst(inst)
  );

  initial begin
    clk = 0;  //将时钟置于低电平
    rst = 1;  //先复位
    #1 rst = 0;  //1ns后复位结束
    repeat (100) begin
      #5 clk = ~clk;  //5ns时钟翻转一次
    end

  end

endmodule

