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

	input dest_offset,
	input [11:0] vindex_offset,
	input oddBlock,

	output POLY_Done,
	output FDCT_Done,

	output FIFO_EN,
	output [15:0] FIFO_DATA,

	input [31:0] FB_MIBUF_DATA,
	input [5:0] FB_MIBUF_ADDR
	);

wire signed [63:0] sum0_Wire;
wire signed [31:0] mult0A_Wire;
wire signed [31:0] mult0B_Wire;
wire signed [63:0] mult0_out_Wire;

wire signed [63:0] sum1_Wire;
wire signed [31:0] mult1A_Wire;
wire signed [31:0] mult1B_Wire;
wire signed [63:0] mult1_out_Wire;

wire signed [63:0] sum2_Wire;
wire signed [31:0] mult2A_Wire;
wire signed [31:0] mult2B_Wire;
wire signed [63:0] mult2_out_Wire;

wire signed [63:0] sum3_Wire;
wire signed [31:0] mult3A_Wire;
wire signed [31:0] mult3B_Wire;
wire signed [63:0] mult3_out_Wire;

wire signed [31:0] mult4A_Wire;
wire signed [31:0] mult4B_Wire;
wire signed [63:0] mult4_out_Wire;

wire signed [31:0] mult5A_Wire;
wire signed [31:0] mult5B_Wire;
wire signed [63:0] mult5_out_Wire;

wire signed [31:0] mult6A_Wire;
wire signed [31:0] mult6B_Wire;
wire signed [63:0] mult6_out_Wire;

wire signed [31:0] mult7A_Wire;
wire signed [31:0] mult7B_Wire;
wire signed [63:0] mult7_out_Wire;

wire signed [31:0] mult8A_Wire;
wire signed [31:0] mult8B_Wire;
wire signed [63:0] mult8_out_Wire;

wire signed [31:0] mult9A_Wire;
wire signed [31:0] mult9B_Wire;
wire signed [63:0] mult9_out_Wire;

wire signed [31:0] mult10A_Wire;
wire signed [31:0] mult10B_Wire;
wire signed [63:0] mult10_out_Wire;

wire signed [31:0] mult11A_Wire;
wire signed [31:0] mult11B_Wire;
wire signed [63:0] mult11_out_Wire;

wire signed [31:0] mult12A_Wire;
wire signed [31:0] mult12B_Wire;
wire signed [63:0] mult12_out_Wire;

wire signed [31:0] mult13A_Wire;
wire signed [31:0] mult13B_Wire;
wire signed [63:0] mult13_out_Wire;

wire signed [31:0] mult14A_Wire;
wire signed [31:0] mult14B_Wire;
wire signed [63:0] mult14_out_Wire;

wire signed [31:0] mult15A_Wire;
wire signed [31:0] mult15B_Wire;
wire signed [63:0] mult15_out_Wire;



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

	.sum1L_pre(sum0_Wire),
	.mult1L_A(mult0A_Wire),
	.mult1L_B(mult0B_Wire),
	.mult_out1L(mult0_out_Wire),

	.sum2L_pre(sum1_Wire),
	.mult2L_A(mult1A_Wire),
	.mult2L_B(mult1B_Wire),
	.mult_out2L(mult1_out_Wire),

	.sum1R_pre(sum2_Wire),
	.mult1R_A(mult2A_Wire),
	.mult1R_B(mult2B_Wire),
	.mult_out1R(mult2_out_Wire),

	.sum2R_pre(sum3_Wire),
	.mult2R_A(mult3A_Wire),
	.mult2R_B(mult3B_Wire),
	.mult_out2R(mult3_out_Wire)

);

// mult_add_wrapper
//    (A_0,
//     B_0,
//     C_0,
//     P_0);

	
mult_add_wrapper i_mult0(	
	.A_0(mult0A_Wire),
	.B_0(mult0B_Wire),
	.C_0(sum0_Wire),
	.P_0(mult0_out_Wire)

);

mult_add_wrapper i_mult1(
	
	.A_0(mult1A_Wire),
	.B_0(mult1B_Wire),
	.C_0(sum1_Wire),
	.P_0(mult1_out_Wire)

);

mult_add_wrapper i_mult2(
	
	.A_0(mult2A_Wire),
	.B_0(mult2B_Wire),
	.C_0(sum2_Wire),
	.P_0(mult2_out_Wire)

);

mult_add_wrapper i_mult3(
	
	.A_0(mult3A_Wire),
	.B_0(mult3B_Wire),
	.C_0(sum3_Wire),
	.P_0(mult3_out_Wire)

);

pure_mult_wrapper i_mult4(
	
	.A_0(mult4A_Wire),
	.B_0(mult4B_Wire),
	.P_0(mult4_out_Wire)

);

pure_mult_wrapper i_mult5(	
	.A_0(mult5A_Wire),
	.B_0(mult5B_Wire),
	.P_0(mult5_out_Wire)

);

pure_mult_wrapper i_mult6(
	.A_0(mult6A_Wire),
	.B_0(mult6B_Wire),
	.P_0(mult6_out_Wire)

);

pure_mult_wrapper i_mult7(
	.A_0(mult7A_Wire),
	.B_0(mult7B_Wire),
	.P_0(mult7_out_Wire)

);

pure_mult_wrapper i_mult8(
	.A_0(mult8A_Wire),
	.B_0(mult8B_Wire),
	.P_0(mult8_out_Wire)

);

pure_mult_wrapper i_mult9(
	.A_0(mult9A_Wire),
	.B_0(mult9B_Wire),
	.P_0(mult9_out_Wire)

);

pure_mult_wrapper i_mult10(
	.A_0(mult10A_Wire),
	.B_0(mult10B_Wire),
	.P_0(mult10_out_Wire)

);

pure_mult_wrapper i_mult11(
	.A_0(mult11A_Wire),
	.B_0(mult11B_Wire),
	.P_0(mult11_out_Wire)

);

pure_mult_wrapper i_mult12(
	.A_0(mult12A_Wire),
	.B_0(mult12B_Wire),
	.P_0(mult12_out_Wire)

);

pure_mult_wrapper i_mult13(
	.A_0(mult13A_Wire),
	.B_0(mult13B_Wire),
	.P_0(mult13_out_Wire)

);

pure_mult_wrapper i_mult14(	
	.A_0(mult14A_Wire),
	.B_0(mult14B_Wire),
	.P_0(mult14_out_Wire)

);

pure_mult_wrapper i_mult15(
	.A_0(mult15A_Wire),
	.B_0(mult15B_Wire),
	.P_0(mult15_out_Wire)

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

	.dest_offset(dest_offset),
	.vindex_offset(vindex_offset),
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
