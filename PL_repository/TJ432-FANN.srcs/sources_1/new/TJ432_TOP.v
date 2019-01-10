`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/19 15:12:36
// Design Name: 
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
    i_LEDB_IO  
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


wire [31:0] FREQ_Cnt_Wire;	
wire [31:0] BZ_Puty_Wire;
wire [31:0] LEDR_Puty_Wire;
wire [31:0] LEDG_Puty_Wire;
wire [31:0] LEDB_Puty_Wire; 
    
    
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
    .LEDB_Puty_Reg(LEDB_Puty_Wire) 
    
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
    
endmodule
