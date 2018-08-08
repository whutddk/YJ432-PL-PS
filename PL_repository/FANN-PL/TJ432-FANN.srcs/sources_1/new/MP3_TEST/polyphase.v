`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/08/08 11:02:15
// Design Name: 
// Module Name: FDCT32
// Project Name: TJ432-B
// Target Devices: Artix-7 35T
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

module polyphase 
(
	input CLK,    // Clock
	input RST_n,  // Asynchronous reset active low
	
	input [2:0] subband_state,

	//ram operate
	output reg [11:0] Ram_addrA,
	output reg [11:0] Ram_addrB,
	input [31:0] Ram_dataA,
	input [31:0] Ram_dataB,

	//Rom operate
	output reg [8:0] Rom_addrA,
	output reg [8:0] Rom_addrB,
	input [31:0] Rom_dataA,
	input [31:0] Rom_dataB,	

	//FIFO pcm DATA
	output reg [31:0] fifo_data,
	output reg fifo_clk,

	inout [63:0] sum1L_pre_S1,
	inout [31:0] mult1L_A_S1,
	inout [31:0] mult1L_B_S1,
	input [63:0] mult_out1L_S1,

	inout [63:0] sum1L_pre_S2,
	inout [31:0] mult1L_A_S2,
	inout [31:0] mult1L_B_S2,
	input [63:0] mult_out1L_S2,

	inout [63:0] sum2L_pre_S1,
	inout [31:0] mult2L_A_S1,
	inout [31:0] mult2L_B_S1,
	input [63:0] mult_out2L_S1,

	inout [63:0] sum2L_pre_S2,
	inout [31:0] mult2L_A_S2,
	inout [31:0] mult2L_B_S2,
	input [63:0] mult_out2L_S2,

	inout [63:0] sum1R_pre_S1,
	inout [31:0] mult1R_A_S1,
	inout [31:0] mult1R_B_S1,
	input [63:0] mult_out1R_S1,

	inout [63:0] sum1R_pre_S2,
	inout [31:0] mult1R_A_S2,
	inout [31:0] mult1R_B_S2,
	input [63:0] mult_out1R_S2,

	inout [63:0] sum2R_pre_S1,
	inout [31:0] mult2R_A_S1,
	inout [31:0] mult2R_B_S1,
	input [63:0] mult_out2R_S1,

	inout [63:0] sum2R_pre_S2,
	inout [31:0] mult2R_A_S2,
	inout [31:0] mult2R_B_S2,
	input [63:0] mult_out2R_S2,
);

reg [63:0] sum1L_pre_S1_reg;
reg [31:0] mult1L_A_S1_reg;
reg [31:0] mult1L_B_S1_reg;

reg [63:0] sum1L_pre_S2_reg;
reg [31:0] mult1L_A_S2_reg;
reg [31:0] mult1L_B_S2_reg;

reg [63:0] sum2L_pre_S1_reg;
reg [31:0] mult2L_A_S1_reg;
reg [31:0] mult2L_B_S1_reg;

reg [63:0] sum2L_pre_S2_reg;
reg [31:0] mult2L_A_S2_reg;
reg [31:0] mult2L_B_S2_reg;

reg [63:0] sum1R_pre_S1_reg;
reg [31:0] mult1R_A_S1_reg;
reg [31:0] mult1R_B_S1_reg;

reg [63:0] sum1R_pre_S2_reg;
reg [31:0] mult1R_A_S2_reg;
reg [31:0] mult1R_B_S2_reg;

reg [63:0] sum2R_pre_S1_reg;
reg [31:0] mult2R_A_S1_reg;
reg [31:0] mult2R_B_S1_reg;

reg [63:0] sum2R_pre_S2_reg;
reg [31:0] mult2R_A_S2_reg;
reg [31:0] mult2R_B_S2_reg;

//conntion
assign sum1L_pre_S1 = ( subband_state !=  ) ? 64'bz : sum1L_pre_S1_reg;
assign mult1L_A_S1 = ( subband_state !=  ) ? 32'bz : mult1L_A_S1_reg;
assign mult1L_B_S1 = ( subband_state !=  ) ? 32'bz : mult1L_B_S1_reg;

assign sum1L_pre_S2 = ( subband_state !=  ) ? 64'bz : sum1L_pre_S2_reg;
assign mult1L_A_S2 = ( subband_state !=  ) ? 32'bz : mult1L_A_S2_reg;
assign mult1L_B_S2 = ( subband_state !=  ) ? 32'bz : mult1L_B_S2_reg;

assign sum2L_pre_S1 = ( subband_state !=  ) ? 64'bz : sum2L_pre_S1_reg;
assign mult2L_A_S1 = ( subband_state !=  ) ? 32'bz : mult2L_A_S1_reg;
assign mult2L_B_S1 = ( subband_state !=  ) ? 32'bz : mult2L_B_S1_reg;

assign sum2L_pre_S2 = ( subband_state !=  ) ? 64'bz : sum2L_pre_S2_reg;
assign mult2L_A_S2 = ( subband_state !=  ) ? 32'bz : mult2L_A_S2_reg;
assign mult2L_B_S2 = ( subband_state !=  ) ? 32'bz : mult2L_B_S2_reg;

assign sum1R_pre_S1 = ( subband_state !=  ) ? 64'bz : sum1R_pre_S1_reg;
assign mult1R_A_S1 = ( subband_state !=  ) ? 32'bz : mult1R_A_S1_reg;
assign mult1R_B_S1 = ( subband_state !=  ) ? 32'bz : mult1R_B_S1_reg;

assign sum1R_pre_S2 = ( subband_state !=  ) ? 64'bz : sum1R_pre_S2_reg;
assign mult1R_A_S2 = ( subband_state !=  ) ? 32'bz : mult1R_A_S2_reg;
assign mult1R_B_S2 = ( subband_state !=  ) ? 32'bz : mult1R_B_S2_reg;

assign sum2R_pre_S1 = ( subband_state !=  ) ? 64'bz : sum2R_pre_S1_reg;
assign mult2R_A_S1 = ( subband_state !=  ) ? 32'bz : mult2R_A_S1_reg;
assign mult2R_B_S1 = ( subband_state !=  ) ? 32'bz : mult2R_B_S1_reg;

assign sum2R_pre_S2 = ( subband_state !=  ) ? 64'bz : sum2R_pre_S2_reg;
assign mult2R_A_S2 = ( subband_state !=  ) ? 32'bz : mult2R_A_S2_reg;
assign mult2R_B_S2 = ( subband_state !=  ) ? 32'bz : mult2R_B_S2_reg;



reg [31:0] pcm[0:64];
reg [7:0] poly_cnt = 8'd0; 
always @( posedge CLK or negedge RST_n ) begin
if ( !RST_n ) begin
	Ram_addrA <= 12'b0;
	Ram_addrB <= 12'b0;
	Rom_addrA <= 9'b0;
	Rom_addrB <= 9'b0;
	fifo_data <= 32'd0;
	fifo_clk <= 1'b0;

	poly_cnt <= 8'd0;
end

else begin
	poly_cnt <= poly_cnt + 8'd1;
end

end


endmodule

