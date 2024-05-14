`timescale 1ns / 1ps

module sim;
  reg rst;
  reg clk_Regs;
  reg Reg_Write;
  reg [4:0] R_Addr_A;
  reg [4:0] R_Addr_B;
  reg [4:0] W_Addr;
  reg [31:0] W_Data;
  wire [31:0] R_Data_A;
  wire [31:0] R_Data_B;


  REG_HEAP uut (
      .rst(rst),
      .clk_Regs(clk_Regs),
      .Reg_Write(Reg_Write),
      .R_Addr_A(R_Addr_A),
      .R_Addr_B(R_Addr_B),
      .W_Addr(W_Addr),
      .W_Data(W_Data),
      .R_Data_A(R_Data_A),
      .R_Data_B(R_Data_B)
  );


  always begin
    #5 clk_Regs = ~clk_Regs;
  end


  //测试数据
  initial begin
    rst = 1;
    clk_Regs = 0;
    Reg_Write = 0;
    R_Addr_A = 0;
    R_Addr_B = 0;
    W_Addr = 0;
    W_Data = 0;

    #5 rst=0;
    
    //读取地址1和地址2处的数据，验证是否为1和2
    #20 R_Addr_A = 1;
    R_Addr_B = 2;


    //验证x0寄存器能否写入数据
    #20 Reg_Write = 1;
    W_Data = 32'h12345678;
    #20 R_Addr_A = 0;


    //验证写入数据功能
    #20 W_Addr = 3;
    W_Data = 32'h87654321;
    #20 R_Addr_B = 3;


    //验证复位功能
    #20 rst = 1;
    #20 rst = 0; // 复位后需要再次将rst设置为0
  end
endmodule