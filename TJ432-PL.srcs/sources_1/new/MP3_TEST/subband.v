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
	CLK,    // Clock flexbus 40MHZ 
	RST_n,  // Asynchronous reset active low

	gb,
	offset,
	oddBlock,
	
	test_index,
	test_output,

	mult0A,
	mult0B,
	mult0_out,

	mult1A,
	mult1B,
	mult1_out,

	mult2A,
	mult2B,
	mult2_out,
		
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
	Ram_addr,
	Ram_data,
);

input CLK;
input RST_n;
input  gb;
input [31:0] offset;
input  oddBlock;

input [31:0] test_index;
output [31:0] test_output;
reg [31:0] test_output_reg;

//one cycle to wirte,2cycle to read
reg [11:0] Ram_addr;
reg [31:0] Ram_data;


assign test_output = test_output_reg;

	output reg [31:0] mult0A;
	output reg [31:0] mult0B;
	input [64:0] mult0_out;

	output reg [31:0] mult1A;
	output reg [31:0] mult1B;
	input [64:0] mult1_out;

	output reg [31:0] mult2A;
	output reg [31:0] mult2B;
	input [64:0] mult2_out;
		
	output reg [31:0] mult3A;
	output reg [31:0] mult3B;
	input [64:0] mult3_out;
		
	output reg [31:0] mult4A;
	output reg [31:0] mult4B;
	input [64:0] mult4_out;
		
	output reg [31:0] mult5A;
	output reg [31:0] mult5B;
	input [64:0] mult5_out;
		
	output reg [31:0] mult6A;
	output reg [31:0] mult6B;
	input [64:0] mult6_out;
		
	output reg [31:0] mult7A;
	output reg [31:0] mult7B;
	input [64:0] mult7_out;
		
	output reg [31:0] mult8A;
	output reg [31:0] mult8B;
	input [64:0] mult8_out;
		
	output reg [31:0] mult9A;
	output reg [31:0] mult9B;
	input [64:0] mult9_out;
		
	output reg [31:0] mult10A;
	output reg [31:0] mult10B;
	input [64:0] mult10_out;
		
	output reg [31:0] mult11A;
	output reg [31:0] mult11B;
	input [64:0] mult11_out;
		
	output reg [31:0] mult12A;
	output reg [31:0] mult12B;
	input [64:0] mult12_out;
		
	output reg [31:0] mult13A;
	output reg [31:0] mult13B;
	input [64:0] mult13_out;
		
	output reg [31:0] mult14A;
	output reg [31:0] mult14B;
	input [64:0] mult14_out;
		
	output reg [31:0] mult15A;
	output reg [31:0] mult15B;
	input [64:0] mult15_out;

//reg [31:0] polyCoef1[0:264] = {
//	/* shuffled vs. original from 0, 1, ... 15 to 0, 15, 2, 13, ... 14, 1 */
//	32'h00000000, 32'h00000074, 32'h00000354, 32'h0000072c, 32'h00001fd4, 32'h00005084, 32'h000066b8, 32'h000249c4,
//	32'h00049478, 32'hfffdb63c, 32'h000066b8, 32'hffffaf7c, 32'h00001fd4, 32'hfffff8d4, 32'h00000354, 32'hffffff8c,
//	32'hfffffffc, 32'h00000068, 32'h00000368, 32'h00000644, 32'h00001f40, 32'h00004ad0, 32'h00005d1c, 32'h00022ce0,
//	32'h000493c0, 32'hfffd9960, 32'h00006f78, 32'hffffa9cc, 32'h0000203c, 32'hfffff7e4, 32'h00000340, 32'hffffff84,
//	32'hfffffffc, 32'h00000060, 32'h00000378, 32'h0000056c, 32'h00001e80, 32'h00004524, 32'h000052a0, 32'h00020ffc,
//	32'h000491a0, 32'hfffd7ca0, 32'h00007760, 32'hffffa424, 32'h00002080, 32'hfffff6ec, 32'h00000328, 32'hffffff74,
//	32'hfffffffc, 32'h00000054, 32'h00000384, 32'h00000498, 32'h00001d94, 32'h00003f7c, 32'h00004744, 32'h0001f32c,
//	32'h00048e18, 32'hfffd6008, 32'h00007e70, 32'hffff9e8c, 32'h0000209c, 32'hfffff5ec, 32'h00000310, 32'hffffff68,
//	32'hfffffffc, 32'h0000004c, 32'h0000038c, 32'h000003d0, 32'h00001c78, 32'h000039e4, 32'h00003b00, 32'h0001d680,
//	32'h00048924, 32'hfffd43ac, 32'h000084b0, 32'hffff990c, 32'h00002094, 32'hfffff4e4, 32'h000002f8, 32'hffffff5c,
//	32'hfffffffc, 32'h00000044, 32'h00000390, 32'h00000314, 32'h00001b2c, 32'h0000345c, 32'h00002ddc, 32'h0001ba04,
//	32'h000482d0, 32'hfffd279c, 32'h00008a20, 32'hffff93a4, 32'h0000206c, 32'hfffff3d4, 32'h000002dc, 32'hffffff4c,
//	32'hfffffffc, 32'h00000040, 32'h00000390, 32'h00000264, 32'h000019b0, 32'h00002ef0, 32'h00001fd4, 32'h00019dc8,
//	32'h00047b1c, 32'hfffd0be8, 32'h00008ecc, 32'hffff8e64, 32'h00002024, 32'hfffff2c0, 32'h000002c0, 32'hffffff3c,
//	32'hfffffff8, 32'h00000038, 32'h0000038c, 32'h000001bc, 32'h000017fc, 32'h0000299c, 32'h000010e8, 32'h000181d8,
//	32'h0004720c, 32'hfffcf09c, 32'h000092b4, 32'hffff894c, 32'h00001fc0, 32'hfffff1a4, 32'h000002a4, 32'hffffff2c,
//	32'hfffffff8, 32'h00000034, 32'h00000380, 32'h00000120, 32'h00001618, 32'h00002468, 32'h00000118, 32'h00016644,
//	32'h000467a4, 32'hfffcd5cc, 32'h000095e0, 32'hffff8468, 32'h00001f44, 32'hfffff084, 32'h00000284, 32'hffffff18,
//	32'hfffffff8, 32'h0000002c, 32'h00000374, 32'h00000090, 32'h00001400, 32'h00001f58, 32'hfffff068, 32'h00014b14,
//	32'h00045bf0, 32'hfffcbb88, 32'h00009858, 32'hffff7fbc, 32'h00001ea8, 32'hffffef60, 32'h00000268, 32'hffffff04,
//	32'hfffffff8, 32'h00000028, 32'h0000035c, 32'h00000008, 32'h000011ac, 32'h00001a70, 32'hffffded8, 32'h00013058,
//	32'h00044ef8, 32'hfffca1d8, 32'h00009a1c, 32'hffff7b54, 32'h00001dfc, 32'hffffee3c, 32'h0000024c, 32'hfffffef0,
//	32'hfffffff4, 32'h00000024, 32'h00000340, 32'hffffff8c, 32'h00000f28, 32'h000015b0, 32'hffffcc70, 32'h0001161c,
//	32'h000440bc, 32'hfffc88d8, 32'h00009b3c, 32'hffff7734, 32'h00001d38, 32'hffffed18, 32'h0000022c, 32'hfffffedc,
//	32'hfffffff4, 32'h00000020, 32'h00000320, 32'hffffff1c, 32'h00000c68, 32'h0000111c, 32'hffffb92c, 32'h0000fc6c,
//	32'h00043150, 32'hfffc708c, 32'h00009bb8, 32'hffff7368, 32'h00001c64, 32'hffffebf4, 32'h00000210, 32'hfffffec4,
//	32'hfffffff0, 32'h0000001c, 32'h000002f4, 32'hfffffeb4, 32'h00000974, 32'h00000cb8, 32'hffffa518, 32'h0000e350,
//	32'h000420b4, 32'hfffc5908, 32'h00009b9c, 32'hffff6ff4, 32'h00001b7c, 32'hffffead0, 32'h000001f4, 32'hfffffeac,
//	32'hfffffff0, 32'h0000001c, 32'h000002c4, 32'hfffffe58, 32'h00000648, 32'h00000884, 32'hffff9038, 32'h0000cad0,
//	32'h00040ef8, 32'hfffc425c, 32'h00009af0, 32'hffff6ce0, 32'h00001a88, 32'hffffe9b0, 32'h000001d4, 32'hfffffe94,
//	32'hffffffec, 32'h00000018, 32'h0000028c, 32'hfffffe04, 32'h000002e4, 32'h00000480, 32'hffff7a90, 32'h0000b2fc,
//	32'h0003fc28, 32'hfffc2c90, 32'h000099b8, 32'hffff6a3c, 32'h00001988, 32'hffffe898, 32'h000001bc, 32'hfffffe7c,
//	32'h000001a0, 32'h0000187c, 32'h000097fc, 32'h0003e84c, 32'hffff6424, 32'hffffff4c, 32'h00000248, 32'hffffffec
//};
//parameter polyCoef[0] = 32'h00000000;

integer VBUF_LENGTH = 1088;

reg [31:0] buff[0:31];

//reg [31:0] vbuf[0:2176];

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

// reg [63:0] sum1L[0:16];
// reg [63:0] sum1R[0:16];
// reg [63:0] sum2L[0:14];
// reg [63:0] sum2R[0:14];

//D32FP
always@(posedge CLK or negedge RST_n)
if ( !RST_n ) begin
	subband_clk_cnt <= 8'd0;
end
else begin
	subband_clk_cnt <= subband_clk_cnt + 1'd1;

	if ( subband_clk_cnt == 8'd0 ) begin
		b0[0] <= buff[0] + buff[31];
		b0[1] <= buff[1] + buff[30];
		b0[2] <= buff[2] + buff[29];
		b0[3] <= buff[3] + buff[28];
		b0[4] <= buff[4] + buff[27];
		b0[5] <= buff[5] + buff[26];
		b0[6] <= buff[6] + buff[25];
		b0[7] <= buff[7] + buff[24];

		b1[0] <= buff[15] + buff[16];
		b1[1] <= buff[14] + buff[17];
		b1[2] <= buff[13] + buff[18];
		b1[3] <= buff[12] + buff[19];
		b1[4] <= buff[11] + buff[20];
		b1[5] <= buff[10] + buff[21];
		b1[6] <= buff[ 9] + buff[22];
		b1[7] <= buff[ 8] + buff[23];

		mult0A <= 32'h4013c251;
		mult0B <= buff[ 0] - buff[31];
		mult1A <= 32'h40b345bd;
		mult1B <= buff[ 1] - buff[30];
		mult2A <= 32'h41fa2d6d;
		mult2B <= buff[ 2] - buff[29];
		mult3A <=  32'h43f93421 ;
		mult3B <= buff[ 3] - buff[28];
		mult4A <= 32'h46cc1bc4;
		mult4B <= buff[ 4] - buff[27];
		mult5A <= 32'h4a9d9cf0;
		mult5B <= buff[ 5] - buff[26];
		mult6A <= 32'h4fae3711;
		mult6B <= buff[ 6] - buff[25];
		mult7A <= 32'h56601ea7;
		mult7B <= buff[ 7] - buff[24];

		mult8A  <= 32'h518522fb;
		mult8B  <= buff[15] - buff[16];
		mult9A  <= 32'h6d0b20cf ;
		mult9B  <= buff[14] - buff[17];
		mult10A <= 32'h41d95790;
		mult10B <= buff[13] - buff[18];
		mult11A <= 32'h5efc8d96;
		mult11B <= buff[12] - buff[19];
		mult12A <= 32'h4ad81a97;
		mult12B <= buff[11] - buff[20];
		mult13A <= 32'h7c7d1db3;
		mult13B <= buff[10] - buff[21];
		mult14A <= 32'h6b6fcf26;
		mult14B <= buff[ 9] - buff[22];
		mult15A <= 32'h5f4cf6eb;
		mult15B <= buff[ 8] - buff[23];


		// b3[0] <= ( 32'h4013c251 * (buff[ 0] - buff[31]) ) >> 31; //bug:64-32 -1
		// b3[1] <= ( 32'h40b345bd * (buff[ 1] - buff[30]) ) >> 31;
		// b3[2] <= ( 32'h41fa2d6d * (buff[ 2] - buff[29]) ) >> 31;
		// b3[3] <= ( 32'h43f93421 * (buff[ 3] - buff[28]) ) >> 31;
		// b3[4] <= ( 32'h46cc1bc4 * (buff[ 4] - buff[27]) ) >> 31;
		// b3[5] <= ( 32'h4a9d9cf0 * (buff[ 5] - buff[26]) ) >> 31;
		// b3[6] <= ( 32'h4fae3711 * (buff[ 6] - buff[25]) ) >> 31;
		// b3[7] <= ( 32'h56601ea7 * (buff[ 7] - buff[24]) ) >> 31;

		// b2[0] <= ( 32'h518522fb * (buff[15] - buff[16]) ) >> 27;//bug:64-32 -5
		// b2[0] <= ( 32'h6d0b20cf * (buff[14] - buff[17]) ) >> 29;
		// b2[0] <= ( 32'h41d95790 * (buff[13] - buff[18]) ) >> 29;
		// b2[0] <= ( 32'h5efc8d96 * (buff[12] - buff[19]) ) >> 30;
		// b2[0] <= ( 32'h4ad81a97 * (buff[11] - buff[20]) ) >> 30;
		// b2[0] <= ( 32'h7c7d1db3 * (buff[10] - buff[21]) ) >> 31;
		// b2[0] <= ( 32'h6b6fcf26 * (buff[ 9] - buff[22]) ) >> 31;
		// b2[0] <= ( 32'h5f4cf6eb * (buff[ 8] - buff[23]) ) >> 31;
		
	end // if ( subband_clk_cnt == 8'd0 )

	else if ( subband_clk_cnt == 8'd1 ) begin

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
	end // else if ( subband_clk_cnt == 8'd1 )
	else if ( subband_clk_cnt == 8'd2 ) begin

		buff[0] <= b0[0] + b1[0];
		buff[1] <= b0[1] + b1[1];
		buff[2] <= b0[2] + b1[2];
		buff[3] <= b0[3] + b1[3];
		buff[4] <= b0[4] + b1[4];
		buff[5] <= b0[5] + b1[5];
		buff[6] <= b0[6] + b1[6];
		buff[7] <= b0[7] + b1[7];



		buff[16] = b2[0] + b3[0];
		buff[17] = b2[1] + b3[1];
		buff[18] = b2[2] + b3[2];
		buff[19] = b2[3] + b3[3];
		buff[20] = b2[4] + b3[4];
		buff[21] = b2[5] + b3[5];
		buff[22] = b2[6] + b3[6];
		buff[23] = b2[7] + b3[7];

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
		// buff[15] <= ( 32'h404f4672 * ( b0[0] - b1[0] ) ) >> 31;
		// buff[14] <= ( 32'h42e13c10 * ( b0[1] - b1[1] ) ) >> 31;
		// buff[13] <= ( 32'h48919f44 * ( b0[2] - b1[2] ) ) >> 31;
		// buff[12] <= ( 32'h52cb0e63 * ( b0[3] - b1[3] ) ) >> 31;
		// buff[11] <= ( 32'h64e2402e * ( b0[4] - b1[4] ) ) >> 31;
		// buff[10] <= ( 32'h43e224a9 * ( b0[5] - b1[5] ) ) >> 30;
		// buff[ 9] <= ( 32'h6e3c92c1 * ( b0[6] - b1[6] ) ) >> 30;
		// buff[ 8] <= ( 32'h519e4e04 * ( b0[7] - b1[7] ) ) >> 28;

		// buff[31] <= ( 32'h404f4672 * ( b3[0] - b2[0] ) ) >> 31; 
		// buff[30] <= ( 32'h42e13c10 * ( b3[1] - b2[1] ) ) >> 31; 
		// buff[29] <= ( 32'h48919f44 * ( b3[2] - b2[2] ) ) >> 31; 
		// buff[28] <= ( 32'h52cb0e63 * ( b3[3] - b2[3] ) ) >> 31; 
		// buff[27] <= ( 32'h64e2402e * ( b3[4] - b2[4] ) ) >> 31; 
		// buff[26] <= ( 32'h43e224a9 * ( b3[5] - b2[5] ) ) >> 30; 
		// buff[25] <= ( 32'h6e3c92c1 * ( b3[6] - b2[6] ) ) >> 30; 
		// buff[24] <= ( 32'h519e4e04 * ( b3[7] - b2[7] ) ) >> 28; 
		
	end // else if ( subband_clk_cnt == 8'd2 )

	else if ( subband_clk_cnt == 8'd3 ) begin

		buff[15] <= mult0_out[62:31];
		buff[14] <= mult1_out[62:31];
		buff[13] <= mult2_out[62:31];
		buff[12] <= mult3_out[62:31];
		buff[11] <= mult4_out[62:31];
		buff[10] <= mult5_out[61:30];
		buff[ 9] <= mult6_out[61:30];
		buff[ 8] <= mult7_out[59:28]; 
		buff[31] <= mult8_out[62:31]; 
		buff[30] <= mult9_out[62:31]; 
		buff[29] <= mult10_out[62:31]; 
		buff[28] <= mult11_out[62:31]; 
		buff[27] <= mult12_out[62:31]; 
		buff[26] <= mult13_out[61:30]; 
		buff[25] <= mult14_out[61:30]; 
		buff[24] <= mult15_out[59:28]; 

	end // else if ( subband_clk_cnt == 8'd3 )

	else if ( subband_clk_cnt == 8'd4 ) begin
		//b0 = a0 + a7;
		b0[0] <= buff[0] + buff[7];
		b0[1] <= buff[8] + buff[15];
		b0[2] <= buff[16] + buff[23];
		b0[3] <= buff[24] + buff[31];



		//b3 = a3 + a4;
		b3[0] <= buff[3] + buff[4];
		b3[1] <= buff[11] + buff[12];
		b3[2] <= buff[19] + buff[20];
		b3[3] <= buff[27] + buff[28];



		//b1 = a1 + a6;
		b1[0] <= buff[ 1] + buff[ 6];
		b1[1] <= buff[ 9] + buff[14];
		b1[2] <= buff[17] + buff[22];
		b1[3] <= buff[25] + buff[30];


		

		//b2 = a2 + a5;
		b2[0] <= buff[2] + buff[5];
		b2[1] <= buff[10] + buff[13];
		b2[2] <= buff[18] + buff[21];
		b2[3] <= buff[26] + buff[29];


		mult0A <= 32'h4140fb46;
		mult0B <= buff[ 0] - buff[ 7];
		mult1A <= 32'h4140fb46	;	
		mult1B <= buff[15] - buff[ 8];
		mult2A <= 32'h4140fb46;		
		mult2B <= buff[16] - buff[23];
		mult3A <= 32'h4140fb46;		
		mult3B <= buff[31] - buff[24];
		mult4A <= 32'h52036742;
		mult4B <= buff[ 3] - buff[ 4];
		mult5A <= 32'h52036742;
		mult5B <= buff[12] - buff[11];
		mult6A <= 32'h52036742;
		mult6B <= buff[19] - buff[20];
		mult7A <= 32'h52036742;
		mult7B <= buff[28] - buff[27];
		mult8A <= 32'h4cf8de88;
		mult8B <= buff[ 1] - buff[ 6];
		mult9A <= 32'h4cf8de88;
		mult9B <= buff[14] - buff[ 9];
		mult10A <= 32'h4cf8de88;
		mult10B <= buff[17] - buff[22];
		mult11A <= 32'h4cf8de88;
		mult11B <= buff[30] - buff[25];
		mult12A <= 32'h73326bbf;
		mult12B <= buff[ 2] - buff[ 5];
		mult13A <= 32'h73326bbf;
		mult13B <= buff[13] - buff[10];
		mult14A <= 32'h73326bbf;
		mult14B <= buff[18] - buff[21];
		mult15A <= 32'h73326bbf;
		mult15B <= buff[29] - buff[26];


		// //b7 = MULSHIFT32(*cptr++, a0 - a7) << 1;
		// b3[4] <= 32'h4140fb46 * ( buff[ 0] - buff[ 7] ) >> 31;
		// b3[5] <= 32'h4140fb46 * ( buff[15] - buff[ 8] ) >> 31;
		// b3[6] <= 32'h4140fb46 * ( buff[16] - buff[23] ) >> 31;
		// b3[7] <= 32'h4140fb46 * ( buff[31] - buff[24] ) >> 31;
		// //b4 = MULSHIFT32(*cptr++, a3 - a4) << 3;
		// b0[4] <= ( 32'h52036742 * ( buff[ 3] - buff[ 4] ) ) >> 29;
		// b0[5] <= ( 32'h52036742 * ( buff[12] - buff[11] ) ) >> 29;
		// b0[6] <= ( 32'h52036742 * ( buff[19] - buff[20] ) ) >> 29;
		// b0[7] <= ( 32'h52036742 * ( buff[28] - buff[27] ) ) >> 29;
		// //b6 = MULSHIFT32(*cptr++, a1 - a6) << 1;
		// b2[4] <= ( 32'h4cf8de88 * ( buff[ 1] - buff[ 6] ) ) >> 31;
		// b2[5] <= ( 32'h4cf8de88 * ( buff[14] - buff[ 9] ) ) >> 31;
		// b2[6] <= ( 32'h4cf8de88 * ( buff[17] - buff[22] ) ) >> 31;
		// b2[7] <= ( 32'h4cf8de88 * ( buff[30] - buff[25] ) ) >> 31;
		// //b5 = MULSHIFT32(*cptr++, a2 - a5) << 1;
		// b1[4] <= ( 32'h73326bbf * ( buff[ 2] - buff[ 5] ) ) >> 31 ;
		// b1[5] <= ( 32'h73326bbf * ( buff[13] - buff[10] ) ) >> 31 ;
		// b1[6] <= ( 32'h73326bbf * ( buff[18] - buff[21] ) ) >> 31 ;
		// b1[7] <= ( 32'h73326bbf * ( buff[29] - buff[26] ) ) >> 31 ;

	end // else if ( subband_clk_cnt == 8'd4 )

	else if ( subband_clk_cnt == 8'd5 ) begin

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

	end // else if ( subband_clk_cnt == 8'd5 )

	else if ( subband_clk_cnt == 8'd6 ) begin

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

	end // else if ( subband_clk_cnt == 8'd6 )

	else if ( subband_clk_cnt == 8'd7 ) begin
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
	end // else if ( subband_clk_cnt == 8'd7 )

	else if ( subband_clk_cnt == 8'd8 ) begin
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

	end // else if ( subband_clk_cnt == 8'd8 )

	else if ( subband_clk_cnt == 8'd9 ) begin
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
	end // else if ( subband_clk_cnt == 8'd9 )

	else if ( subband_clk_cnt == 8'd10 ) begin
		// buf[0] = b0;	    
		buff[0] <= b0[0];
		buff[8] <= b0[1];
		buff[16] <= b0[2];
		buff[24] <= b0[3];

		// buf[1] = b1;
		buff[ 1] <= b1[0];
		buff[ 9] <= b1[1];
		buff[17] <= b1[2];
		buff[25] <= b1[3];

		// buf[2] = b2 + b3;
		buff[ 2] <= b2[0] + b3[0];
		buff[10] <= b2[1] + b3[1];
		buff[18] <= b2[2] + b3[2];
		buff[26] <= b2[3] + b3[3];

		// buf[3] = b3;
		buff[ 3] <= b3[0];
		buff[11] <= b3[1];
		buff[19] <= b3[2];
		buff[27] <= b3[3];

		// buf[4] = b4 + b6 + b7;
		buff[ 4] <= b0[4] + b2[4] + b3[4];
		buff[12] <= b0[5] + b2[5] + b3[5];
		buff[20] <= b0[6] + b2[6] + b3[6];
		buff[28] <= b0[7] + b2[7] + b3[7];

		// buf[5] = b5 + b7;
		buff[ 5] <= b1[4] + b3[4];
		buff[13] <= b1[5] + b3[5];
		buff[21] <= b1[6] + b3[6];
		buff[29] <= b1[7] + b3[7];

		// buf[6] = b5 + b6 + b7;
		buff[ 6] <= b1[4] + b2[4] + b3[4];
		buff[14] <= b1[5] + b2[5] + b3[5];
		buff[22] <= b1[6] + b2[6] + b3[6];
		buff[30] <= b1[7] + b2[7] + b3[7];

		// buf[7] = b7;
		buff[ 7] <= b3[4];
		buff[15] <= b3[5];
		buff[23] <= b3[6];
		buff[31] <= b3[7];
	end // else if ( subband_clk_cnt == 8'd10 )




	else if ( subband_clk_cnt == 8'd11 ) begin
		/* sample 0 - always delayed one block */
	vbuf[0 + 64*16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH)] 
	<= buff[ 0];
	vbuf[8 + 64*16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH)] 
	<= buff[ 0];

	/* samples 16 to 31 */

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)] 
	<= buff[ 1];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)] 
	<= buff[ 1];	

		
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64] 
	<=buff[17] + buff[25] + buff[29];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64] 
	<= buff[17] + buff[25] + buff[29];

	
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*2] 
	<= buff[ 9] + buff[13];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*2] 
	<= buff[ 9] + buff[13];
	
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*3] 
	<= buff[21] + buff[25] + buff[29];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*3] 
	<= buff[21] + buff[25] + buff[29];

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*4] 
	<= buff[ 5];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*4] 
	<= buff[ 5];
	
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*5] 
	<= buff[21] + buff[29] + buff[27];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*5] 
	<= buff[21] + buff[29] + buff[27];

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*6] 
	<= buff[13] + buff[11];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*6] 
	<= buff[13] + buff[11];
		
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*7] 
	<= buff[19] + buff[29] + buff[27];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*7] 
	<= buff[19] + buff[29] + buff[27];	
			
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*8] 
	<= buff[ 3];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*8] 
	<= buff[ 3];	
		
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*9] 
	<= buff[19] + buff[27] + buff[31];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*9] 
	<= buff[19] + buff[27] + buff[31];	

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*10] 
	<= buff[11] + buff[15];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*10] 
	<= buff[11] + buff[15];	

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*11] 
	<= buff[23] + buff[27] + buff[31];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*11] 
	<= buff[23] + buff[27] + buff[31];	

	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*12] 
	<= buff[ 7];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*12] 
	<= buff[ 7];	
	
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*13] 
	<= buff[23] + buff[31];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*13] 
	<= buff[23] + buff[31];	
		
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*14] 
	<= buff[15];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*14] 
	<= buff[15];	
			
	vbuf[0+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*15] 
	<= buff[31];
	vbuf[8+ offset + (oddBlock ? VBUF_LENGTH  : 0)+64*15] 
	<= buff[31];


	/* samples 16 to 1 (sample 16 used again) */
				
	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH)] 
	<= buff[ 1];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH)] 
	<= buff[ 1];	

	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*1] 
	<= buff[17] + buff[30] + buff[25];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*1] 
	<= buff[17] + buff[30] + buff[25];	

	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*2] 
	<= buff[14] + buff[ 9];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*2] 
	<= buff[14] + buff[ 9];	
		
	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*3] 
	<= buff[22] + buff[30] + buff[25];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*3] 
	<= buff[22] + buff[30] + buff[25];	
			
	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*4] 
	<= buff[ 6];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*4] 
	<= buff[ 6];
		
	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*5] 
	<= buff[22] + buff[26] + buff[30];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*5] 
	<= buff[22] + buff[26] + buff[30];	
	
	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*6] 
	<= buff[10] + buff[14];	
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*6] 
	<= buff[10] + buff[14];	
		
	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*7] 
	<= buff[18] + buff[26] + buff[30];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*7] 
	<= buff[18] + buff[26] + buff[30];	

	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*8] 
	<= buff[ 2];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*8] 
	<= buff[ 2];	

	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*9] 
	<= buff[18] + buff[28] + buff[26];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*9] 
	<= buff[18] + buff[28] + buff[26];	

	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*10] 
	<= buff[12] + buff[10];	
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*10] 
	<= buff[12] + buff[10];	

	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*11] 
	<= buff[20] + buff[28] + buff[26];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*11] 
	<= buff[20] + buff[28] + buff[26];	

	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*12] 
	<= buff[ 4];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*12] 
	<= buff[ 4];	

	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*13] 
	<= buff[20] + buff[24] + buff[28];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*13] 
	<= buff[20] + buff[24] + buff[28];	

	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*14] 
	<= buff[ 8] + buff[12];	
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*14] 
	<= buff[ 8] + buff[12];	

	vbuf[0+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*15] 
	<= buff[16] + buff[24] + buff[28];
	vbuf[8+ 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH) + 64*15] 
	<= buff[16] + buff[24] + buff[28];

//do not realize now
	// 	if (es) 
	// {
	// 	d = dest + 64*16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH);
	// 	s = d[0];	CLIP_2N(s, 31 - es);	d[0] = d[8] = (s << es);
	
	// 	d = dest + offset + (oddBlock ? VBUF_LENGTH  : 0);
	// 	for (i = 16; i <= 31; i++) {
	// 		s = d[0];	CLIP_2N(s, 31 - es);	d[0] = d[8] = (s << es);	d += 64;
	// 	}

	// 	d = dest + 16 + ((offset - oddBlock) & 7) + (oddBlock ? 0 : VBUF_LENGTH);
	// 	for (i = 15; i >= 0; i--) {
	// 		s = d[0];	CLIP_2N(s, 31 - es);	d[0] = d[8] = (s << es);	d += 64;
	// 	}
	// }


	end // else if ( subband_clk_cnt == 8'd11 )

	//polyphase 1
//	else if ( subband_clk_cnt == 8'd12 ) begin
//		sum1L[15] <=  vbuf[0] * polyCoef[0];
//		sum1R[15] <=  vbuf[32] * polyCoef[0];

//		sum1L[16] <= vbuf[64*16] * polyCoef[256];
//		sum1R[16] <= vbuf[64*16 + 32] * polyCoef[256];

//    genvar  i;
//    generate
    	
//    	for(i = 0; i < 15; i = i + 1) begin

//		sum1L[i] <= vbuf[64*(i+1) + 0] * polyCoef[16+(2*i)];
//		sum2L[i] <= vbuf[64*(i+1) + 0] * polyCoef[17+(2*i)];
//		sum1R[i] <=	vbuf[64*(i+1) + 32 + 0 ] * polyCoef[16+(2*i)];
//		sum2R[i] <= vbuf[64*(i+1) + 32 + 0 ] * polyCoef[17+(2*i)];
//		end
//    endgenerate

//	end // else if ( subband_clk_cnt == 8'd12 )

	else if ( subband_clk_cnt == 8'd50 ) begin
	end // else if ( subband_clk_cnt == 8'd50 )


    else if ( subband_clk_cnt == 8'd100 )begin
        test_output_reg <= vbuf[test_index];
    end

	
	else begin
	   
	end // else


end // else end







endmodule