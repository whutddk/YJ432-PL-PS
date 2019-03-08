//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2018/06/21 10:07:43
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-03-05 15:13:44
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: ip_SRAM
// Project Name:   
// Target Devices:   
// Tool Versions:   
// Description:   
// 
// Dependencies:   
// 
// Revision:  
// Revision:    -   
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps


module perip_SRAM # (
		parameter ADDRW = 20,
		parameter DATAW = 16
	)
	( 
		input CLK,
		input RSTn,

		input mode_R1_W0,
		input [ADDRW-1:0] SRAM_ADDR_Stream,
		input [DATAW-1:0] SRAM_DATA_IN_Stream,
		output [DATAW-1:0] SRAM_DATA_OUT_Stream,


		//driver pin
		output SRAM_OE_Pin,
		output SRAM_WR_Pin,
		output SRAM_CS_Pin,

		output [ADDRW-1:0] SRAM_ADDR_Pin,
		output [DATAW-1:0] SRAM_DATA_IN_Pin,
		input [DATAW-1:0] SRAM_DATA_OUT_Pin
);
	

wire [ADDRW-1:0] address_Din;
wire [ADDRW-1:0] address_Qout;


yj_basic_reg_clk_p # (
		.DW(ADDRW),
		.RSTVAL(1'b0)
	)
	address_reg
	(
		.CLK(CLK),
		.RSTn(RSTn),

		.din(address_Din),
		.qout(address_Qout)
);

assign address_Din = SRAM_ADDR_Stream;
assign SRAM_ADDR_Pin = address_Qout;



//read
wire [DATAW-1:0] dataRead_Din;
wire [DATAW-1:0] dataRead_Qout;

yj_basic_reg_clk_p # (
		.DW(DATAW),
		.RSTVAL(1'b0)
	)
	dataRead_reg
	(
		.CLK(CLK),
		.RSTn(RSTn),

		.din(dataRead_Din),
		.qout(dataRead_Qout)
);

assign dataRead_Din = (mode_R1_W0 == 1'b1) ? SRAM_DATA_OUT_Pin : dataRead_Qout;
assign SRAM_DATA_OUT_Stream = dataRead_Qout;

//write
wire [DATAW-1:0] dataWrite_Din;
wire [DATAW-1:0] dataWrite_Qout;

yj_basic_reg_clk_p # (
		.DW(DATAW),
		.RSTVAL(1'b0)
	)
	dataWrite_reg
	(
		.CLK(CLK),
		.RSTn(RSTn),

		.din(dataWrite_Din),
		.qout(dataWrite_Qout)
);

assign dataWrite_Din = (mode_R1_W0 == 1'b0) ? SRAM_DATA_IN_Stream : dataWrite_Qout;
assign SRAM_DATA_IN_Pin = dataWrite_Qout;

assign SRAM_WR_Pin = mode_R1_W0;
assign SRAM_OE_Pin = 1'b0;
assign SRAM_CS_Pin = 1'b0;













endmodule
