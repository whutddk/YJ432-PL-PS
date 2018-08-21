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

	input [2:0] subband_state,

	input [11:0] vbuf_offset,

	input [31:0] dest_vindex_offset,
	input oddBlock,

	output POLY_Done,
	output FDCT_Done,

	output FIFO_EN,
	output [15:0] FIFO_DATA,

	input [31:0] FB_MIBUF_DATA,
	input [5:0] FB_MIBUF_ADDR
	);

(* DONT_TOUCH = "TRUE" *) wire signed [63:0] sum0_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult0A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult0B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult0_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [63:0] sum1_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult1A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult1B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult1_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [63:0] sum2_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult2A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult2B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult2_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [63:0] sum3_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult3A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult3B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult3_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult4A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult4B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult4_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult5A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult5B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult5_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult6A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult6B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult6_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult7A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult7B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult7_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult8A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult8B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult8_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult9A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult9B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult9_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult10A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult10B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult10_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult11A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult11B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult11_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult12A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult12B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult12_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult13A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult13B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult13_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult14A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult14B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult14_out_Wire;

(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult15A_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [31:0] mult15B_Wire;
(* DONT_TOUCH = "TRUE" *) wire signed [63:0] mult15_out_Wire;

//Rom operate
wire [8:0] Rom_addrA_wire;
wire [8:0] Rom_addrB_wire;
wire signed [31:0] Rom_dataA_wire;
wire signed [31:0] Rom_dataB_wire;

//------------------------------------

wire [11:0] RAM_ADDR_A_Wire;
wire [11:0] RAM_ADDR_B_Wire;

wire signed [31:0] RAM_DATA_IN_UN_Wire;

wire signed [31:0] RAM_DATA_OUTA_Wire;
wire signed [31:0] RAM_DATA_OUTB_Wire;

wire RAM_WR_EN_UN_Wire;


//----------------------------------------

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
	
	.POLY_Done(POLY_Done),

	//ram operate
	.Ram_addrA(RAM_ADDR_A_Wire),
	.Ram_addrB(RAM_ADDR_B_Wire),
	.Ram_dataA(RAM_DATA_OUTA_Wire),
	.Ram_dataB(RAM_DATA_OUTB_Wire),

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
	.mult_out2R(mult3_out)

);
	
multiplier i_mult0(
	.sum(sum0_Wire),
	.multA(mult0A_Wire),
	.multB(mult0B_Wire),
	.mult_out(mult0_out_Wire)

);

multiplier i_mult1(
	.sum(sum1_Wire),
	.multA(mult1A_Wire),
	.multB(mult1B_Wire),
	.mult_out(mult1_out_Wire)

);

multiplier i_mult2(
	.sum(sum2_Wire),
	.multA(mult2A_Wire),
	.multB(mult2B_Wire),
	.mult_out(mult2_out_Wire)

);

multiplier i_mult3(
	.sum(sum3_Wire),
	.multA(mult3A_Wire),
	.multB(mult3B_Wire),
	.mult_out(mult3_out_Wire)

);

multiplier i_mult4(
	.sum(64'd0),
	.multA(mult4A_Wire),
	.multB(mult4B_Wire),
	.mult_out(mult4_out_Wire)

);

multiplier i_mult5(
	.sum(64'd0),
	.multA(mult5A_Wire),
	.multB(mult5B_Wire),
	.mult_out(mult5_out_Wire)

);

multiplier i_mult6(
	.sum(64'd0),
	.multA(mult6A_Wire),
	.multB(mult6B_Wire),
	.mult_out(mult6_out_Wire)

);

multiplier i_mult7(
	.sum(64'd0),
	.multA(mult7A_Wire),
	.multB(mult7B_Wire),
	.mult_out(mult7_out_Wire)

);

multiplier i_mult8(
	.sum(64'd0),
	.multA(mult8A_Wire),
	.multB(mult8B_Wire),
	.mult_out(mult8_out_Wire)

);

multiplier i_mult9(
	.sum(64'd0),
	.multA(mult9A_Wire),
	.multB(mult9B_Wire),
	.mult_out(mult9_out_Wire)

);

multiplier i_mult10(
	.sum(64'd0),
	.multA(mult10A_Wire),
	.multB(mult10B_Wire),
	.mult_out(mult10_out_Wire)

);

multiplier i_mult11(
	.sum(64'd0),
	.multA(mult11A_Wire),
	.multB(mult11B_Wire),
	.mult_out(mult11_out_Wire)

);

multiplier i_mult12(
	.sum(64'd0),
	.multA(mult12A_Wire),
	.multB(mult12B_Wire),
	.mult_out(mult11_out_Wire)

);

multiplier i_mult13(
	.sum(64'd0),
	.multA(mult13A_Wire),
	.multB(mult13B_Wire),
	.mult_out(mult13_out_Wire)

);

multiplier i_mult14(
	.sum(64'd0),
	.multA(mult14A_Wire),
	.multB(mult14B_Wire),
	.mult_out(mult14_out_Wire)

);

multiplier i_mult15(
	.sum(64'd0),
	.multA(mult15A_Wire),
	.multB(mult15B_Wire),
	.mult_out(mult15_out_Wire)

);

ROM_wrapper i_ROM(
	.BRAM_PORTA_0_addr(Rom_addrA_wire),
	.BRAM_PORTA_0_clk(MP3_CLK),
	.BRAM_PORTA_0_dout(Rom_dataA_wire),

	.BRAM_PORTB_0_addr(Rom_addrB_wire),
	.BRAM_PORTB_0_clk(MP3_CLK),
	.BRAM_PORTB_0_dout(Rom_dataB_wire)
);  



RAM_wrapper i_RAM(
	.BRAM_PORTA_0_addr(RAM_ADDR_A_Wire),
	.BRAM_PORTA_0_clk(MP3_CLK),
	.BRAM_PORTA_0_din(RAM_DATA_IN_UN_Wire),
	.BRAM_PORTA_0_dout(RAM_DATA_OUTA_Wire),
	.BRAM_PORTA_0_we(RAM_WR_EN_UN_Wire),

	.BRAM_PORTB_0_addr(RAM_ADDR_B_Wire),
	.BRAM_PORTB_0_clk(MP3_CLK),
	.BRAM_PORTB_0_din(RAM_DATA_IN_UN_Wire),
	.BRAM_PORTB_0_dout(RAM_DATA_OUTB_Wire),
	.BRAM_PORTB_0_we(RAM_WR_EN_UN_Wire)
);


FDCT32 i_FDCT32(
	.CLK(MP3_CLK),    // Clock flexbus 40MHZ 
	.RST_n(RST_n),  // Asynchronous reset active low

	.dest_vindex_offset(dest_vindex_offset),
	.oddBlock(oddBlock),
	
	.sum0(sum0_Wire),
	.mult0A(mult0A_Wire),
	.mult0B(mult0B_Wire),
	.mult0_out(mult0_out_Wire),

	.sum1(sum1_Wire),
	.mult1A(mult1A_Wire),
	.mult1B(mult1B_Wire),
	.mult1_out(mult1_out_Wire),

	.sum2(sum2_Wire),
	.mult2A(mult2A_Wire),
	.mult2B(mult2B_Wire),
	.mult2_out(mult2_out_Wire),
	
	.sum3(sum3_Wire),	
	.mult3A(mult3A_Wire),
	.mult3B(mult3B_Wire),
	.mult3_out(mult3_out_Wire),
	
	.mult4A(mult4A_Wire),
	.mult4B(mult4B_Wire),
	.mult4_out(mult4_out_Wire),
		
	.mult5A(mult5A_Wire),
	.mult5B(mult5B_Wire),
	.mult5_out(mult5_out_Wire),

	.mult6A(mult6A_Wire),
	.mult6B(mult6B_Wire),
	.mult6_out(mult6_out_Wire),
	
	.mult7A(mult7A_Wire),
	.mult7B(mult7B_Wire),
	.mult7_out(mult7_out_Wire),
	
	.mult8A(mult8A_Wire),
	.mult8B(mult8B_Wire),
	.mult8_out(mult8_out_Wire),
	
	.mult9A(mult9A_Wire),
	.mult9B(mult9B_Wire),
	.mult9_out(mult9_out_Wire),
	
	.mult10A(mult10A_Wire),
	.mult10B(mult10B_Wire),
	.mult10_out(mult10_out_Wire),
	
	.mult11A(mult11A_Wire),
	.mult11B(mult11B_Wire),
	.mult11_out(mult11_out_Wire),
	
	.mult12A(mult12A_Wire),
	.mult12B(mult12B_Wire),
	.mult12_out(mult12_out_Wire),
	
	.mult13A(mult13A_Wire),
	.mult13B(mult13B_Wire),
	.mult13_out(mult13_out_Wire),
	
	.mult14A(mult14A_Wire),
	.mult14B(mult14B_Wire),
	.mult14_out(mult14_out_Wire),
	
	.mult15A(mult15A_Wire),
	.mult15B(mult15B_Wire),
	.mult15_out(mult15_out_Wire),

	//ram operate
	.Ram_addrA(RAM_ADDR_A_Wire),
	.Ram_addrB(RAM_ADDR_B_Wire),
	.Ram_data(RAM_DATA_IN_UN_Wire),
	.Ram_wr_en(RAM_WR_EN_UN_Wire),

	//MIBUF
	.FB_MIBUF_DATA(FB_MIBUF_DATA),
	.FB_MIBUF_ADDR(FB_MIBUF_ADDR),

	//state
	.subband_state(subband_state),
	.FDCT_Done(FDCT_Done)
);



endmodule
