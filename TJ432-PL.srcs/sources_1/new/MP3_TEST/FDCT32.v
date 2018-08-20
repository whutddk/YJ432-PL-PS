`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/08/01 11:18:36
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



module FDCT32 (
	CLK,    // Clock flexbus 40MHZ 
	RST_n,  // Asynchronous reset active low

	gb,
	offset,
	oddBlock,
	
	sum0,
	mult0A,
	mult0B,
	mult0_out,

	sum1,
	mult1A,
	mult1B,
	mult1_out,

	sum2,
	mult2A,
	mult2B,
	mult2_out,
	
	sum3,	
	mult3A,
	mult3B,
	mult3_out,
		
	mult4A,
	mult4B,
	mult4_out,
		
	mult5A,
	mult5B,
	mult5_out,
		
	mult6A,
	mult6B,
	mult6_out,
		
	mult7A,
	mult7B,
	mult7_out,
		
	mult8A,
	mult8B,
	mult8_out,
		
	mult9A,
	mult9B,
	mult9_out,
		
	mult10A,
	mult10B,
	mult10_out,
		
	mult11A,
	mult11B,
	mult11_out,
		
	mult12A,
	mult12B,
	mult12_out,
		
	mult13A,
	mult13B,
	mult13_out,
		
	mult14A,
	mult14B,
	mult14_out,
		
	mult15A,
	mult15B,
	mult15_out,

	//ram operate
	Ram_addrA,
	Ram_addrB,
	Ram_data,

	//MIBUF
	FB_MIBUF_DATA,
	FB_MIBUF_ADDR,

	//state
	subband_state
);

parameter ST_IDLE = 3'd0;
parameter ST_MIBUF = 3'd1;
parameter ST_FDCT = 3'd2;
parameter ST_FBRAM = 3'd3;
parameter ST_PLOY = 3'd4;

input CLK;
input RST_n;
input  gb;
input [31:0] offset;
input  oddBlock;

//one cycle to wirte,2cycle to read
output reg [11:0] Ram_addrA;
output reg [11:0] Ram_addrB;
output reg [31:0] Ram_data;

output reg [63:0] sum0;
output reg [31:0] mult0A;
output reg [31:0] mult0B;
input [63:0] mult0_out;

output reg [63:0] sum1;
output reg [31:0] mult1A;
output reg [31:0] mult1B;
input [63:0] mult1_out;

output reg [63:0] sum2;
output reg [31:0] mult2A;
output reg [31:0] mult2B;
input [63:0] mult2_out;
	
output reg [63:0] sum3;
output reg [31:0] mult3A;
output reg [31:0] mult3B;
input [63:0] mult3_out;
	
output reg [31:0] mult4A;
output reg [31:0] mult4B;
input [63:0] mult4_out;
	
output reg [31:0] mult5A;
output reg [31:0] mult5B;
input [63:0] mult5_out;
	
output reg [31:0] mult6A;
output reg [31:0] mult6B;
input [63:0] mult6_out;
	
output reg [31:0] mult7A;
output reg [31:0] mult7B;
input [63:0] mult7_out;
	
output reg [31:0] mult8A;
output reg [31:0] mult8B;
input [63:0] mult8_out;
	
output reg [31:0] mult9A;
output reg [31:0] mult9B;
input [63:0] mult9_out;
	
output reg [31:0] mult10A;
output reg [31:0] mult10B;
input [63:0] mult10_out;
	
output reg [31:0] mult11A;
output reg [31:0] mult11B;
input [63:0] mult11_out;
	
output reg [31:0] mult12A;
output reg [31:0] mult12B;
input [63:0] mult12_out;
	
output reg [31:0] mult13A;
output reg [31:0] mult13B;
input [63:0] mult13_out;
	
output reg [31:0] mult14A;
output reg [31:0] mult14B;
input [63:0] mult14_out;
	
output reg [31:0] mult15A;
output reg [31:0] mult15B;
input [63:0] mult15_out;

input [31:0] FB_MIBUF_DATA;
input [5:0] FB_MIBUF_ADDR;

input [2:0] subband_state;


integer VBUF_LENGTH = 1088;

wire [11:0] odd_plus;
wire [11:0] odd_plus_n;
assign odd_plus = oddBlock ? VBUF_LENGTH  : 0;
assign odd_plus_n = oddBlock ? 0 : VBUF_LENGTH;

reg [31:0] MI_BUF[0:31];

//reg [31:0] vbuf[0:2176];

reg [7:0] fdct32_clk_cnt = 8'd0;

reg [31:0] b0[0:7];
reg [31:0] b1[0:7];
reg [31:0] b2[0:7];
reg [31:0] b3[0:7];


reg [31:0] a0[0:3];
reg [31:0] a1[0:3];
reg [31:0] a2[0:3];
reg [31:0] a3[0:3];
reg [31:0] a4[0:3];
reg [31:0] a5[0:3];
reg [31:0] a6[0:3];
reg [31:0] a7[0:3];




//D32FP
always@(posedge CLK or negedge RST_n)
if ( !RST_n ) begin
	fdct32_clk_cnt <= 8'd0;

	b0[0] <= 32'd0;
	b0[1] <= 32'd0;
	b0[2] <= 32'd0;
	b0[3] <= 32'd0;
	b0[4] <= 32'd0;
	b0[5] <= 32'd0;
	b0[6] <= 32'd0;
	b0[7] <= 32'd0;

	b1[0] <= 32'd0;
	b1[1] <= 32'd0;
	b1[2] <= 32'd0;
	b1[3] <= 32'd0;
	b1[4] <= 32'd0;
	b1[5] <= 32'd0;
	b1[6] <= 32'd0;
	b1[7] <= 32'd0;

	b2[0] <= 32'd0;
	b2[1] <= 32'd0;
	b2[2] <= 32'd0;
	b2[3] <= 32'd0;
	b2[4] <= 32'd0;
	b2[5] <= 32'd0;
	b2[6] <= 32'd0;
	b2[7] <= 32'd0;

	b3[0] <= 32'd0;
	b3[1] <= 32'd0;
	b3[2] <= 32'd0;
	b3[3] <= 32'd0;
	b3[4] <= 32'd0;
	b3[5] <= 32'd0;
	b3[6] <= 32'd0;
	b3[7] <= 32'd0;


	a0[0] <= 32'd0;
	a0[1] <= 32'd0;
	a0[2] <= 32'd0;
	a0[3] <= 32'd0;

	a1[0] <= 32'd0;
	a1[1] <= 32'd0;
	a1[2] <= 32'd0;
	a1[3] <= 32'd0;

	a2[0] <= 32'd0;
	a2[1] <= 32'd0;
	a2[2] <= 32'd0;
	a2[3] <= 32'd0;

	a3[0] <= 32'd0;
	a3[1] <= 32'd0;
	a3[2] <= 32'd0;
	a3[3] <= 32'd0;

	a4[0] <= 32'd0;
	a4[1] <= 32'd0;
	a4[2] <= 32'd0;
	a4[3] <= 32'd0;

	a5[0] <= 32'd0;
	a5[1] <= 32'd0;
	a5[2] <= 32'd0;
	a5[3] <= 32'd0;

	a6[0] <= 32'd0;
	a6[1] <= 32'd0;
	a6[2] <= 32'd0;
	a6[3] <= 32'd0;

	a7[0] <= 32'd0;
	a7[1] <= 32'd0;
	a7[2] <= 32'd0;
	a7[3] <= 32'd0;

	Ram_addrA <= 12'd0;
	Ram_addrB <= 12'd0;
	Ram_data <= 32'd0;

	sum0 <= 64'd0;
	sum1 <= 64'd0;
	sum2 <= 64'd0;
	sum3 <= 64'd0;
	mult0A <= 32'd0;
	mult0B <= 32'd0;
	mult1A <= 32'd0;
	mult1B <= 32'd0;
	mult2A <= 32'd0;
	mult2B <= 32'd0;
	mult3A <= 32'd0;
	mult3B <= 32'd0;
	mult4A <= 32'd0;
	mult4B <= 32'd0;
	mult5A <= 32'd0;
	mult5B <= 32'd0;	
	mult6A <= 32'd0;
	mult6B <= 32'd0;
	mult7A <= 32'd0; 
	mult7B <= 32'd0;
	mult8A <= 32'd0;
	mult8B <= 32'd0;
	mult9A <= 32'd0;
	mult9B <= 32'd0;
	mult10A <= 32'd0;
	mult10B <= 32'd0;
	mult11A <= 32'd0;
	mult11B <= 32'd0;
	mult12A <= 32'd0;
	mult12B <= 32'd0;
	mult13A <= 32'd0;
	mult13B <= 32'd0;
	mult14A <= 32'd0;
	mult14B <= 32'd0;
	mult15A <= 32'd0;
	mult15B <= 32'd0;

end
else begin
	if ( subband_state == ST_MIBUF ) begin
			MI_BUF[FB_MIBUF_ADDR] <= FB_MIBUF_DATA;
	end // if ( subband_state == ST_MIBUF )

	else if ( subband_state == ST_FDCT )begin
		fdct32_clk_cnt <= fdct32_clk_cnt + 1'd1;

		sum0 <= 64'd0;
		sum1 <= 64'd0;
		sum2 <= 64'd0;
		sum3 <= 64'd0;

		if ( fdct32_clk_cnt == 8'd0 ) begin
			b0[0] <= MI_BUF[0] + MI_BUF[31];
			b0[1] <= MI_BUF[1] + MI_BUF[30];
			b0[2] <= MI_BUF[2] + MI_BUF[29];
			b0[3] <= MI_BUF[3] + MI_BUF[28];
			b0[4] <= MI_BUF[4] + MI_BUF[27];
			b0[5] <= MI_BUF[5] + MI_BUF[26];
			b0[6] <= MI_BUF[6] + MI_BUF[25];
			b0[7] <= MI_BUF[7] + MI_BUF[24];

			b1[0] <= MI_BUF[15] + MI_BUF[16];
			b1[1] <= MI_BUF[14] + MI_BUF[17];
			b1[2] <= MI_BUF[13] + MI_BUF[18];
			b1[3] <= MI_BUF[12] + MI_BUF[19];
			b1[4] <= MI_BUF[11] + MI_BUF[20];
			b1[5] <= MI_BUF[10] + MI_BUF[21];
			b1[6] <= MI_BUF[ 9] + MI_BUF[22];
			b1[7] <= MI_BUF[ 8] + MI_BUF[23];

			mult0A <= 32'h4013c251;
			mult0B <= MI_BUF[ 0] - MI_BUF[31];
			mult1A <= 32'h40b345bd;
			mult1B <= MI_BUF[ 1] - MI_BUF[30];
			mult2A <= 32'h41fa2d6d;
			mult2B <= MI_BUF[ 2] - MI_BUF[29];
			mult3A <=  32'h43f93421 ;
			mult3B <= MI_BUF[ 3] - MI_BUF[28];
			mult4A <= 32'h46cc1bc4;
			mult4B <= MI_BUF[ 4] - MI_BUF[27];
			mult5A <= 32'h4a9d9cf0;
			mult5B <= MI_BUF[ 5] - MI_BUF[26];
			mult6A <= 32'h4fae3711;
			mult6B <= MI_BUF[ 6] - MI_BUF[25];
			mult7A <= 32'h56601ea7;
			mult7B <= MI_BUF[ 7] - MI_BUF[24];

			mult8A  <= 32'h518522fb;
			mult8B  <= MI_BUF[15] - MI_BUF[16];
			mult9A  <= 32'h6d0b20cf ;
			mult9B  <= MI_BUF[14] - MI_BUF[17];
			mult10A <= 32'h41d95790;
			mult10B <= MI_BUF[13] - MI_BUF[18];
			mult11A <= 32'h5efc8d96;
			mult11B <= MI_BUF[12] - MI_BUF[19];
			mult12A <= 32'h4ad81a97;
			mult12B <= MI_BUF[11] - MI_BUF[20];
			mult13A <= 32'h7c7d1db3;
			mult13B <= MI_BUF[10] - MI_BUF[21];
			mult14A <= 32'h6b6fcf26;
			mult14B <= MI_BUF[ 9] - MI_BUF[22];
			mult15A <= 32'h5f4cf6eb;
			mult15B <= MI_BUF[ 8] - MI_BUF[23];


			// b3[0] <= ( 32'h4013c251 * (MI_BUF[ 0] - MI_BUF[31]) ) >> 31; //bug:64-32 -1
			// b3[1] <= ( 32'h40b345bd * (MI_BUF[ 1] - MI_BUF[30]) ) >> 31;
			// b3[2] <= ( 32'h41fa2d6d * (MI_BUF[ 2] - MI_BUF[29]) ) >> 31;
			// b3[3] <= ( 32'h43f93421 * (MI_BUF[ 3] - MI_BUF[28]) ) >> 31;
			// b3[4] <= ( 32'h46cc1bc4 * (MI_BUF[ 4] - MI_BUF[27]) ) >> 31;
			// b3[5] <= ( 32'h4a9d9cf0 * (MI_BUF[ 5] - MI_BUF[26]) ) >> 31;
			// b3[6] <= ( 32'h4fae3711 * (MI_BUF[ 6] - MI_BUF[25]) ) >> 31;
			// b3[7] <= ( 32'h56601ea7 * (MI_BUF[ 7] - MI_BUF[24]) ) >> 31;

			// b2[0] <= ( 32'h518522fb * (MI_BUF[15] - MI_BUF[16]) ) >> 27;//bug:64-32 -5
			// b2[0] <= ( 32'h6d0b20cf * (MI_BUF[14] - MI_BUF[17]) ) >> 29;
			// b2[0] <= ( 32'h41d95790 * (MI_BUF[13] - MI_BUF[18]) ) >> 29;
			// b2[0] <= ( 32'h5efc8d96 * (MI_BUF[12] - MI_BUF[19]) ) >> 30;
			// b2[0] <= ( 32'h4ad81a97 * (MI_BUF[11] - MI_BUF[20]) ) >> 30;
			// b2[0] <= ( 32'h7c7d1db3 * (MI_BUF[10] - MI_BUF[21]) ) >> 31;
			// b2[0] <= ( 32'h6b6fcf26 * (MI_BUF[ 9] - MI_BUF[22]) ) >> 31;
			// b2[0] <= ( 32'h5f4cf6eb * (MI_BUF[ 8] - MI_BUF[23]) ) >> 31;
			
		end // if ( fdct32_clk_cnt == 8'd0 )

		else if ( fdct32_clk_cnt == 8'd1 ) begin

			b3[0] <= mult0_out[62:31]; //bug:64-32 -1
			b3[1] <= mult1_out[62:31];
			b3[2] <= mult2_out[62:31];
			b3[3] <= mult3_out[62:31];
			b3[4] <= mult4_out[62:31];
			b3[5] <= mult5_out[62:31];
			b3[6] <= mult6_out[62:31];
			b3[7] <= mult7_out[62:31];

			b2[0] <= mult7_out[58:27];
			b2[0] <= mult7_out[60:29];
			b2[0] <= mult7_out[60:29];
			b2[0] <= mult7_out[61:30];
			b2[0] <= mult7_out[61:30];
			b2[0] <= mult7_out[62:31];
			b2[0] <= mult7_out[62:31];
			b2[0] <= mult7_out[62:31];
		end // else if ( fdct32_clk_cnt == 8'd1 )
		else if ( fdct32_clk_cnt == 8'd2 ) begin

			MI_BUF[0] <= b0[0] + b1[0];
			MI_BUF[1] <= b0[1] + b1[1];
			MI_BUF[2] <= b0[2] + b1[2];
			MI_BUF[3] <= b0[3] + b1[3];
			MI_BUF[4] <= b0[4] + b1[4];
			MI_BUF[5] <= b0[5] + b1[5];
			MI_BUF[6] <= b0[6] + b1[6];
			MI_BUF[7] <= b0[7] + b1[7];



			MI_BUF[16] = b2[0] + b3[0];
			MI_BUF[17] = b2[1] + b3[1];
			MI_BUF[18] = b2[2] + b3[2];
			MI_BUF[19] = b2[3] + b3[3];
			MI_BUF[20] = b2[4] + b3[4];
			MI_BUF[21] = b2[5] + b3[5];
			MI_BUF[22] = b2[6] + b3[6];
			MI_BUF[23] = b2[7] + b3[7];

			mult0A <= 32'h404f4672;
			mult0B <= b0[0] - b1[0];
			mult1A <= 32'h42e13c10;
			mult1B <= b0[1] - b1[1];
			mult2A <= 32'h48919f44;
			mult2B <= b0[2] - b1[2];
			mult3A <= 32'h52cb0e63;
			mult3B <= b0[3] - b1[3];
			mult4A <= 32'h64e2402e;
			mult4B <= b0[4] - b1[4];
			mult5A <= 32'h43e224a9;
			mult5B <= b0[5] - b1[5];
			mult6A <= 32'h6e3c92c1;
			mult6B <= b0[6] - b1[6];
			mult7A <= 32'h519e4e04;
			mult7B <= b0[7] - b1[7];
			mult8A <= 32'h404f4672; 
			mult8B <= b3[0] - b2[0]; 
			mult9A <= 32'h42e13c10; 
			mult9B <= b3[1] - b2[1];
			mult10A <= 32'h48919f44; 
			mult10B <= b3[2] - b2[2]; 
			mult11A <= 32'h52cb0e63; 
			mult11B <= b3[3] - b2[3];
			mult12A <= 32'h64e2402e; 
			mult12B <= b3[4] - b2[4];
			mult13A <= 32'h43e224a9; 
			mult13B <= b3[5] - b2[5];
			mult14A <= 32'h6e3c92c1; 
			mult14B <= b3[6] - b2[6];
			mult15A <= 32'h519e4e04; 
			mult15B <= b3[7] - b2[7]; 
			// MI_BUF[15] <= ( 32'h404f4672 * ( b0[0] - b1[0] ) ) >> 31;
			// MI_BUF[14] <= ( 32'h42e13c10 * ( b0[1] - b1[1] ) ) >> 31;
			// MI_BUF[13] <= ( 32'h48919f44 * ( b0[2] - b1[2] ) ) >> 31;
			// MI_BUF[12] <= ( 32'h52cb0e63 * ( b0[3] - b1[3] ) ) >> 31;
			// MI_BUF[11] <= ( 32'h64e2402e * ( b0[4] - b1[4] ) ) >> 31;
			// MI_BUF[10] <= ( 32'h43e224a9 * ( b0[5] - b1[5] ) ) >> 30;
			// MI_BUF[ 9] <= ( 32'h6e3c92c1 * ( b0[6] - b1[6] ) ) >> 30;
			// MI_BUF[ 8] <= ( 32'h519e4e04 * ( b0[7] - b1[7] ) ) >> 28;

			// MI_BUF[31] <= ( 32'h404f4672 * ( b3[0] - b2[0] ) ) >> 31; 
			// MI_BUF[30] <= ( 32'h42e13c10 * ( b3[1] - b2[1] ) ) >> 31; 
			// MI_BUF[29] <= ( 32'h48919f44 * ( b3[2] - b2[2] ) ) >> 31; 
			// MI_BUF[28] <= ( 32'h52cb0e63 * ( b3[3] - b2[3] ) ) >> 31; 
			// MI_BUF[27] <= ( 32'h64e2402e * ( b3[4] - b2[4] ) ) >> 31; 
			// MI_BUF[26] <= ( 32'h43e224a9 * ( b3[5] - b2[5] ) ) >> 30; 
			// MI_BUF[25] <= ( 32'h6e3c92c1 * ( b3[6] - b2[6] ) ) >> 30; 
			// MI_BUF[24] <= ( 32'h519e4e04 * ( b3[7] - b2[7] ) ) >> 28; 
			
		end // else if ( fdct32_clk_cnt == 8'd2 )

		else if ( fdct32_clk_cnt == 8'd3 ) begin

			MI_BUF[15] <= mult0_out[62:31];
			MI_BUF[14] <= mult1_out[62:31];
			MI_BUF[13] <= mult2_out[62:31];
			MI_BUF[12] <= mult3_out[62:31];
			MI_BUF[11] <= mult4_out[62:31];
			MI_BUF[10] <= mult5_out[61:30];
			MI_BUF[ 9] <= mult6_out[61:30];
			MI_BUF[ 8] <= mult7_out[59:28]; 
			MI_BUF[31] <= mult8_out[62:31]; 
			MI_BUF[30] <= mult9_out[62:31]; 
			MI_BUF[29] <= mult10_out[62:31]; 
			MI_BUF[28] <= mult11_out[62:31]; 
			MI_BUF[27] <= mult12_out[62:31]; 
			MI_BUF[26] <= mult13_out[61:30]; 
			MI_BUF[25] <= mult14_out[61:30]; 
			MI_BUF[24] <= mult15_out[59:28]; 

		end // else if ( fdct32_clk_cnt == 8'd3 )

		else if ( fdct32_clk_cnt == 8'd4 ) begin
			//b0 = a0 + a7;
			b0[0] <= MI_BUF[0] + MI_BUF[7];
			b0[1] <= MI_BUF[8] + MI_BUF[15];
			b0[2] <= MI_BUF[16] + MI_BUF[23];
			b0[3] <= MI_BUF[24] + MI_BUF[31];

			//b3 = a3 + a4;
			b3[0] <= MI_BUF[3] + MI_BUF[4];
			b3[1] <= MI_BUF[11] + MI_BUF[12];
			b3[2] <= MI_BUF[19] + MI_BUF[20];
			b3[3] <= MI_BUF[27] + MI_BUF[28];

			//b1 = a1 + a6;
			b1[0] <= MI_BUF[ 1] + MI_BUF[ 6];
			b1[1] <= MI_BUF[ 9] + MI_BUF[14];
			b1[2] <= MI_BUF[17] + MI_BUF[22];
			b1[3] <= MI_BUF[25] + MI_BUF[30];

			//b2 = a2 + a5;
			b2[0] <= MI_BUF[2] + MI_BUF[5];
			b2[1] <= MI_BUF[10] + MI_BUF[13];
			b2[2] <= MI_BUF[18] + MI_BUF[21];
			b2[3] <= MI_BUF[26] + MI_BUF[29];

			mult0A <= 32'h4140fb46;
			mult0B <= MI_BUF[ 0] - MI_BUF[ 7];
			mult1A <= 32'h4140fb46	;	
			mult1B <= MI_BUF[15] - MI_BUF[ 8];
			mult2A <= 32'h4140fb46;		
			mult2B <= MI_BUF[16] - MI_BUF[23];
			mult3A <= 32'h4140fb46;		
			mult3B <= MI_BUF[31] - MI_BUF[24];
			mult4A <= 32'h52036742;
			mult4B <= MI_BUF[ 3] - MI_BUF[ 4];
			mult5A <= 32'h52036742;
			mult5B <= MI_BUF[12] - MI_BUF[11];
			mult6A <= 32'h52036742;
			mult6B <= MI_BUF[19] - MI_BUF[20];
			mult7A <= 32'h52036742;
			mult7B <= MI_BUF[28] - MI_BUF[27];
			mult8A <= 32'h4cf8de88;
			mult8B <= MI_BUF[ 1] - MI_BUF[ 6];
			mult9A <= 32'h4cf8de88;
			mult9B <= MI_BUF[14] - MI_BUF[ 9];
			mult10A <= 32'h4cf8de88;
			mult10B <= MI_BUF[17] - MI_BUF[22];
			mult11A <= 32'h4cf8de88;
			mult11B <= MI_BUF[30] - MI_BUF[25];
			mult12A <= 32'h73326bbf;
			mult12B <= MI_BUF[ 2] - MI_BUF[ 5];
			mult13A <= 32'h73326bbf;
			mult13B <= MI_BUF[13] - MI_BUF[10];
			mult14A <= 32'h73326bbf;
			mult14B <= MI_BUF[18] - MI_BUF[21];
			mult15A <= 32'h73326bbf;
			mult15B <= MI_BUF[29] - MI_BUF[26];


			// //b7 = MULSHIFT32(*cptr++, a0 - a7) << 1;
			// b3[4] <= 32'h4140fb46 * ( MI_BUF[ 0] - MI_BUF[ 7] ) >> 31;
			// b3[5] <= 32'h4140fb46 * ( MI_BUF[15] - MI_BUF[ 8] ) >> 31;
			// b3[6] <= 32'h4140fb46 * ( MI_BUF[16] - MI_BUF[23] ) >> 31;
			// b3[7] <= 32'h4140fb46 * ( MI_BUF[31] - MI_BUF[24] ) >> 31;
			// //b4 = MULSHIFT32(*cptr++, a3 - a4) << 3;
			// b0[4] <= ( 32'h52036742 * ( MI_BUF[ 3] - MI_BUF[ 4] ) ) >> 29;
			// b0[5] <= ( 32'h52036742 * ( MI_BUF[12] - MI_BUF[11] ) ) >> 29;
			// b0[6] <= ( 32'h52036742 * ( MI_BUF[19] - MI_BUF[20] ) ) >> 29;
			// b0[7] <= ( 32'h52036742 * ( MI_BUF[28] - MI_BUF[27] ) ) >> 29;
			// //b6 = MULSHIFT32(*cptr++, a1 - a6) << 1;
			// b2[4] <= ( 32'h4cf8de88 * ( MI_BUF[ 1] - MI_BUF[ 6] ) ) >> 31;
			// b2[5] <= ( 32'h4cf8de88 * ( MI_BUF[14] - MI_BUF[ 9] ) ) >> 31;
			// b2[6] <= ( 32'h4cf8de88 * ( MI_BUF[17] - MI_BUF[22] ) ) >> 31;
			// b2[7] <= ( 32'h4cf8de88 * ( MI_BUF[30] - MI_BUF[25] ) ) >> 31;
			// //b5 = MULSHIFT32(*cptr++, a2 - a5) << 1;
			// b1[4] <= ( 32'h73326bbf * ( MI_BUF[ 2] - MI_BUF[ 5] ) ) >> 31 ;
			// b1[5] <= ( 32'h73326bbf * ( MI_BUF[13] - MI_BUF[10] ) ) >> 31 ;
			// b1[6] <= ( 32'h73326bbf * ( MI_BUF[18] - MI_BUF[21] ) ) >> 31 ;
			// b1[7] <= ( 32'h73326bbf * ( MI_BUF[29] - MI_BUF[26] ) ) >> 31 ;

		end // else if ( fdct32_clk_cnt == 8'd4 )

		else if ( fdct32_clk_cnt == 8'd5 ) begin

			b3[4] <= mult0_out[62:31];
			b3[5] <= mult1_out[62:31];
			b3[6] <= mult2_out[62:31];
			b3[7] <= mult3_out[62:31];
			b0[4] <= mult4_out[60:29];
			b0[5] <= mult5_out[60:29];
			b0[6] <= mult6_out[60:29];
			b0[7] <= mult7_out[60:29];
			b2[4] <= mult8_out[62:31];
			b2[5] <= mult9_out[62:31];
			b2[6] <= mult10_out[62:31];
			b2[7] <= mult11_out[62:31];
			b1[4] <= mult12_out[62:31];
			b1[5] <= mult13_out[62:31];
			b1[6] <= mult14_out[62:31];
			b1[7] <= mult15_out[62:31];

		end // else if ( fdct32_clk_cnt == 8'd5 )

		else if ( fdct32_clk_cnt == 8'd6 ) begin

			// a0 = b0 + b3;
			a0[0] <= b0[0] + b3[0];
			a0[1] <= b0[1] + b3[1];
			a0[2] <= b0[2] + b3[2];
			a0[3] <= b0[3] + b3[3];



			// a4 = b4 + b7;	
			a4[0] <= b0[4] + b3[4];
			a4[1] <= b0[5] + b3[5];
			a4[2] <= b0[6] + b3[6];
			a4[3] <= b0[7] + b3[7];



			// a1 = b1 + b2;
			a1[0] <= b1[0] + b2[0];
			a1[1] <= b1[1] + b2[1];
			a1[2] <= b1[2] + b2[2];
			a1[3] <= b1[3] + b2[3];



			// a5 = b5 + b6;
			a5[0] <= b1[4] + b2[4];
			a5[1] <= b1[5] + b2[5];
			a5[2] <= b1[6] + b2[6];
			a5[3] <= b1[7] + b2[7];


			mult0A <= 32'h4545e9ef;
			mult0B <= b0[0] - b3[0];
			mult1A <= 32'h4545e9ef;
			mult1B <= b0[1] - b3[1];
			mult2A <= 32'h4545e9ef;
			mult2B <= b0[2] - b3[2];
			mult3A <= 32'h4545e9ef;
			mult3B <= b0[3] - b3[3];
			mult4A <= 32'h4545e9ef;
			mult4B <= b3[4] - b0[4];
			mult5A <= 32'h4545e9ef;
			mult5B <= b3[5] - b0[5];
			mult6A <= 32'h4545e9ef;
			mult6B <= b3[6] - b0[6];
			mult7A <= 32'h4545e9ef;
			mult7B <= b3[7] - b0[7];
			mult8A <= 32'h539eba45;
			mult8B <= b1[0] - b2[0];
			mult9A <= 32'h539eba45;
			mult9B <= b1[1] - b2[1];
			mult10A <= 32'h539eba45;
			mult10B <= b1[2] - b2[2];
			mult11A <= 32'h539eba45;
			mult11B <= b1[3] - b2[3];
			mult12A <= 32'h539eba45;
			mult12B <= b2[4] - b1[4];
			mult13A <= 32'h539eba45;
			mult13B <= b2[5] - b1[5];
			mult14A <= 32'h539eba45;
			mult14B <= b2[6] - b1[6];
			mult15A <= 32'h539eba45;
			mult15B <= b2[7] - b1[7];

			// //a3 = MULSHIFT32(*cptr,   b0 - b3) << 1;
			// a3[0] <= ( 32'h4545e9ef * ( b0[0] - b3[0] ) ) >> 31;
			// a3[1] <= ( 32'h4545e9ef * ( b0[1] - b3[1] ) ) >> 31;
			// a3[2] <= ( 32'h4545e9ef * ( b0[2] - b3[2] ) ) >> 31;
			// a3[3] <= ( 32'h4545e9ef * ( b0[3] - b3[3] ) ) >> 31;
			// // a7 = MULSHIFT32(*cptr++, b7 - b4) << 1;
			// a7[0] <= ( 32'h4545e9ef * ( b3[4] - b0[4] ) ) >> 31;
			// a7[1] <= ( 32'h4545e9ef * ( b3[5] - b0[5] ) ) >> 31;
			// a7[2] <= ( 32'h4545e9ef * ( b3[6] - b0[6] ) ) >> 31;
			// a7[3] <= ( 32'h4545e9ef * ( b3[7] - b0[7] ) ) >> 31;
			// // a2 = MULSHIFT32(*cptr,   b1 - b2) << 2;
			// a2[0] <= ( 32'h539eba45 * ( b1[0] - b2[0] ) ) >> 30;
			// a2[1] <= ( 32'h539eba45 * ( b1[1] - b2[1] ) ) >> 30;
			// a2[2] <= ( 32'h539eba45 * ( b1[2] - b2[2] ) ) >> 30;
			// a2[3] <= ( 32'h539eba45 * ( b1[3] - b2[3] ) ) >> 30;
			// // a6 = MULSHIFT32(*cptr++, b6 - b5) << 2;
			// a6[0] <= ( 32'h539eba45 * ( b2[4] - b1[4] ) ) >> 30;
			// a6[1] <= ( 32'h539eba45 * ( b2[5] - b1[5] ) ) >> 30;
			// a6[2] <= ( 32'h539eba45 * ( b2[6] - b1[6] ) ) >> 30;
			// a6[3] <= ( 32'h539eba45 * ( b2[7] - b1[7] ) ) >> 30;

		end // else if ( fdct32_clk_cnt == 8'd6 )

		else if ( fdct32_clk_cnt == 8'd7 ) begin
			a3[0] <= mult0_out[62:31];
			a3[1] <= mult1_out[62:31];
			a3[2] <= mult2_out[62:31];
			a3[3] <= mult3_out[62:31];
			a7[0] <= mult4_out[62:31];
			a7[1] <= mult5_out[62:31];
			a7[2] <= mult6_out[62:31];
			a7[3] <= mult7_out[62:31];
			a2[0] <= mult8_out[61:30];
			a2[1] <= mult9_out[61:30];
			a2[2] <= mult10_out[61:30];
			a2[3] <= mult11_out[61:30];
			a6[0] <= mult12_out[61:30];
			a6[1] <= mult13_out[61:30];
			a6[2] <= mult14_out[61:30];
			a6[3] <= mult15_out[61:30];
		end // else if ( fdct32_clk_cnt == 8'd7 )

		else if ( fdct32_clk_cnt == 8'd8 ) begin
			// b0 = a0 + a1;
			b0[0] <= a0[0] + a1[0];
			b0[1] <= a0[1] + a1[1];
			b0[2] <= a0[2] + a1[2];
			b0[3] <= a0[3] + a1[3];

			// b2 = a2 + a3;
			b2[0] <= a2[0] + a3[0];
			b2[1] <= a2[1] + a3[1];
			b2[2] <= a2[2] + a3[2];
			b2[3] <= a2[3] + a3[3];

			// b4 = a4 + a5;
			b0[4] <= a4[0] + a5[0];
			b0[5] <= a4[1] + a5[1];
			b0[6] <= a4[2] + a5[2];
			b0[7] <= a4[3] + a5[3];

			// b6 = a6 + a7;
			b2[4] <= a6[0] + a7[0];
			b2[5] <= a6[1] + a7[1];
			b2[6] <= a6[2] + a7[2];
			b2[7] <= a6[3] + a7[3];

			mult0A <= 32'h5a82799a;
			mult0B <= a0[0] - a1[0];
			mult1A <= 32'h5a82799a;
			mult1B <= a0[1] - a1[1];
			mult2A <= 32'h5a82799a;
			mult2B <= a0[2] - a1[2];
			mult3A <= 32'h5a82799a;
			mult3B <= a0[3] - a1[3];
			mult4A <= 32'h5a82799a;
			mult4B <= a3[0] - a2[0];
			mult5A <= 32'h5a82799a;
			mult5B <= a3[1] - a2[1];
			mult6A <= 32'h5a82799a;
			mult6B <= a3[2] - a2[2];
			mult7A <= 32'h5a82799a;
			mult7B <= a3[3] - a2[3];
			mult8A <= 32'h5a82799a;
			mult8B <= a4[0] - a5[0];
			mult9A <= 32'h5a82799a;
			mult9B <= a4[1] - a5[1];
			mult10A <= 32'h5a82799a;
			mult10B <= a4[2] - a5[2];
			mult11A <= 32'h5a82799a;
			mult11B <= a4[3] - a5[3];
			mult12A <= 32'h5a82799a;
			mult12B <= a7[0] - a6[0];
			mult13A <= 32'h5a82799a;
			mult13B <= a7[1] - a6[1];
			mult14A <= 32'h5a82799a;
			mult14B <= a7[2] - a6[2];
			mult15A <= 32'h5a82799a;
			mult15B <= a7[3] - a6[3];

			// // b1 = MULSHIFT32(COS4_0, a0 - a1) << 1;
			// b1[0] <= ( 32'h5a82799a * ( a0[0] - a1[0] ) ) >> 31;
			// b1[1] <= ( 32'h5a82799a * ( a0[1] - a1[1] ) ) >> 31;
			// b1[2] <= ( 32'h5a82799a * ( a0[2] - a1[2] ) ) >> 31;
			// b1[3] <= ( 32'h5a82799a * ( a0[3] - a1[3] ) ) >> 31;
			// // b3 = MULSHIFT32(COS4_0, a3 - a2) << 1;
			// b3[0] <= ( 32'h5a82799a * ( a3[0] - a2[0] ) ) >> 31;
			// b3[1] <= ( 32'h5a82799a * ( a3[1] - a2[1] ) ) >> 31;
			// b3[2] <= ( 32'h5a82799a * ( a3[2] - a2[2] ) ) >> 31;
			// b3[3] <= ( 32'h5a82799a * ( a3[3] - a2[3] ) ) >> 31;
			// // b5 = MULSHIFT32(COS4_0, a4 - a5) << 1;
			// b1[4] <= ( 32'h5a82799a * ( a4[0] - a5[0] ) ) >> 31;
			// b1[5] <= ( 32'h5a82799a * ( a4[1] - a5[1] ) ) >> 31;
			// b1[6] <= ( 32'h5a82799a * ( a4[2] - a5[2] ) ) >> 31;
			// b1[7] <= ( 32'h5a82799a * ( a4[3] - a5[3] ) ) >> 31;
			// // b7 = MULSHIFT32(COS4_0, a7 - a6) << 1;
			// b3[4] <= ( 32'h5a82799a * ( a7[0] - a6[0] ) ) >> 31;
			// b3[5] <= ( 32'h5a82799a * ( a7[1] - a6[1] ) ) >> 31;
			// b3[6] <= ( 32'h5a82799a * ( a7[2] - a6[2] ) ) >> 31;
			// b3[7] <= ( 32'h5a82799a * ( a7[3] - a6[3] ) ) >> 31;

		end // else if ( fdct32_clk_cnt == 8'd8 )

		else if ( fdct32_clk_cnt == 8'd9 ) begin
			b1[0] <= mult0_out[62:31];
			b1[1] <= mult1_out[62:31];
			b1[2] <= mult2_out[62:31];
			b1[3] <= mult3_out[62:31];
			b3[0] <= mult4_out[62:31];
			b3[1] <= mult5_out[62:31];
			b3[2] <= mult6_out[62:31];
			b3[3] <= mult7_out[62:31];
			b1[4] <= mult8_out[62:31];
			b1[5] <= mult9_out[62:31];
			b1[6] <= mult10_out[62:31];
			b1[7] <= mult11_out[62:31];
			b3[4] <= mult12_out[62:31];
			b3[5] <= mult13_out[62:31];
			b3[6] <= mult14_out[62:31];
			b3[7] <= mult15_out[62:31];
		end // else if ( fdct32_clk_cnt == 8'd9 )

		else if ( fdct32_clk_cnt == 8'd10 ) begin
			// buf[0] = b0;	    
			MI_BUF[0] <= b0[0];
			MI_BUF[8] <= b0[1];
			MI_BUF[16] <= b0[2];
			MI_BUF[24] <= b0[3];

			// buf[1] = b1;
			MI_BUF[ 1] <= b1[0];
			MI_BUF[ 9] <= b1[1];
			MI_BUF[17] <= b1[2];
			MI_BUF[25] <= b1[3];

			// buf[2] = b2 + b3;
			MI_BUF[ 2] <= b2[0] + b3[0];
			MI_BUF[10] <= b2[1] + b3[1];
			MI_BUF[18] <= b2[2] + b3[2];
			MI_BUF[26] <= b2[3] + b3[3];

			// buf[3] = b3;
			MI_BUF[ 3] <= b3[0];
			MI_BUF[11] <= b3[1];
			MI_BUF[19] <= b3[2];
			MI_BUF[27] <= b3[3];

			// buf[4] = b4 + b6 + b7;
			MI_BUF[ 4] <= b0[4] + b2[4] + b3[4];
			MI_BUF[12] <= b0[5] + b2[5] + b3[5];
			MI_BUF[20] <= b0[6] + b2[6] + b3[6];
			MI_BUF[28] <= b0[7] + b2[7] + b3[7];

			// buf[5] = b5 + b7;
			MI_BUF[ 5] <= b1[4] + b3[4];
			MI_BUF[13] <= b1[5] + b3[5];
			MI_BUF[21] <= b1[6] + b3[6];
			MI_BUF[29] <= b1[7] + b3[7];

			// buf[6] = b5 + b6 + b7;
			MI_BUF[ 6] <= b1[4] + b2[4] + b3[4];
			MI_BUF[14] <= b1[5] + b2[5] + b3[5];
			MI_BUF[22] <= b1[6] + b2[6] + b3[6];
			MI_BUF[30] <= b1[7] + b2[7] + b3[7];

			// buf[7] = b7;
			MI_BUF[ 7] <= b3[4];
			MI_BUF[15] <= b3[5];
			MI_BUF[23] <= b3[6];
			MI_BUF[31] <= b3[7];
		end // else if ( fdct32_clk_cnt == 8'd10 )




		else if ( fdct32_clk_cnt == 8'd11 ) begin
			/* sample 0 - always delayed one block */

			Ram_addrA <= 12'd1024 + ((offset - oddBlock) & 7) + odd_plus_n[11:0];
			Ram_addrB <= 12'd1024 + ((offset - oddBlock) & 7) + odd_plus_n[11:0];
			Ram_data <= MI_BUF[ 0];

		end // else if ( fdct32_clk_cnt == 8'd11 )

		else if ( fdct32_clk_cnt == 8'd12 ) begin
		

		/* samples 16 to 31 */

			Ram_addrA <= offset + odd_plus[11:0];
			Ram_addrB <= 12'd8 + offset + odd_plus[11:0];
			Ram_data <= MI_BUF[ 1];	
		end // else if ( fdct32_clk_cnt == 8'd12 )

		else if ( fdct32_clk_cnt == 8'd13 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd64;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd72;
			Ram_data <= MI_BUF[17] + MI_BUF[25] + MI_BUF[29];

		end // else if ( fdct32_clk_cnt == 8'd13 )

		else if ( fdct32_clk_cnt == 8'd14 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd128;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd136;
			Ram_data <= MI_BUF[ 9] + MI_BUF[13];
		
		end // else if ( fdct32_clk_cnt == 8'd14 )

		else if ( fdct32_clk_cnt == 8'd15 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd192;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd200;
			Ram_data <= MI_BUF[21] + MI_BUF[25] + MI_BUF[29];
		end // else if ( fdct32_clk_cnt == 8'd15 )

		else if ( fdct32_clk_cnt == 8'd16 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd256;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd264;
			Ram_data <= MI_BUF[ 5];

		end // else if ( fdct32_clk_cnt == 8'd16 )

		else if ( fdct32_clk_cnt == 8'd17 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd320;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd328;
			Ram_data <= MI_BUF[21] + MI_BUF[29] + MI_BUF[27];
		end // else if ( fdct32_clk_cnt == 8'd17 )

		else if ( fdct32_clk_cnt == 8'd18 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd384;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd392; 
			Ram_data <= MI_BUF[13] + MI_BUF[11];
		end // else if ( fdct32_clk_cnt == 8'd18 )

		else if ( fdct32_clk_cnt == 8'd19 ) begin		
			Ram_addrA <= offset + odd_plus[11:0] + 12'd448;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd456;
			Ram_data <= MI_BUF[19] + MI_BUF[29] + MI_BUF[27];	

		end // else if ( fdct32_clk_cnt == 8'd19 )

		else if ( fdct32_clk_cnt == 8'd20 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd512;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd520;
			Ram_data <= MI_BUF[ 3];		
		end // else if ( fdct32_clk_cnt == 8'd20 )

		else if ( fdct32_clk_cnt == 8'd21 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd576;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd584;
			Ram_data <= MI_BUF[19] + MI_BUF[27] + MI_BUF[31];	
		end // else if ( fdct32_clk_cnt == 8'd21 )

		else if ( fdct32_clk_cnt == 8'd22 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd640;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd648;
			Ram_data <= MI_BUF[11] + MI_BUF[15];	

		end // else if ( fdct32_clk_cnt == 8'd22 )

		else if ( fdct32_clk_cnt == 8'd23 ) begin

			Ram_addrA <= offset + odd_plus[11:0] + 12'd704;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd712;
			Ram_data <= MI_BUF[23] + MI_BUF[27] + MI_BUF[31];	
		end // else if ( fdct32_clk_cnt == 8'd23 )

		else if ( fdct32_clk_cnt == 8'd24 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd768;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd776;
			Ram_data <= MI_BUF[ 7];	

		end // else if ( fdct32_clk_cnt == 8'd24 )

		else if ( fdct32_clk_cnt == 8'd25 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd832;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd840; 
			Ram_data <= MI_BUF[23] + MI_BUF[31];	
		end // else if ( fdct32_clk_cnt == 8'd25 )

		else if ( fdct32_clk_cnt == 8'd26 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd896;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd904;
			Ram_data <= MI_BUF[15];	
		end // else if ( fdct32_clk_cnt == 8'd26 )

		else if ( fdct32_clk_cnt == 8'd27 ) begin
			Ram_addrA <= offset + odd_plus[11:0] + 12'd960;
			Ram_addrB <= offset + odd_plus[11:0] + 12'd968;
			Ram_data <= MI_BUF[31];

		end // else if ( fdct32_clk_cnt == 8'd27 )
				

		/* samples 16 to 1 (sample 16 used again) */
			
		else if ( fdct32_clk_cnt == 8'd28 ) begin
			Ram_addrA <= 12'd16 + ((offset - oddBlock) & 7) + odd_plus_n[11:0];
			Ram_addrB <= 12'd24 + ((offset - oddBlock) & 7) + odd_plus_n[11:0];
			Ram_data <= MI_BUF[ 1];	

		end // else if ( fdct32_clk_cnt == 8'd28 )			

		else if ( fdct32_clk_cnt == 8'd29 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd80;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd88; 
			Ram_data <= MI_BUF[17] + MI_BUF[30] + MI_BUF[25];	
		end

		else if ( fdct32_clk_cnt == 8'd30 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd144;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd152;
			Ram_data <= MI_BUF[14] + MI_BUF[ 9];	
		end // else if ( fdct32_clk_cnt == 8'd30 )

		else if ( fdct32_clk_cnt == 8'd31 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd208;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd216;
			Ram_data <= MI_BUF[22] + MI_BUF[30] + MI_BUF[25];	

		end // else if ( fdct32_clk_cnt == 8'd31 )

		else if ( fdct32_clk_cnt == 8'd32 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd272;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd280; 
			Ram_data <= MI_BUF[ 6];

		end // else if ( fdct32_clk_cnt == 8'd32 )
			
		else if ( fdct32_clk_cnt == 8'd33 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd336;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd344; 
			Ram_data <= MI_BUF[22] + MI_BUF[26] + MI_BUF[30];	
		end // else if ( fdct32_clk_cnt == 8'd33 )
				
		else if ( fdct32_clk_cnt == 8'd34 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd400;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd408;
			Ram_data <= MI_BUF[10] + MI_BUF[14];	

		end // else if ( fdct32_clk_cnt == 8'd34 )
			
		else if ( fdct32_clk_cnt == 8'd35 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd464;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd472; 
			Ram_data <= MI_BUF[18] + MI_BUF[26] + MI_BUF[30];	

		end // else if ( fdct32_clk_cnt == 8'd35 )
		
		else if ( fdct32_clk_cnt == 8'd36 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd528; 
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd536; 
			Ram_data <= MI_BUF[ 2];
		end // else if ( fdct32_clk_cnt == 8'd36 )
			
		else if ( fdct32_clk_cnt == 8'd37 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd592;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd600;
			Ram_data <= MI_BUF[18] + MI_BUF[28] + MI_BUF[26];	
		end // else if ( fdct32_clk_cnt == 8'd37 )

		else if ( fdct32_clk_cnt == 8'd38 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd656;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd664;
			Ram_data <= MI_BUF[12] + MI_BUF[10];	
		end // else if ( fdct32_clk_cnt == 8'd38 )

		else if ( fdct32_clk_cnt == 8'd39 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd720;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd728;
			Ram_data <= MI_BUF[20] + MI_BUF[28] + MI_BUF[26];	
		end // else if ( fdct32_clk_cnt == 8'd39 )

		else if ( fdct32_clk_cnt == 8'd40 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd784;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd792;
			Ram_data <= MI_BUF[ 4];	
		end // else if ( fdct32_clk_cnt == 8'd40 )

		else if ( fdct32_clk_cnt == 8'd41 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd848;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd856;
			Ram_data <= MI_BUF[20] + MI_BUF[24] + MI_BUF[28];	
		end // else if ( fdct32_clk_cnt == 8'd41 )

		else if ( fdct32_clk_cnt == 8'd42 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd912;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd920;
			Ram_data <= MI_BUF[ 8] + MI_BUF[12];		

		end // else if ( fdct32_clk_cnt == 8'd42 )

		else if ( fdct32_clk_cnt == 8'd43 ) begin
			Ram_addrA <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd976;
			Ram_addrB <= ((offset - oddBlock) & 7) + odd_plus_n[11:0] + 12'd984;
			Ram_data <= MI_BUF[16] + MI_BUF[24] + MI_BUF[28];
		end // else if ( fdct32_clk_cnt == 8'd43 )



		else if ( fdct32_clk_cnt == 8'd50 ) begin
		end // else if ( fdct32_clk_cnt == 8'd50 )


	    else if ( fdct32_clk_cnt == 8'd100 )begin
	    	fdct32_clk_cnt <= 8'd0;
	    end

		
		else begin
		   
		end // else
	end // else if ( subband_state == ST_FDCT )

	else begin
	end // else ( subband_state == other )


end // else end







endmodule