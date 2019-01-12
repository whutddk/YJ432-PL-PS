//////////////////////////////////////////////////////////////////////////////////
// Company:  WUT 
// Engineer: WUT Ruige Lee
// Create Date: 2018/06/22 19:34:39
// Last Modified by:   WUT_Ruige_Lee
// Last Modified time: 2019-01-12 16:55:28
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: YJ432_PL_TOP
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


`timescale 1ns / 1ps



module YJ432_PL_TOP(
	i_sysclk,
	i_fb_clk,

	i_fb_rw,
	i_fb_csn,
	i_fb_ale,
	i_fb_ad,

	i_BZ_IO,
	i_LEDR_IO,
	i_LEDG_IO,
	i_LEDB_IO  
	
);
	
	input i_sysclk;
	input i_fb_clk;

	input i_fb_rw;
	input i_fb_csn;
	input i_fb_ale;
	inout [31:0] i_fb_ad;
 
	output i_BZ_IO;
	output i_LEDR_IO;
	output i_LEDG_IO;
	output i_LEDB_IO;   



wire [31:0] LED_FREQ_wire;
wire [31:0] BZ_FREQ_wire;
wire [31:0] LEDR_Puty_wire;
wire [31:0] LEDG_Puty_wire;
wire [31:0] LEDB_Puty_wire;	


perip_flexbus # (
	.FB_BASE(32'h60000000)
	) i_flexbus
(
	.FB_CLK(i_fb_clk),
	.RST_n(1'b1),

	.FB_RW(i_fb_rw),
	.FB_CS(i_fb_csn),
	.FB_ALE(i_fb_ale),
	.FB_AD(i_fb_ad),
	
	.LED_FREQ_Reg(LED_FREQ_wire),
	.BZ_FREQ_Reg(BZ_FREQ_wire),
	.LEDR_Puty_Reg(LEDR_Puty_wire),
	.LEDG_Puty_Reg(LEDG_Puty_wire),
	.LEDB_Puty_Reg(LEDB_Puty_wire)
);



perip_BZLED i_bzled(
	
	.CLK(i_sysclk),
	.RST_n(1'b1),
		
	.FREQ_Cnt_Set(LED_FREQ_wire),	//作为计数目标，自己外部计算
	.BZ_Puty_Set(BZ_FREQ_wire),
	.LEDR_Puty_Set(LEDR_Puty_wire),
	.LEDG_Puty_Set(LEDG_Puty_wire),
	.LEDB_Puty_Set(LEDB_Puty_wire),

	.BZ(i_BZ_IO),
	.LED_R(i_LEDR_IO),
	.LED_G(i_LEDG_IO),
	.LED_B(i_LEDB_IO)
	);


endmodule



