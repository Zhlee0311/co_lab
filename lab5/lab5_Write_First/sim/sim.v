`timescale 1ns / 1ps

module sim;
  reg clka;
  reg wea;
  reg [5:0] addra;
  reg [31:0] dina;
  wire [31:0] douta;

  RAM_B uut (
      .clka (clka),
      .wea  (wea),
      .addra(addra),
      .dina (dina),
      .douta(douta)
  );

  integer i;
  always begin
    #1 clka = ~clka;
  end

  initial begin
    clka = 0;
    wea  = 0;
    //先测试读数据功能,这时只需观察douta的值
    for (i = 0; i < 10; i = i + 1) begin
      addra = i;
      #3;
    end
    //测试写数据功能：1.覆盖之前的数据 2.写入新的数据 3.读取数据观察是否正确
    #3 wea = 1;
    for (i = 0; i < 16; i = i + 1) begin
      addra = i;
      dina  = i + 1;  //0~15分别写入1~16
      #3;
    end

    #3 wea = 0;
    for (i = 0; i < 16; i = i + 1) begin
      addra = i;
      #3;
    end
  end

endmodule
