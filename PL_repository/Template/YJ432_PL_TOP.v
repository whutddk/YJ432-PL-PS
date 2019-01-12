//////////////////////////////////////////////////////////////////////////////////
// Company:  WUT 
// Engineer: WUT Ruige Lee
// Create Date: 2018/06/22 19:34:39
// Last Modified by:   WUT_Ruige_Lee
// Last Modified time: 2019-01-12 16:36:24
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

    i_fb_oen,
    i_fb_rw,
    i_fb_csn,
    i_fb_ale,
    i_fb_ad,

    i_BZ_IO,
    i_LEDR_IO,
    i_LEDG_IO,
    i_LEDB_IO,  


    
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
   
    
ip_flexbus i_flexbus(
    .FB_CLK(i_fb_clk),
    .RST_n(1'b1),
    .FB_OE(i_fb_oen),
    .FB_RW(i_fb_rw),
    .FB_CS(i_fb_csn),
    .FB_ALE(i_fb_ale),
    .FB_AD(i_fb_ad),
    
    
    .ip_ADDR(i_bus_addr),
    .ip_DATA(i_bus_data),     
    .ip_Read( i_bus_read ),
    .ip_Write( i_bus_write )
);

wire [31:0] LED_FREQ_Cnt_wire;
wire [31:0] BZ_Puty_wire;
wire [31:0] LEDR_Puty_wire;
wire [31:0] LEDG_Puty_wire;
wire [31:0] LEDB_Puty_wire;



BZLED i_bzled(
	.RST_n(1'b1),
	.CLK(i_sysclk),
		
	.FREQ_Cnt_Set(LED_FREQ_Cnt_wire),	//作为计数目标，自己外部计算
	.BZ_Puty_Set(BZ_Puty_wire),
	.LEDR_Puty_Set(LEDR_Puty_wire),
	.LEDG_Puty_Set(LEDG_Puty_wire),
	.LEDB_Puty_Set(LEDB_Puty_wire),

	.BZ(i_BZ_IO),
	.LED_R(i_LEDR_IO),
	.LED_G(i_LEDG_IO),
	.LED_B(i_LEDB_IO)
	);


endmodule



