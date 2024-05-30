`timescale 1ns / 1ps

//PC的加法器模块，用于计算自增后的地址
module PC_ADDER (
    in,
    out
);
  input [31:0] in;
  output [31:0] out;
  assign out = (in == 32'h0000_00FC) ? 32'h0000_0000 : in + 32'h0000_0004;
endmodule



//PC0的加法器模块，用于和立即数运算产生地址
module PC0_ADDER (
    PC0,
    imm,
    out
);
  input [31:0] PC0, imm;
  output [31:0] out;

  assign out = PC0 + imm;

endmodule



//PC0模块，用于存储PC暂未递增的值
module PC0 (
    rst,
    clk,
    en,
    in,
    out
);

  input rst, clk, en;
  input [31:0] in;
  output reg [31:0] out;

  always @(posedge rst or posedge clk) begin
    if (rst) begin
      out <= 32'h0000_0000;
    end else if (en) begin
      out <= in;
    end
  end

endmodule



//PC_MUX模块，用于选择PC的输入
module PC_MUX (
    PC_s,  //选择信号
    PC_inc,  //PC自增后的值
    PC_imm,  //PC和立即数相加后的值
    PC_F,  //rs1和立即数相加后的值
    out
);
  input [1:0] PC_s;
  input [31:0] PC_inc, PC_imm, PC_F;
  output reg [31:0] out;

  always @(*) begin
    case (PC_s)
      2'b00:   out = PC_inc;
      2'b01:   out = PC_imm;
      2'b10:   out = PC_F;
      default: out = PC_inc;
    endcase
  end

endmodule



//PC模块，综合了上述模块
module PC (
    rst,
    clk,
    en_PC,
    en_PC0,
    PC_s,
    imm,
    F,
    PC_now,  //当前的PC值
    out  //输出给IM的地址，用于取指令
);


  input rst, clk, en_PC, en_PC0;
  input [1:0] PC_s;
  input [31:0] imm, F;

  output reg [31:0] PC_now;
  output reg [5:0] out;

  wire [31:0] PC0;
  wire [31:0] PC_inc, PC_imm;
  wire [31:0] PC_next;


  always @(posedge rst or posedge clk) begin
    if (rst) begin
      PC_now <= 32'h0000_0000;
      out <= 6'b000000;
    end else if (en_PC) begin
      PC_now <= PC_next;
      out    <= PC_next[7:2];
    end
  end

  PC_ADDER pc_adder (
      .in (PC_now),
      .out(PC_inc)
  );

  PC0 pc0 (
      .rst(rst),
      .clk(clk),
      .en (en_PC0),
      .in (PC_now),
      .out(PC0)
  );

  PC0_ADDER pc0_adder (
      .PC0(PC0),
      .imm(imm),
      .out(PC_imm)
  );

  PC_MUX pc_mux (
      .PC_s(PC_s),
      .PC_inc(PC_inc),
      .PC_imm(PC_imm),
      .PC_F(F),
      .out(PC_next)
  );


endmodule
