`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/08/01 11:18:36
// Design Name: 
// Module Name: subband
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



module subband (
	input CLK,    // Clock flexbus 40MHZ 
	input RST_n,  // Asynchronous reset active low

	input gb0
	
);

input [31:0] gb;
input [31:0] offset;
input [31:0] oddBlock;

reg [31:0] buf1[0:31];
reg [31:0] buf2[0:31];


reg [7:0] subband_clk_cnt = 8'd0;
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
always@(posedge CLK or RST_n)
if ( !RST_n ) begin
	subband_clk_cnt <= 8'd0;
end
else begin
	subband_clk_cnt <= subband_clk_cnt + 1'd1;

	if ( subband_clk_cnt == 8'd0 ) begin
		b0[0] <= buf1[0] + buf1[31];
		b0[1] <= buf1[1] + buf1[30];
		b0[2] <= buf1[2] + buf1[29];
		b0[3] <= buf1[3] + buf1[28];
		b0[4] <= buf1[4] + buf1[27];
		b0[5] <= buf1[5] + buf1[26];
		b0[6] <= buf1[6] + buf1[25];
		b0[7] <= buf1[7] + buf1[24];

		b1[0] <= buf1[15] + buf1[16];
		b1[1] <= buf1[14] + buf1[17];
		b1[2] <= buf1[13] + buf1[18];
		b1[3] <= buf1[12] + buf1[19];
		b1[4] <= buf1[11] + buf1[20];
		b1[5] <= buf1[10] + buf1[21];
		b1[6] <= buf1[ 9] + buf1[22];
		b1[7] <= buf1[ 8] + buf1[23];

		b3[0] <= ( 32'h4013c251 * (buf1[ 0] - buf1[31]) ) >> 31; //bug:64-32 -1
		b3[1] <= ( 32'h40b345bd * (buf1[ 1] - buf1[30]) ) >> 31;
		b3[2] <= ( 32'h41fa2d6d * (buf1[ 2] - buf1[29]) ) >> 31;
		b3[3] <= ( 32'h43f93421 * (buf1[ 3] - buf1[28]) ) >> 31;
		b3[4] <= ( 32'h46cc1bc4 * (buf1[ 4] - buf1[27]) ) >> 31;
		b3[5] <= ( 32'h4a9d9cf0 * (buf1[ 5] - buf1[26]) ) >> 31;
		b3[6] <= ( 32'h4fae3711 * (buf1[ 6] - buf1[25]) ) >> 31;
		b3[7] <= ( 32'h56601ea7 * (buf1[ 7] - buf1[24]) ) >> 31;

		b2[0] <= ( 32'h518522fb * (buf1[15] - buf1[16]) ) >> 27;//bug:64-32 -5
		b2[0] <= ( 32'h6d0b20cf * (buf1[14] - buf1[17]) ) >> 29;
		b2[0] <= ( 32'h41d95790 * (buf1[13] - buf1[18]) ) >> 29;
		b2[0] <= ( 32'h5efc8d96 * (buf1[12] - buf1[19]) ) >> 30;
		b2[0] <= ( 32'h4ad81a97 * (buf1[11] - buf1[20]) ) >> 30;
		b2[0] <= ( 32'h7c7d1db3 * (buf1[10] - buf1[21]) ) >> 31;
		b2[0] <= ( 32'h6b6fcf26 * (buf1[ 9] - buf1[22]) ) >> 31;
		b2[0] <= ( 32'h5f4cf6eb * (buf1[ 8] - buf1[23]) ) >> 31;
		
	end // if ( subband_clk_cnt == 8'd0 )

	else if ( subband_clk_cnt == 8'd1 ) begin
		buf1[0] <= b0[0] + b1[0];
		buf1[1] <= b0[1] + b1[1];
		buf1[2] <= b0[2] + b1[2];
		buf1[3] <= b0[3] + b1[3];
		buf1[4] <= b0[4] + b1[4];
		buf1[5] <= b0[5] + b1[5];
		buf1[6] <= b0[6] + b1[6];
		buf1[7] <= b0[7] + b1[7];

		buf1[15] <= ( 32'h404f4672 * ( b0[0] - b1[0] ) ) >> 31;
		buf1[14] <= ( 32'h42e13c10 * ( b0[1] - b1[1] ) ) >> 31;
		buf1[13] <= ( 32'h48919f44 * ( b0[2] - b1[2] ) ) >> 31;
		buf1[12] <= ( 32'h52cb0e63 * ( b0[3] - b1[3] ) ) >> 31;
		buf1[11] <= ( 32'h64e2402e * ( b0[4] - b1[4] ) ) >> 31;
		buf1[10] <= ( 32'h43e224a9 * ( b0[5] - b1[5] ) ) >> 30;
		buf1[ 9] <= ( 32'h6e3c92c1 * ( b0[6] - b1[6] ) ) >> 30;
		buf1[ 8] <= ( 32'h519e4e04 * ( b0[7] - b1[7] ) ) >> 28;

		buf1[16] = b2[0] + b3[0];
		buf1[17] = b2[1] + b3[1];
		buf1[18] = b2[2] + b3[2];
		buf1[19] = b2[3] + b3[3];
		buf1[20] = b2[4] + b3[4];
		buf1[21] = b2[5] + b3[5];
		buf1[22] = b2[6] + b3[6];
		buf1[23] = b2[7] + b3[7];

		buf1[31] = ( 32'h404f4672 * ( b3[0] - b2[0] ) ) >> 31; 
		buf1[30] = ( 32'h42e13c10 * ( b3[1] - b2[1] ) ) >> 31; 
		buf1[29] = ( 32'h48919f44 * ( b3[2] - b2[2] ) ) >> 31; 
		buf1[28] = ( 32'h52cb0e63 * ( b3[3] - b2[3] ) ) >> 31; 
		buf1[27] = ( 32'h64e2402e * ( b3[4] - b2[4] ) ) >> 31; 
		buf1[26] = ( 32'h43e224a9 * ( b3[5] - b2[5] ) ) >> 30; 
		buf1[25] = ( 32'h6e3c92c1 * ( b3[6] - b2[6] ) ) >> 30; 
		buf1[24] = ( 32'h519e4e04 * ( b3[7] - b2[7] ) ) >> 28; 
		
	end // else if ( subband_clk_cnt == 8'd1 )

	else if ( subband_clk_cnt == 8'd2 ) begin
		//b0 = a0 + a7;
		b0[0] <= buf1[0] + buf1[7];
		b0[1] <= buf1[8] + buf1[15];
		b0[2] <= buf1[16] + buf1[23];
		b0[3] <= buf1[24] + buf1[31];

		//b7 = MULSHIFT32(*cptr++, a0 - a7) << 1;
		b3[4] <= 32'h4140fb46 * ( buf1[ 0] - buf1[ 7] ) >> 31;
		b3[5] <= 32'h4140fb46 * ( buf1[15] - buf1[ 8] ) >> 31;
		b3[6] <= 32'h4140fb46 * ( buf1[16] - buf1[23] ) >> 31;
		b3[7] <= 32'h4140fb46 * ( buf1[31] - buf1[24] ) >> 31;

		//b3 = a3 + a4;
		b3[0] <= buf1[3] + buf1[4];
		b3[1] <= buf1[11] + buf1[12];
		b3[2] <= buf1[19] + buf1[20];
		b3[3] <= buf1[27] + buf1[28];


		//b4 = MULSHIFT32(*cptr++, a3 - a4) << 3;
		b0[4] <= ( 32'h52036742 * ( buf1[ 3] - buf1[ 4] ) ) >> 28;
		b0[5] <= ( 32'h52036742 * ( buf1[12] - buf1[11] ) ) >> 28;
		b0[6] <= ( 32'h52036742 * ( buf1[19] - buf1[20] ) ) >> 28;
		b0[7] <= ( 32'h52036742 * ( buf1[28] - buf1[27]) ) >> 28;

		//b1 = a1 + a6;
		b1[0] <= buf1[1] + buf1[6];
		b1[1] <= buf1[9] + buf1[14];
		b1[2] <= buf1[17] + buf1[22];
		b1[3] <= buf1[25] + buf1[30];

		//b6 = MULSHIFT32(*cptr++, a1 - a6) << 1;
		b2[4] <= ( 32'h4cf8de88 * ( buf1[1] - buf1[6] ) ) >> 30;
		b2[5] <= ( 32'h4cf8de88 * ( buf1[14] - buf1[9] ) ) >> 30;
		b2[6] <= ( 32'h4cf8de88 * ( buf1[17] - buf1[22] ) ) >> 30;
		b2[7] <= ( 32'h4cf8de88 * ( buf1[30] - buf1[25] ) ) >> 30;

		//b2 = a2 + a5;
		b2[0] <= buf1[2] + buf1[5];
		b2[1] <= buf1[10] + buf1[13];
		b2[2] <= buf1[18] + buf1[21];
		b2[3] <= buf1[26] + buf1[29];

		//b5 = MULSHIFT32(*cptr++, a2 - a5) << 1;
		b1[4] <= ( 32'h73326bbf * ( buf1[2] - buf1[5] ) ) >> 30 ;
		b1[5] <= ( 32'h73326bbf * ( buf1[13] - buf1[10] ) ) >> 30 ;
		b1[6] <= ( 32'h73326bbf * ( buf1[18] - buf1[21] ) ) >> 30 ;
		b1[7] <= ( 32'h73326bbf * ( buf1[29] - buf1[26] ) ) >> 30 ;

	end // else if ( subband_clk_cnt == 8'd2 )

end // else end







endmodule