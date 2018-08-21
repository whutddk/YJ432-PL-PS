`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: wuhan university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/07/19 15:12:36
// Design Name: `
// Module Name: TJ432_TOP
// Project Name: 
// Target Devices: 
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


module TJ432_TOP(
	i_sysclk,
	i_fb_clk,

	// i_fb_oen,
	i_fb_rw,
	i_fb_csn,
	i_fb_ale,
	i_fb_ad,

	i_BZ_IO,
	i_LEDR_IO,
	i_LEDG_IO,
	i_LEDB_IO,
	
	i_I2SMCLK,
	i_I2SBSCK,
	i_I2SLRCK,
	i_I2STXD  
	);
	
input i_sysclk;
input i_fb_clk;

// input i_fb_oen;
input i_fb_rw;
input i_fb_csn;
input i_fb_ale;
inout [31:0] i_fb_ad;

output i_BZ_IO;
output i_LEDR_IO;
output i_LEDG_IO;
output i_LEDB_IO;   

output i_I2SMCLK;
output i_I2SBSCK;
output i_I2SLRCK;
output i_I2STXD;

wire [31:0] FREQ_Cnt_Wire;	
wire [31:0] BZ_Puty_Wire;
wire [31:0] LEDR_Puty_Wire;
wire [31:0] LEDG_Puty_Wire;
wire [31:0] LEDB_Puty_Wire; 
	

wire [11:0] vbuf_offset_Wire;
wire [11:0] dest_vindex_offset_Wire;
wire oddBlock_Wire;


wire [2:0] subband_state_Wire;
wire POLY_Done_Wire;
wire FDCT_Done_Wire;

wire Is_Empty_Wire;

wire [31:0] MIBUF_DATA_Wire;
wire [5:0] MIBUF_ADDR_Wire;

flexbus_comm i_flexbus(
	.FB_BASE(32'h60000000),

	.FB_CLK(i_fb_clk),
	.RST_n(1'b1),
	// .FB_OE(i_fb_oen),
	.FB_RW(i_fb_rw),
	.FB_CS(i_fb_csn),
	.FB_ALE(i_fb_ale),
//    input FB_BE31_24,
//    input FB_BE23_16,
//    input FB_BE15_8,
//    input FB_BE7_0,
	.FB_AD(i_fb_ad),
	

	.FREQ_Cnt_Reg(FREQ_Cnt_Wire),
	.BZ_Puty_Reg(BZ_Puty_Wire),
	.LEDR_Puty_Reg(LEDR_Puty_Wire),
	.LEDG_Puty_Reg(LEDG_Puty_Wire),
	.LEDB_Puty_Reg(LEDB_Puty_Wire),
	
	.MIBUF_DATA_Reg(MIBUF_DATA_Wire),
	.MIBUF_ADDR_Reg(MIBUF_ADDR_Wire),

	.vbuf_offset(vbuf_offset_Wire),
	.dest_vindex_offset(dest_vindex_offset_Wire),
	.oddBlock(oddBlock_Wire),

	.subband_state(subband_state_Wire),

	.POLY_Done(POLY_Done_Wire),
	.FDCT_Done(FDCT_Done_Wire),

	.Is_Empty_Wire(Is_Empty_Wire)

	
	);
	
BZLED i_BZLED(
		.RST_n(1'b1),
		.CLK(i_sysclk),
		.FREQ_Cnt_Set(FREQ_Cnt_Wire),    //作为计数目标，自己外部计算
		.BZ_Puty_Set(BZ_Puty_Wire),
		.LEDR_Puty_Set(LEDR_Puty_Wire),
		.LEDG_Puty_Set(LEDG_Puty_Wire),
		.LEDB_Puty_Set(LEDB_Puty_Wire),
	
		.BZ(i_BZ_IO),
		.LED_R(i_LEDR_IO),
		.LED_G(i_LEDG_IO),
		.LED_B(i_LEDB_IO)
		);   

wire I2S_MCLK_Wire;
wire [15:0] i2s_data_Wire;
wire i2s_rd_Wire;
wire Pcm_wden_Wire;
wire [15:0] PCM_DATA_Wire;

I2S_SUP_wrapper i_i2s_support(
	.FIFO_READ_0_empty(),
	.FIFO_READ_0_rd_data(i2s_data_Wire),
	.FIFO_READ_0_rd_en(1'b1),
	.FIFO_WRITE_0_full(),
		.FIFO_WRITE_0_wr_data(PCM_DATA_Wire),
		.FIFO_WRITE_0_wr_en(Pcm_wden_Wire),
	.I2S_clk(I2S_MCLK_Wire),
	.clk_100MHz(i_sysclk),
	.prog_empty_0(Is_Empty_Wire),
	.rd_clk_0(i2s_rd_Wire),
	.rst_0(1'b0),
		.wr_clk_0(i_fb_clk)
	);


I2S16bit i_i2s(
	.CLK(I2S_MCLK_Wire),
	.RST_n(1'b1), 
	.data_input(i2s_data_Wire),

	.MCLK(i_I2SMCLK),
	.LCRK(i_I2SLRCK),
	.BSCK(i_I2SBSCK),
	.TXD(i_I2STXD),
	.DATA_CLK(i2s_rd_Wire) //LCRK对齐的下跳沿请求数据
);



mp3_mid i_mp3(
	.MP3_CLK(i_fb_clk),
	.RST_n(1'b1),

	.subband_state(subband_state_Wire),
	
	.vbuf_offset(vbuf_offset_Wire),
	.dest_vindex_offset(dest_vindex_offset_Wire),
	.oddBlock(oddBlock_Wire),
	
	.POLY_Done(POLY_Done_Wire),
	.FDCT_Done(FDCT_Done_Wire),

	.FIFO_EN(Pcm_wden_Wire),
	.FIFO_DATA(PCM_DATA_Wire),

	.FB_MIBUF_DATA(MIBUF_DATA_Wire),
	.FB_MIBUF_ADDR(MIBUF_ADDR_Wire)

	);






endmodule
