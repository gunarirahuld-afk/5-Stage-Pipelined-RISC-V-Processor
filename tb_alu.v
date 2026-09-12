`timescale 1ns/1ps

module tb_alu;

reg [31:0] a;
reg [31:0] b;
reg [3:0] alu_control;

wire [31:0] result;
wire zero;

alu uut (
    .a(a),
    .b(b),
    .alu_control(alu_control),
    .result(result),
    .zero(zero)
);

initial begin
$dumpfile("alu.vcd");
$dumpvars(0, tb_alu);
    a = 32'd10;
    b = 32'd5;
    alu_control = 4'b0000;
    #10;

    a = 32'd10;
    b = 32'd5;
    alu_control = 4'b0001;
    #10;

    a = 32'hFF00;
    b = 32'h0F0F;
    alu_control = 4'b0010;
    #10;

    a = 32'hFF00;
    b = 32'h0F0F;
    alu_control = 4'b0011;
    #10;

    a = 32'hFF00;
    b = 32'h0F0F;
    alu_control = 4'b0100;
    #10;

    a = 32'd5;
    b = 32'd2;
    alu_control = 4'b0101;
    #10;

    a = 32'd20;
    b = 32'd2;
    alu_control = 4'b0110;
    #10;

    a = 32'd5;
    b = 32'd10;
    alu_control = 4'b0111;
    #10;

    $finish;

end

endmodule