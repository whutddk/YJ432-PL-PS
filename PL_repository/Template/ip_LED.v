//////////////////////////////////////////////////////////////////////////////////
// Company:   WUT
// Engineer: WUT RUIGE LEE
// Create Date: 2018/06/21 17:44:39
// Last Modified by:   WUT_Ruige_Lee
// Last Modified time: 2019-01-12 16:29:12
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: ip_LED
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


module perip_BZLED(
	RST_n,
	CLK,
	FREQ_Cnt_Set,	//作为计数目标，自己外部计算
	BZ_Puty_Set,
	LEDR_Puty_Set,
	LEDG_Puty_Set,
	LEDB_Puty_Set,

	BZ,
	LED_R,
	LED_G,
	LED_B
	);

input RST_n;
input CLK;

input [31:0] FREQ_Cnt_Set;	//作为计数目标，自己外部计算
input [31:0] BZ_Puty_Set;
input [31:0] LEDR_Puty_Set;
input [31:0] LEDG_Puty_Set;
input [31:0] LEDB_Puty_Set;

output BZ;
output LED_R;
output LED_G;
output LED_B;

reg BZ_reg;
reg LED_R_reg;
reg LED_G_reg;
reg LED_B_reg;

assign BZ = BZ_reg;
assign LED_R = LED_R_reg;
assign LED_G = LED_G_reg;
assign LED_B = LED_B_reg;




//LED控制部分
reg [31:0] LED_Cnt = 32'd0;

always @(posedge CLK or negedge RST_n) begin
	if ( !RST_n ) begin



		LED_Cnt <= 32'd0;

		LED_R_reg <= 1'b1;
		LED_G_reg <= 1'b1;
		LED_B_reg <= 1'b1;
	end
	else begin

		if ( LED_Cnt >= FREQ_Cnt_Set ) begin
			LED_Cnt <= 32'd0;
			
			LED_R_reg <= 1'b0;	//负逻辑，点亮?
			LED_G_reg <= 1'b0;
			LED_B_reg <= 1'b0;
		end
		else begin
			LED_Cnt <= LED_Cnt + 32'd1;

		end

		if ( LED_Cnt == LEDR_Puty_Set ) begin
			LED_R_reg <= 1'b1;
		end

		if ( LED_Cnt == LEDG_Puty_Set ) begin
			LED_G_reg <= 1'b1;
		end

		if ( LED_Cnt == LEDB_Puty_Set ) begin
			LED_B_reg <= 1'b1;
		end
	end
end

//BZ 蜂鸣器控制部分

reg [31:0] BZ_Cnt = 32'd0;

always@( posedge CLK or negedge RST_n ) begin
	if ( !RST_n ) begin
        BZ_Cnt <= 32'd0;
        BZ_reg <= 1'b0;
	end
	else begin
		if ( BZ_Cnt >= BZ_Puty_Set ) begin
			BZ_Cnt <= 32'd0;
			BZ_reg <= 1'd1;
		end
		else if ( BZ_Cnt == ( BZ_Puty_Set >> 3) ) begin	//12%占空比	
			BZ_Cnt <= BZ_Cnt + 32'd1;
			BZ_reg <= 1'd0;
		end
		else begin
			BZ_Cnt <= BZ_Cnt + 32'd1;
			BZ_reg <= BZ_reg;
		end
		

	end
end

endmodule // BZLED

