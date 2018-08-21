`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhn university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/08/09 11:21:50
// Design Name: 
// Module Name: mp3_mid
// Project Name: TJ432-B
// Target Devices: XC7A35T
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


module mp3_mid(
	input MP3_CLK,
	input RST_n,

	input signed [31:0] RAM_dataA_out,
	input signed [31:0] RAM_dataB_out,
	inout [11:0] RAM_addrA,
	inout [11:0] RAM_addrB,

	input [2:0] subband_state,

	//CTL
	// input [3:0] vindex,
	// input b,

	input [11:0] vbuf_offset,

	output IP_Done,

	output FIFO_EN,
	output [15:0] FIFO_DATA,

	input [5:0] PCM_ADDR,
	output [31:0] PCM_DATA

	);

(* DONT_TOUCH = "TRUE" *) wire signed [63:0] sum0;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult0A;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult0B;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult0_out;

(* DONT_TOUCH = "TRUE" *) wire signed [63:0] sum1;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult1A;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult1B;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult1_out;

(* DONT_TOUCH = "TRUE" *) wire signed [63:0] sum2;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult2A;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult2B;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult2_out;

(* DONT_TOUCH = "TRUE" *) wire signed [63:0] sum3;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult3A;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult3B;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult3_out;

//Rom operate
wire [8:0] Rom_addrA_wire;
wire [8:0] Rom_addrB_wire;
wire signed [31:0] Rom_dataA_wire;
wire signed [31:0] Rom_dataB_wire;

  
polyphase i_polyhpase
(
	.CLK(MP3_CLK),	// Clock
	.RST_n(RST_n),	// Asynchronous reset active low

	//state
	.subband_state(subband_state),

	//CTL
	// .vindex(vindex),
	// .b(b),
	
	.vbuf_offset(vbuf_offset),
	
	.IP_Done(IP_Done),

	//ram operate
	.Ram_addrA(RAM_addrA),
	.Ram_addrB(RAM_addrB),
	.Ram_dataA(RAM_dataA_out),
	.Ram_dataB(RAM_dataB_out),

	//Rom operate
	.Rom_addrA(Rom_addrA_wire),
	.Rom_addrB(Rom_addrB_wire),
	.Rom_dataA(Rom_dataA_wire),
	.Rom_dataB(Rom_dataB_wire),    

	//FIFO pcm DATA
	.fifo_data(FIFO_DATA),
	.fifo_enable(FIFO_EN),

	.sum1L_pre(sum0),
	.mult1L_A(mult0A),
	.mult1L_B(mult0B),
	.mult_out1L(mult0_out),

	.sum2L_pre(sum1),
	.mult2L_A(mult1A),
	.mult2L_B(mult1B),
	.mult_out2L(mult1_out),

	.sum1R_pre(sum2),
	.mult1R_A(mult2A),
	.mult1R_B(mult2B),
	.mult_out1R(mult2_out),

	.sum2R_pre(sum3),
	.mult2R_A(mult3A),
	.mult2R_B(mult3B),
	.mult_out2R(mult3_out),

	.PCM_ADDR(PCM_ADDR),
	.PCM_DATA(PCM_DATA)

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
	.sum(64'd0),
	.multA(mult4A),
	.multB(mult4B),
	.mult_out(mult4_out)

);

multiplier i_mult5(
	.sum(64'd0),
	.multA(mult5A),
	.multB(mult5B),
	.mult_out(mult5_out)

);

multiplier i_mult6(
	.sum(64'd0),
	.multA(mult6A),
	.multB(mult6B),
	.mult_out(mult6_out)

);

multiplier i_mult7(
	.sum(64'd0),
	.multA(mult7A),
	.multB(mult7B),
	.mult_out(mult7_out)

);

multiplier i_mult8(
	.sum(64'd0),
	.multA(mult8A),
	.multB(mult8B),
	.mult_out(mult8_out)

);

multiplier i_mult9(
	.sum(64'd0),
	.multA(mult9A),
	.multB(mult9B),
	.mult_out(mult9_out)

);

multiplier i_mult10(
	.sum(64'd0),
	.multA(mult10A),
	.multB(mult10B),
	.mult_out(mult10_out)

);

multiplier i_mult11(
	.sum(64'd0),
	.multA(mult11A),
	.multB(mult11B),
	.mult_out(mult11_out)

);

multiplier i_mult12(
	.sum(64'd0),
	.multA(mult12A),
	.multB(mult12B),
	.mult_out(mult11_out)

);

multiplier i_mult13(
	.sum(64'd0),
	.multA(mult13A),
	.multB(mult13B),
	.mult_out(mult13_out)

);

multiplier i_mult14(
	.sum(64'd0),
	.multA(mult14A),
	.multB(mult14B),
	.mult_out(mult14_out)

);

multiplier i_mult15(
	.sum(64'd0),
	.multA(mult15A),
	.multB(mult15B),
	.mult_out(mult15_out)

);

ROM_wrapper i_ROM(
	.BRAM_PORTA_0_addr(Rom_addrA_wire),
	.BRAM_PORTA_0_clk(MP3_CLK),
	.BRAM_PORTA_0_dout(Rom_dataA_wire),

	.BRAM_PORTB_0_addr(Rom_addrB_wire),
	.BRAM_PORTB_0_clk(MP3_CLK),
	.BRAM_PORTB_0_dout(Rom_dataB_wire)
);  
	
FDCT32 i_FDCT32(
	CLK,    // Clock flexbus 40MHZ 
	RST_n,  // Asynchronous reset active low

	offset,
	oddBlock,
	
	sum0,
	mult0A,
	mult0B,
	mult0_out,

	sum1,
	mult1A,
	mult1B,
	mult1_out,

	sum2,
	mult2A,
	mult2B,
	mult2_out,
	
	sum3,	
	mult3A,
	mult3B,
	mult3_out,
	
	mult4A,
	mult4B,
	mult4_out,
		
	mult5A,
	mult5B,
	mult5_out,

	mult6A,
	mult6B,
	mult6_out,
	
	mult7A,
	mult7B,
	mult7_out,
	
	mult8A,
	mult8B,
	mult8_out,
	
	mult9A,
	mult9B,
	mult9_out,
	
	mult10A,
	mult10B,
	mult10_out,
	
	mult11A,
	mult11B,
	mult11_out,
	
	mult12A,
	mult12B,
	mult12_out,
	
	mult13A,
	mult13B,
	mult13_out,
	
	mult14A,
	mult14B,
	mult14_out,
	
	mult15A,
	mult15B,
	mult15_out,

	//ram operate
	Ram_addrA,
	Ram_addrB,
	Ram_data,

	//MIBUF
	FB_MIBUF_DATA,
	FB_MIBUF_ADDR,

	//state
	subband_state,
	FDCT_done
);



endmodule
