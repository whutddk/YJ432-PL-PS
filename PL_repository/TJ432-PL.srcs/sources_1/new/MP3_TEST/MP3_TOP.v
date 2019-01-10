`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/08/03 17:34:19
// Design Name: 
// Module Name: mp3_top
// Project Name: TJ432-B
// Target Devices: Artix-7 35T
// Tool Versions: 
// Description: implement of mp3
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mp3_top(
	input i_fb_clk,    // Clock flexbus 40MHZ 
	input RST_n,  // Asynchronous reset active low

	input gb,
	input [31:0] offset,
	input oddBlock,
	
    	//ram operate
    output [11:0] Ram_addrA,
    output [11:0 ] Ram_addrB,
    output [31:0] Ram_data

);

wire [63:0] sum0;
wire [31:0] mult0A;
wire [31:0] mult0B;
wire [63:0] mult0_out;

wire [63:0] sum1;
wire [31:0] mult1A;
wire [31:0] mult1B;
wire [63:0] mult1_out;

wire [63:0] sum2;
wire [31:0] mult2A;
wire [31:0] mult2B;
wire [63:0] mult2_out;

wire [63:0] sum3;
wire [31:0] mult3A;
wire [31:0] mult3B;
wire [63:0] mult3_out;
		
wire [31:0] mult4A;
wire [31:0] mult4B;
wire [63:0] mult4_out;
		
wire [31:0] mult5A;
wire [31:0] mult5B;
wire [63:0] mult5_out;
		
wire [31:0] mult6A;
wire [31:0] mult6B;
wire [63:0] mult6_out;
		
wire [31:0] mult7A;
wire [31:0] mult7B;
wire [63:0] mult7_out;
		
wire [31:0] mult8A;
wire [31:0] mult8B;
wire [63:0] mult8_out;
		
wire [31:0] mult9A;
wire [31:0] mult9B;
wire [63:0] mult9_out;
		
wire [31:0] mult10A;
wire [31:0] mult10B;
wire [63:0] mult10_out;
		
wire [31:0] mult11A;
wire [31:0] mult11B;
wire [63:0] mult11_out;
		
wire [31:0] mult12A;
wire [31:0] mult12B;
wire [63:0] mult12_out;
		
wire [31:0] mult13A;
wire [31:0] mult13B;
wire [63:0] mult13_out;
		
wire [31:0] mult14A;
wire [31:0] mult14B;
wire [63:0] mult14_out;
		
wire [31:0] mult15A;
wire [31:0] mult15B;
wire [63:0] mult15_out;


FDCT32 i_FDCT32(
	.CLK(i_fb_clk),    // Clock flexbus 40MHZ 
	.RST_n(RST_n),  // Asynchronous reset active low

	.gb(gb),
	.offset(offset),
	.oddBlock(oddBlock),
	
	.sum0(sum0),
	.mult0A(mult0A),
	.mult0B(mult0B),
	.mult0_out(mult0_out),

	.sum1(sum1),
	.mult1A(mult1A),
	.mult1B(mult1B),
	.mult1_out(mult1_out),

	.sum2(sum2),
	.mult2A(mult2A),
	.mult2B(mult2B),
	.mult2_out(mult2_out),
	
	.sum3(sum3),	
	.mult3A(mult3A),
	.mult3B(mult3B),
	.mult3_out(mult3_out),
		
	.mult4A(mult4A),
	.mult4B(mult4B),
	.mult4_out(mult4_out),
		
	.mult5A(mult5A),
	.mult5B(mult5B),
	.mult5_out(mult5_out),
		
	.mult6A(mult6A),
	.mult6B(mult6B),
	.mult6_out(mult6_out),
		
	.mult7A(mult7A),
	.mult7B(mult7B),
	.mult7_out(mult7_out),
		
	.mult8A(mult8A),
	.mult8B(mult8B),
	.mult8_out(mult8_out),
		
	.mult9A(mult9A),
	.mult9B(mult9B),
	.mult9_out(mult9_out),
		
	.mult10A(mult10A),
	.mult10B(mult10B),
	.mult10_out(mult10_out),
		
	.mult11A(mult11A),
	.mult11B(mult11B),
	.mult11_out(mult11_out),
		
	.mult12A(mult12A),
	.mult12B(mult12B),
	.mult12_out(mult12_out),
		
	.mult13A(mult13A),
	.mult13B(mult13B),
	.mult13_out(mult13_out),
		
	.mult14A(mult14A),
	.mult14B(mult14B),
	.mult14_out(mult14_out),
		
	.mult15A(mult15A),
	.mult15B(mult15B),
	.mult15_out(mult15_out),
	
	//ram operate
    .Ram_addrA(Ram_addrA),
    .Ram_addrB(Ram_addrB),
    .Ram_data(Ram_data)
);

multiplier i_mult0(
	.sum(sum0),
	.multA(mult0A),
	.multB(mult0B),
	.mult_out(mult0_out)

);

multiplier i_mult1(
	.sum(sum1),
	.multA(mult1A),
	.multB(mult1B),
	.mult_out(mult1_out)

);

multiplier i_mult2(
	.sum(sum2),
	.multA(mult2A),
	.multB(mult2B),
	.mult_out(mult2_out)

);

multiplier i_mult3(
	.sum(sum3),
	.multA(mult3A),
	.multB(mult3B),
	.mult_out(mult3_out)

);

multiplier i_mult4(
	.sum( 64'd0 ),
	.multA(mult4A),
	.multB(mult4B),
	.mult_out(mult4_out)

);

multiplier i_mult5(
	.sum( 64'd0 ),
	.multA(mult5A),
	.multB(mult5B),
	.mult_out(mult5_out)

);

multiplier i_mult6(
	.sum( 64'd0 ),
	.multA(mult6A),
	.multB(mult6B),
	.mult_out(mult6_out)

);

multiplier i_mult7(
	.sum( 64'd0 ),
	.multA(mult7A),
	.multB(mult7B),
	.mult_out(mult7_out)

);

multiplier i_mult8(
	.sum( 64'd0 ),
	.multA(mult8A),
	.multB(mult8B),
	.mult_out(mult8_out)

);

multiplier i_mult9(
	.sum( 64'd0 ),
	.multA(mult9A),
	.multB(mult9B),
	.mult_out(mult9_out)

);

multiplier i_mult10(
	.sum( 64'd0 ),
	.multA(mult10A),
	.multB(mult10B),
	.mult_out(mult10_out)

);

multiplier i_mult11(
	.sum( 64'd0 ),
	.multA(mult11A),
	.multB(mult11B),
	.mult_out(mult11_out)

);

multiplier i_mult12(
	.sum( 64'd0 ),
	.multA(mult12A),
	.multB(mult12B),
	.mult_out(mult12_out)

);

multiplier i_mult13(
	.sum( 64'd0 ),
	.multA(mult13A),
	.multB(mult13B),
	.mult_out(mult13_out)

);

multiplier i_mult14(
	.sum( 64'd0 ),
	.multA(mult14A),
	.multB(mult14B),
	.mult_out(mult14_out)

);

multiplier i_mult15(
	.sum( 64'd0 ),
	.multA(mult15A),
	.multB(mult15B),
	.mult_out(mult15_out)

);


endmodule
