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

	i_fb_oen,
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

input i_fb_oen;
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
	

wire [31:0] FB_RAM_DATA_Wire;
wire [11:0] FB_RAM_ADDR_Wire;
wire [3:0] vindex_Wire;
wire b_Wire;
wire RAM_WR_EN_Wire;
wire [3:0] subband_state_Wire;
wire IP_Done_Wire;

// wire FIFO_CLK_wire;
wire Is_Empty_Wire;

flexbus_comm i_flexbus(
	.FB_BASE(32'h60000000),

	.FB_CLK(i_fb_clk),
	.RST_n(1'b1),
	.FB_OE(i_fb_oen),
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
	
	.RAM_DATA_Reg(FB_RAM_DATA_Wire),
	.RAM_ADDR(FB_RAM_ADDR_Wire),

	.vindex(vindex_Wire),
	.b(b_Wire),

	.RAM_WR_EN_Reg(RAM_WR_EN_Wire),
	.subband_state(subband_state_Wire),

	.IP_Done(IP_Done_Wire),

	.Is_Empty_Wire(Is_Empty_Wire),
	// .STEAM_DATA(STREAM_DATA_Wire),  //put data into here
	// .FIFO_CLK(FIFO_CLK_wire)
	
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

wire [31:0] RAM_DATA_OUTA_Wire;
wire [31:0] RAM_DATA_OUTB_Wire;
wire [11:0] RAM_ADDR_B_Wire;

mp3_mid i_mp3(
	.MP3_CLK(i_fb_clk),
	.RST_n(1'b1),

	.RAM_dataA_out(RAM_DATA_OUTA_Wire),
	.RAM_dataB_out(RAM_DATA_OUTB_Wire),
	.RAM_addrA(FB_RAM_ADDR_Wire),
	.RAM_addrB(RAM_ADDR_B_Wire),

	.subband_state(subband_state_Wire),

	//CTL
	.vindex(vindex_Wire),
	.b(b_Wire),
	.IP_Done(IP_Done_Wire),

	.FIFO_EN(Pcm_wden_Wire),
	.FIFO_DATA(PCM_DATA_Wire)

	);



RAM_wrapper i_RAM(
	.BRAM_PORTA_0_addr(FB_RAM_ADDR_Wire),
	.BRAM_PORTA_0_clk(i_fb_clk),
	.BRAM_PORTA_0_din(FB_RAM_DATA_Wire),
	.BRAM_PORTA_0_dout(RAM_DATA_OUTA_Wire),
	.BRAM_PORTA_0_we(RAM_WR_EN_Wire),

	.BRAM_PORTB_0_addr(RAM_ADDR_B_Wire),
	.BRAM_PORTB_0_clk(i_fb_clk),
	.BRAM_PORTB_0_din(),
	.BRAM_PORTB_0_dout(RAM_DATA_OUTB_Wire),
	.BRAM_PORTB_0_we(1'b0)
);


endmodule
