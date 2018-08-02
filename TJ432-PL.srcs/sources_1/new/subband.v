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


reg [31:0] vbuf[0:2176];

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
		b0[4] <= ( 32'h52036742 * ( buf1[ 3] - buf1[ 4] ) ) >> 29;
		b0[5] <= ( 32'h52036742 * ( buf1[12] - buf1[11] ) ) >> 29;
		b0[6] <= ( 32'h52036742 * ( buf1[19] - buf1[20] ) ) >> 29;
		b0[7] <= ( 32'h52036742 * ( buf1[28] - buf1[27] ) ) >> 29;

		//b1 = a1 + a6;
		b1[0] <= buf1[ 1] + buf1[ 6];
		b1[1] <= buf1[ 9] + buf1[14];
		b1[2] <= buf1[17] + buf1[22];
		b1[3] <= buf1[25] + buf1[30];

		//b6 = MULSHIFT32(*cptr++, a1 - a6) << 1;
		b2[4] <= ( 32'h4cf8de88 * ( buf1[ 1] - buf1[ 6] ) ) >> 31;
		b2[5] <= ( 32'h4cf8de88 * ( buf1[14] - buf1[ 9] ) ) >> 31;
		b2[6] <= ( 32'h4cf8de88 * ( buf1[17] - buf1[22] ) ) >> 31;
		b2[7] <= ( 32'h4cf8de88 * ( buf1[30] - buf1[25] ) ) >> 31;

		//b2 = a2 + a5;
		b2[0] <= buf1[2] + buf1[5];
		b2[1] <= buf1[10] + buf1[13];
		b2[2] <= buf1[18] + buf1[21];
		b2[3] <= buf1[26] + buf1[29];

		//b5 = MULSHIFT32(*cptr++, a2 - a5) << 1;
		b1[4] <= ( 32'h73326bbf * ( buf1[ 2] - buf1[ 5] ) ) >> 31 ;
		b1[5] <= ( 32'h73326bbf * ( buf1[13] - buf1[10] ) ) >> 31 ;
		b1[6] <= ( 32'h73326bbf * ( buf1[18] - buf1[21] ) ) >> 31 ;
		b1[7] <= ( 32'h73326bbf * ( buf1[29] - buf1[26] ) ) >> 31 ;

	end // else if ( subband_clk_cnt == 8'd2 )

	else if ( subband_clk_cnt == 8'd3 ) begin
		// a0 = b0 + b3;
		a0[0] <= b0[0] + b3[0];
		a0[1] <= b0[1] + b3[1];
		a0[2] <= b0[2] + b3[2];
		a0[3] <= b0[3] + b3[3];

		//a3 = MULSHIFT32(*cptr,   b0 - b3) << 1;
		a3[0] <= ( 32'h4545e9ef * ( b0[0] - b3[0] ) ) >> 31;
		a3[1] <= ( 32'h4545e9ef * ( b0[1] - b3[1] ) ) >> 31;
		a3[2] <= ( 32'h4545e9ef * ( b0[2] - b3[2] ) ) >> 31;
		a3[3] <= ( 32'h4545e9ef * ( b0[3] - b3[3] ) ) >> 31;

		// a4 = b4 + b7;	
		a4[0] <= b0[4] + b3[4];
		a4[1] <= b0[5] + b3[5];
		a4[2] <= b0[6] + b3[6];
		a4[3] <= b0[7] + b3[7];

		// a7 = MULSHIFT32(*cptr++, b7 - b4) << 1;
		a7[0] <= ( 32'h4545e9ef * ( b3[4] - b0[4] ) ) >> 31;
		a7[1] <= ( 32'h4545e9ef * ( b3[5] - b0[5] ) ) >> 31;
		a7[2] <= ( 32'h4545e9ef * ( b3[6] - b0[6] ) ) >> 31;
		a7[3] <= ( 32'h4545e9ef * ( b3[7] - b0[7] ) ) >> 31;

		// a1 = b1 + b2;
		a1[0] <= b1[0] + b2[0];
		a1[1] <= b1[1] + b2[1];
		a1[2] <= b1[2] + b2[2];
		a1[3] <= b1[3] + b2[3];

		// a2 = MULSHIFT32(*cptr,   b1 - b2) << 2;
		a2[0] <= ( 32'h539eba45 * ( b1[0] - b2[0] ) ) >> 30;
		a2[1] <= ( 32'h539eba45 * ( b1[1] - b2[1] ) ) >> 30;
		a2[2] <= ( 32'h539eba45 * ( b1[2] - b2[2] ) ) >> 30;
		a2[3] <= ( 32'h539eba45 * ( b1[3] - b2[3] ) ) >> 30;

		// a5 = b5 + b6;
		a5[0] <= b1[4] + b2[4];
		a5[1] <= b1[5] + b2[5];
		a5[2] <= b1[6] + b2[6];
		a5[3] <= b1[7] + b2[7];

		// a6 = MULSHIFT32(*cptr++, b6 - b5) << 2;
		a6[0] <= ( 32'h539eba45 * ( b2[4] - b1[4] ) ) >> 30;
		a6[1] <= ( 32'h539eba45 * ( b2[5] - b1[5] ) ) >> 30;
		a6[2] <= ( 32'h539eba45 * ( b2[6] - b1[6] ) ) >> 30;
		a6[3] <= ( 32'h539eba45 * ( b2[7] - b1[7] ) ) >> 30;

	end // else if ( subband_clk_cnt == 8'd3 )

	else if ( subband_clk_cnt == 8'd4 ) begin
		// b0 = a0 + a1;
		b0[0] <= a0[0] + a1[0];
		b0[1] <= a0[1] + a1[1];
		b0[2] <= a0[2] + a1[2];
		b0[3] <= a0[3] + a1[3];

		// b1 = MULSHIFT32(COS4_0, a0 - a1) << 1;
		b1[0] <= ( 32'h5a82799a * ( a0[0] - a1[0] ) ) >> 31;
		b1[1] <= ( 32'h5a82799a * ( a0[1] - a1[1] ) ) >> 31;
		b1[2] <= ( 32'h5a82799a * ( a0[2] - a1[2] ) ) >> 31;
		b1[3] <= ( 32'h5a82799a * ( a0[3] - a1[3] ) ) >> 31;

		// b2 = a2 + a3;
		b2[0] <= a2[0] + a3[0];
		b2[1] <= a2[1] + a3[1];
		b2[2] <= a2[2] + a3[2];
		b2[3] <= a2[3] + a3[3];

		// b3 = MULSHIFT32(COS4_0, a3 - a2) << 1;
		b3[0] <= ( 32'h5a82799a * ( a3[0] - a2[0] ) ) >> 31;
		b3[1] <= ( 32'h5a82799a * ( a3[1] - a2[1] ) ) >> 31;
		b3[2] <= ( 32'h5a82799a * ( a3[2] - a2[2] ) ) >> 31;
		b3[3] <= ( 32'h5a82799a * ( a3[3] - a2[3] ) ) >> 31;

		// b4 = a4 + a5;
		b0[4] <= a4[0] + a5[0];
		b0[5] <= a4[1] + a5[1];
		b0[6] <= a4[2] + a5[2];
		b0[7] <= a4[3] + a5[3];

		// b5 = MULSHIFT32(COS4_0, a4 - a5) << 1;
		b1[4] <= ( 32'h5a82799a * ( a4[0] - a5[0] ) ) >> 31;
		b1[5] <= ( 32'h5a82799a * ( a4[1] - a5[1] ) ) >> 31;
		b1[6] <= ( 32'h5a82799a * ( a4[2] - a5[2] ) ) >> 31;
		b1[7] <= ( 32'h5a82799a * ( a4[3] - a5[3] ) ) >> 31;

		// b6 = a6 + a7;
		b2[4] <= a6[0] + a7[0];
		b2[5] <= a6[1] + a7[1];
		b2[6] <= a6[2] + a7[2];
		b2[7] <= a6[3] + a7[3];


		// b7 = MULSHIFT32(COS4_0, a7 - a6) << 1;
		b3[4] <= ( 32'h5a82799a * ( a7[0] - a6[0] ) ) >> 31;
		b3[5] <= ( 32'h5a82799a * ( a7[1] - a6[1] ) ) >> 31;
		b3[6] <= ( 32'h5a82799a * ( a7[2] - a6[2] ) ) >> 31;
		b3[7] <= ( 32'h5a82799a * ( a7[3] - a6[3] ) ) >> 31;

	end // else if ( subband_clk_cnt == 8'd4 )

	else if ( subband_clk_cnt == 8'd5 ) begin
		// buf[0] = b0;	    
		buf1[0] <= b0[0];
		buf1[8] <= b0[1];
		buf1[16] <= b0[2];
		buf1[24] <= b0[3];

		// buf[1] = b1;
		buf1[ 1] <= b1[0];
		buf1[ 9] <= b1[1];
		buf1[17] <= b1[2];
		buf1[25] <= b1[3];

		// buf[2] = b2 + b3;
		buf1[ 2] <= b2[0] + b3[0];
		buf1[10] <= b2[1] + b3[1];
		buf1[18] <= b2[2] + b3[2];
		buf1[26] <= b2[3] + b3[3];

		// buf[3] = b3;
		buf1[ 3] <= b3[0];
		buf1[11] <= b3[1];
		buf1[19] <= b3[2];
		buf1[27] <= b3[3];

		// buf[4] = b4 + b6 + b7;
		buf1[ 4] <= b0[4] + b2[4] + b3[4];
		buf1[12] <= b0[5] + b2[5] + b3[5];
		buf1[20] <= b0[6] + b2[6] + b3[6];
		buf1[28] <= b0[7] + b2[7] + b3[7];

		// buf[5] = b5 + b7;
		buf1[ 5] <= b1[4] + b3[4];
		buf1[13] <= b1[5] + b3[5];
		buf1[21] <= b1[6] + b3[6];
		buf1[29] <= b1[7] + b3[7];

		// buf[6] = b5 + b6 + b7;
		buf1[ 6] <= b1[4] + b2[4] + b3[4];
		buf1[14] <= b1[5] + b2[5] + b3[5];
		buf1[22] <= b1[6] + b2[6] + b3[6];
		buf1[30] <= b1[7] + b2[7] + b3[7];

		// buf[7] = b7;
		buf1[ 7] <= b3[4];
		buf1[15] <= b3[5];
		buf1[23] <= b3[6];
		buf1[31] <= b3[7];
	end // else if ( subband_clk_cnt == 8'd5 )




	else if ( subband_clk_cnt == 8'd6 ) begin
		/* sample 0 - always delayed one block */
	vbuf[0 + 64*16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH)] 
		<= vbuf[8 + 64*16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH)] 
		<= buf1[ 0];

	/* samples 16 to 31 */

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)] 
	<= buf1[ 1];	

		
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64] 
	<= buf1[17] + buf1[25] + buf1[29];

	
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64] 
	<= buf[ 9] + buf[13];
	
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64] 
	<= buf[21] + buf[25] + buf[29];

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64] 
	<= buf[ 5];
	
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64] 
	<= buf[21] + buf[29] + buf[27];

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64] 
	<= buf[13] + buf[11];
		
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64] 
	<= buf[19] + buf[29] + buf[27];	
			
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64] 
	<= buf[ 3];	
		
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64] 
	<= buf[19] + buf[27] + buf[31];	

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64] 
	<= buf[11] + buf[15];	

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64+64] 
	<= buf[23] + buf[27] + buf[31];	

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64+64+64] 
	<= buf[ 7];	
	
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64+64+64+64] 
	<= buf[23] + buf[31];	
		
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64+64+64+64+64] 
	<= buf[15];	
			
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64+64+64+64+64+64] 
	<= vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64+64+64+64+64+64+64+64+64+64+64+64+64+64+64] 
	<= buf[31];


	/* samples 16 to 1 (sample 16 used again) */
	d = dest + 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH);

	s = buf[ 1];				d[0] = d[8] = s;	d += 64;

	tmp = buf[30] + buf[25];
	s = buf[17] + tmp;			d[0] = d[8] = s;	d += 64;
	s = buf[14] + buf[ 9];		d[0] = d[8] = s;	d += 64;
	s = buf[22] + tmp;			d[0] = d[8] = s;	d += 64;
	s = buf[ 6];				d[0] = d[8] = s;	d += 64;

	tmp = buf[26] + buf[30];
	s = buf[22] + tmp;			d[0] = d[8] = s;	d += 64;
	s = buf[10] + buf[14];		d[0] = d[8] = s;	d += 64;
	s = buf[18] + tmp;			d[0] = d[8] = s;	d += 64;
	s = buf[ 2];				d[0] = d[8] = s;	d += 64;

	tmp = buf[28] + buf[26];
	s = buf[18] + tmp;			d[0] = d[8] = s;	d += 64;
	s = buf[12] + buf[10];		d[0] = d[8] = s;	d += 64;
	s = buf[20] + tmp;			d[0] = d[8] = s;	d += 64;
	s = buf[ 4];				d[0] = d[8] = s;	d += 64;

	tmp = buf[24] + buf[28];
	s = buf[20] + tmp;			d[0] = d[8] = s;	d += 64;
	s = buf[ 8] + buf[12];		d[0] = d[8] = s;	d += 64;
	s = buf[16] + tmp;			d[0] = d[8] = s;
	end // else if ( subband_clk_cnt == 8'd6 )



end // else end







endmodule