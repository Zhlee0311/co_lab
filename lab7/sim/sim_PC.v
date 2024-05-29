`timescale 1ns / 1ps

module sim_PC;

  reg rst;
  reg clk;
  reg en;
  wire [5:0] out;

  PC uut (
      .rst(rst),
      .clk(clk),
      .en (en),
      .out(out)
  );

  initial begin
    rst = 1;
    clk = 0;
    en  = 1;
    #1 rst = 0;
    repeat (100) begin
      #5 clk = ~clk;
    end
  end


endmodule