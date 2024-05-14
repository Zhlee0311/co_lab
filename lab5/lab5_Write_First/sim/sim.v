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
    //�Ȳ��Զ����ݹ���,��ʱֻ��۲�douta��ֵ
    for (i = 0; i < 10; i = i + 1) begin
      addra = i;
      #3;
    end
    //����д���ݹ��ܣ�1.����֮ǰ������ 2.д���µ����� 3.��ȡ���ݹ۲��Ƿ���ȷ
    #3 wea = 1;
    for (i = 0; i < 16; i = i + 1) begin
      addra = i;
      dina  = i + 1;  //0~15�ֱ�д��1~16
      #3;
    end

    #3 wea = 0;
    for (i = 0; i < 16; i = i + 1) begin
      addra = i;
      #3;
    end
  end

endmodule
