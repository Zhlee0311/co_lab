`timescale 1ns / 1ps

//初级译码模块的测试
module sim_ID1;

reg [31:0]inst;
wire [4:0]rs1,rs2,rd;
wire [6:0]opcode;
wire [2:0]funct3;
wire [6:0]funct7;
wire [31:0]imm;


ID1 uut(
    .inst(inst),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .imm(imm)
);


initial begin
    inst=32'h000002b3;
    #5;
    inst=32'h00000333;
    #5;
    inst=32'h00a00393;
    #5;
    inst=32'h04032e03;
    #5;
    inst=32'h01c282b3;
    #5;
    inst=32'h00430313;
    #5;
    inst=32'hfff38393;
    #5;
    inst=32'h00038463;
    #5;
    inst=32'hfedff06f;
    #5;
    inst=32'h08502023;
end

endmodule
