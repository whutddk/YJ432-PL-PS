`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WUT
// Engineer: WUT RUIGE LEE
// 
// Create Date: 2018/06/21 17:44:39
// Design Name: 
// Module Name: FB_BZLED
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


module FB_BZLED(
	RST_n,
	CLK,
	BUS_ADDR,
	BUS_DATA,
	BUS_CS,

	BUS_read,
	BUS_write,

	BZLED_BASE,

	BZ,
	LED_R,
	LED_G,
	LED_B,
    );


input RST_n;
input CLK;
input [31:0] BUS_ADDR;
inout [31:0] BUS_DATA;
input BUS_CS;

input BUS_read;
input BUS_write;

input BZLED_BASE;

output BZ;
output LED_R;
output LED_G;
output LED_B;

//Register
reg [31:0] BZ_Puty_Reg;
reg [31:0] LEDR_Puty_Reg;
reg [31:0] LEDG_Puty_Reg;
reg [31:0] LEDB_Puty_Reg;

//读写寄存器
always@( negedge BUS_CS or negedge RST_n )
	if ( !RST_n )
	begin
		BZ_Puty_Reg <= 32'b0;
		LEDR_Puty_Reg <= 32'b0;
		LEDG_Puty_Reg <= 32'b0;
		LEDB_Puty_Reg <= 32'b0;
	end




endmodule