`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhn university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/08/09 11:21:50
// Design Name: 
// Module Name: mp3_mid
// Project Name: TJ432-B
// Target Devices: XC7A35T
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


module mp3_mid(
	input MP3_CLK,
	input RST_n,

	input [31:0] RAM_data_out,
	inout [11:0] RAM_addr,

    input [3:0] subband_state,
	    //CTL
	input [3:0] vindex,
	input b,
	output IP_Done,

    output FIFO_EN,
    output [15:0] FIFO_DATA

    );

wire [63:0] sum0;
wire [31:0] mult0A;
wire [31:0] mult0B;
wire [63:0] mult0_out;

wire [63:0] sum1;
wire [31:0] mult1A;
wire [31:0] mult1B;
wire [63:0] mult1_out;

wire [63:0] sum2;
wire [31:0] mult2A;
wire [31:0] mult2B;
wire [63:0] mult2_out;

wire [63:0] sum3;
wire [31:0] mult3A;
wire [31:0] mult3B;
wire [63:0] mult3_out;



  
polyphase i_polyhpase
(
	.CLK(MP3_CLK),	// Clock
	.RST_n(RST_n),	// Asynchronous reset active low

	//state
	.subband_state(subband_state),

	//CTL
	.vindex(vindex),
	.b(b),
	.IP_Done(IP_Done),

//ram operate
inout [11:0] Ram_addrA,
inout [11:0] Ram_addrB,
input [31:0] Ram_dataA,
input [31:0] Ram_dataB,

//Rom operate
inout [8:0] Rom_addrA,
inout [8:0] Rom_addrB,
input [31:0] Rom_dataA,
input [31:0] Rom_dataB,    

//FIFO pcm DATA
output reg [31:0] fifo_data,
output reg fifo_enable,

	.sum1L_pre(sum0),
	.mult1L_A(mult0A),
	.mult1L_B(mult0B),
	.mult_out1L(mult0_out),

	.sum2L_pre(sum1),
	.mult2L_A(mult1A),
	.mult2L_B(mult1B),
	.mult_out2L(mult1_out),

	.sum1R_pre(sum2),
	.mult1R_A(mult2A),
	.mult1R_B(mult2B),
	.mult_out1R(mult2_out),

	.sum2R_pre(sum3),
	.mult2R_A(mult3A),
	.mult2R_B(mult3B),
	.mult_out2R(mult3_out)

);
    
multiplier i_mult0(
	.sum(sum0),
	.multA(mult0A),
	.multB(mult0B),
	.mult_out(mult0_out)

);
multiplier i_mult1(
	.sum(sum1),
	.multA(mult1A),
	.multB(mult1B),
	.mult_out(mult1_out)

);

multiplier i_mult2(
	.sum(sum2),
	.multA(mult2A),
	.multB(mult2B),
	.mult_out(mult2_out)

);

multiplier i_mult3(
	.sum(sum3),
	.multA(mult3A),
	.multB(mult3B),
	.mult_out(mult3_out)

);

    
    
    
endmodule
