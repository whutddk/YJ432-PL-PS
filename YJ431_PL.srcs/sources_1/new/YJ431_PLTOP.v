`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/22 19:34:39
// Design Name: 
// Module Name: YJ431_PLTOP
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


module YJ431_PLTOP(

    input i_sysclk,//��ʱ������FBʱ�Ӻ�sysclk��ͳһ��100M���в���
    
    
    output i_BZ_IO,
    output i_LEDR_IO,
    output i_LEDG_IO,
    output i_LEDB_IO
    //output [7:0] i_data_out
    
    );
    
        wire i_fb_clk;
        wire i_fb_oen;
        wire i_fb_rw;
        wire i_fb_csn;
        wire i_fb_ale;
        
        wire [31:0] i_fb_ad; 
    
    FB_AUTOTEST i_autotest(
        .RST_n(1'b1),
        .CLK(i_sysclk),      // ��40MHZ ֱͨ
    

        .FB_CLK(i_fb_clk),
        .FB_OE_n(i_fb_oen),
        .FB_RW(i_fb_rw),
        .FB_CS_n(i_fb_csn),
        .FB_ALE(i_fb_ale),
        .FB_AD(i_fb_ad),
        
        .data_out()//i_data_out) 
    
        );
        
        wire [31:0] i_bus_addr;
        wire [31:0] i_bus_data;
        wire i_bus_read;
        wire i_bus_write;
        
        
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

wire [31:0] FREQ_Cnt_wire;
wire [31:0] BZ_Puty_wire;
wire [31:0] LEDR_Puty_wire;
wire [31:0] LEDG_Puty_wire;
wire [31:0] LEDB_Puty_wire;


FB_BZLEDREG(
	.RST_n(1'b1),
	.BUS_ADDR(i_bus_addr),
	.BUS_DATA(i_bus_data),
	.BUS_CS(i_fb_csn),

	.BUS_read(i_bus_read),
	.BUS_write(i_bus_write),

	.BZLED_BASE(10'h180),

//Register
	.FREQ_Cnt_Reg(FREQ_Cnt_wire),	//��Ϊ����Ŀ�꣬�Լ��ⲿ����
	.BZ_Puty_Reg(BZ_Puty_wire),
	.LEDR_Puty_Reg(LEDR_Puty_wire),
	.LEDG_Puty_Reg(LEDG_Puty_wire),
	.LEDB_Puty_Reg(LEDB_Puty_wire)
    );


BZLED(
	.RST_n(1'b1),
	.CLK(i_sysclk),
	
	
	.FREQ_Cnt_Set(FREQ_Cnt_wire),	//��Ϊ����Ŀ�꣬�Լ��ⲿ����
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



