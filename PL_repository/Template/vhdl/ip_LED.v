//////////////////////////////////////////////////////////////////////////////////
// Company:   WUT
// Engineer: WUT RUIGE LEE
// Create Date: 2018/06/21 17:44:39
// Last Modified by:   WUT_Ruige_Lee
// Last Modified time: 2019-01-12 17:37:31
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
	CLK,
	RST_n,
	
	LED_FREQ_Set,	
	BZ_FREQ_Set,
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

input [31:0] LED_FREQ_Set;	//as count aim 
input [31:0] BZ_FREQ_Set;
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


reg [31:0] LED_Cnt = 32'd0;

always @(posedge CLK or negedge RST_n) begin
	if ( !RST_n ) begin

		LED_Cnt <= 32'd0;

		LED_R_reg <= 1'b1;
		LED_G_reg <= 1'b1;
		LED_B_reg <= 1'b1;
	end
	else begin

		if ( LED_Cnt > LED_FREQ_Set ) begin
			LED_Cnt <= 32'd0;
			
			LED_R_reg <= 1'b0;	//set 0 to light led
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

//BZ ·äÃùÆ÷¿ØÖÆ²¿·Ö

reg [31:0] BZ_Cnt = 32'd0;

always@( posedge CLK or negedge RST_n ) begin
	if ( !RST_n ) begin
		BZ_Cnt <= 32'd0;
		BZ_reg <= 1'b0;
	end
	else begin
		if ( BZ_Cnt > BZ_FREQ_Set ) begin
			BZ_Cnt <= 32'd0;
			BZ_reg <= 1'd1;
		end
		else if ( BZ_Cnt == ( { 3'b0,BZ_FREQ_Set[31:3] }) ) begin	//12% puty
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

