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

	inout [63:0] sum1L_pre,
	inout [31:0] mult1L_A,
	inout [31:0] mult1L_B,
	input [63:0] mult_out1L,

	inout [63:0] sum2L_pre,
	inout [31:0] mult2L_A,
	inout [31:0] mult2L_B,
	input [63:0] mult_out2L,

	inout [63:0] sum1R_pre,
	inout [31:0] mult1R_A,
	inout [31:0] mult1R_B,
	input [63:0] mult_out1R,

	inout [63:0] sum2R_pre,
	inout [31:0] mult2R_A,
	inout [31:0] mult2R_B,
	input [63:0] mult_out2R,

);

reg [63:0] sum1L_pre_reg;
reg [31:0] mult1L_A_reg;
reg [31:0] mult1L_B_reg;

reg [63:0] sum2L_pre_reg;
reg [31:0] mult2L_A_reg;
reg [31:0] mult2L_B_reg;

reg [63:0] sum1R_pre_reg;
reg [31:0] mult1R_A_reg;
reg [31:0] mult1R_B_reg;

reg [63:0] sum2R_pre_reg;
reg [31:0] mult2R_A_reg;
reg [31:0] mult2R_B_reg;


//conntion
assign sum1L_pre = ( subband_state !=  ) ? 64'bz : sum1L_pre_reg;
assign mult1L_A = ( subband_state !=  ) ? 32'bz : mult1L_A_reg;
assign mult1L_B = ( subband_state !=  ) ? 32'bz : mult1L_B_reg;

assign sum2L_pre = ( subband_state !=  ) ? 64'bz : sum2L_pre_reg;
assign mult2L_A = ( subband_state !=  ) ? 32'bz : mult2L_A_reg;
assign mult2L_B = ( subband_state !=  ) ? 32'bz : mult2L_B_reg;

assign sum1R_pre = ( subband_state !=  ) ? 64'bz : sum1R_pre_reg;
assign mult1R_A = ( subband_state !=  ) ? 32'bz : mult1R_A_reg;
assign mult1R_B = ( subband_state !=  ) ? 32'bz : mult1R_B_reg;

assign sum2R_pre = ( subband_state !=  ) ? 64'bz : sum2R_pre_reg;
assign mult2R_A = ( subband_state !=  ) ? 32'bz : mult2R_A_reg;
assign mult2R_B = ( subband_state !=  ) ? 32'bz : mult2R_B_reg;

reg [31:0] pcm[0:64];
reg [8:0] poly_cnt = 9'd0; 
reg [4:0] MC2S_cnt = 5'd15;
reg [9:0] MC2S_sub_cnt = 9'd0;

reg [63:0] sum1L_A;
reg [63:0] sum1L_B;
reg [63:0] sum2L_A;
reg [63:0] sum2L_B;

reg [63:0] sum1R_A;
reg [63:0] sum1R_B;
reg [63:0] sum2R_A;
reg [63:0] sum2R_B;

always @( posedge CLK or negedge RST_n ) begin
if ( !RST_n ) begin
	Ram_addrA <= 12'b0;
	Ram_addrB <= 12'b0;
	Rom_addrA <= 9'b0;
	Rom_addrB <= 9'b0;

	poly_cnt <= 9'd0;

	sum1L_A <= 64'd0;
	sum1L_B <= 64'd0;
	sum2L_A <= 64'd0;
	sum2L_B <= 64'd0;

	sum1R_A <= 64'd0;
	sum1R_B <= 64'd0;
	sum2R_A <= 64'd0;
	sum2R_B <= 64'd0;

	MC2S_cnt <= 5'd15;
	MC2S_sub_cnt <= 9'd0;
end

else begin
	poly_cnt <= poly_cnt + 9'd1;

	Ram_addrA <= Ram_addrA;
	Ram_addrB <= Ram_addrB;
	Rom_addrA <= Rom_addrA;
	Rom_addrB <= Rom_addrB;

	sum1L_A <= sum1L_A;
	sum1L_B <= sum1L_B;
	sum2L_A <= sum2L_A;
	sum2L_B <= sum2L_B;
	sum1R_A <= sum1R_A;
	sum1R_B <= sum1R_B;
	sum2R_A <= sum2R_A;
	sum2R_B <= sum2R_B;

	MC2S_cnt <= MC2S_cnt;
	MC2S_sub_cnt <= MC2S_sub_cnt;

	if ( poly_cnt == 9'd0 ) begin
		// sum1L <= 64'd0;
		// sum2L <= 64'd0;
		// sum1R <= 64'd0;
		// sum2R <= 64'd0;

		//vbuf
		Ram_addrA <= 12'd0;//0-7
		Ram_addrB <= 12'd32;//32-39
		//coef
		Rom_addrA <= 9'd0;//0,2,4,6,8,10,12,14

	end // if ( poly_cnt == 9'd0 )

	else if ( poly_cnt <= 9'd7 ) begin
		//vbuf
		Ram_addrA <= {4'b0,poly_cnt};//1-7
		Ram_addrB <= 12'd32 + {4'b0,poly_cnt};//33-39
		//coef
		Rom_addrA <= (poly_cnt << 1);//0,2,4,6,8,10,12,14

		sum1L_pre_reg <= mult_out1L;
		mult1L_A_reg <= Ram_dataA;
		mult1L_B_reg <= Rom_dataA;

		sum1R_pre_reg <= mult_out1R;
		mult1R_A_reg <= Ram_dataB;
		mult1R_B_reg <= Rom_dataA;

	end // else if ( poly_cnt <= 9'd7 )

	else if ( poly_cnt == 9'd8 ) begin
		//vbuf
		Ram_addrA <= 12'd23;//23
		Ram_addrB <= 12'd55;//55
		//coef
		Rom_addrA <= 9'd1;//1

		sum1L_pre_reg <= mult_out1L;
		mult1L_A_reg <= Ram_dataA;
		mult1L_B_reg <= Rom_dataA;

		sum1R_pre_reg <= mult_out1R;
		mult1R_A_reg <= Ram_dataB;
		mult1R_B_reg <= Rom_dataA;
	end // else if ( poly_cnt == 9'd8 )

	else if ( poly_cnt == 9'd9 ) begin
		//vbuf
		Ram_addrA <= 12'd22;//22
		Ram_addrB <= 12'd54;//54
		//coef
		Rom_addrA <= 9'd3;//1

	//checkout half result
		sum1L_A <= mult_out1L;
		sum1R_A <= mult_out1R;

		sum1L_pre_reg <= 64'd0;
		mult1L_A_reg <= Ram_dataA;
		mult1L_B_reg <= Rom_dataA;

		sum1R_pre_reg <= 64'd0;
		mult1R_A_reg <= Ram_dataB;
		mult1R_B_reg <= Rom_dataA;		

	end // else if ( poly_cnt == 9'd9 )

	else if ( poly_cnt <= 9'd15 ) begin
		//vbuf MC0S Final
		Ram_addrA <= 12'd31 - poly_cnt ;//21-16
		Ram_addrB <= 12'd63 - poly_cnt ;//53-48
		//coef MC0S Final
		Rom_addrA <= (poly_cnt - 9'd8) << 1;//5.7.9.11.13.15

		sum1L_pre_reg <= mult_out1L;
		mult1L_A_reg <= Ram_dataA;
		mult1L_B_reg <= Rom_dataA;

		sum1R_pre_reg <= mult_out1R;
		mult1R_A_reg <= Ram_dataB;
		mult1R_B_reg <= Rom_dataA;	

	end // else if ( poly_cnt <= 9'd15 )

	else if ( poly_cnt == 9'd16 ) begin
		//vbuf MC1S First
		Ram_addrA <= 12'd1024 ;
		Ram_addrB <= 12'd1056 ;
		//coef MC1S First
		Rom_addrA <= 9'd256;

		//MC0S Final
		sum1L_pre_reg <= mult_out1L;
		mult1L_A_reg <= Ram_dataA;
		mult1L_B_reg <= Rom_dataA;

		sum1R_pre_reg <= mult_out1R;
		mult1R_A_reg <= Ram_dataB;
		mult1R_B_reg <= Rom_dataA;	

	end // else if ( poly_cnt == 9'd16 )

	else if ( poly_cnt == 9'd17 ) begin
		//vbuf
		Ram_addrA <= 12'd1025 ;
		Ram_addrB <= 12'd1057 ;
		//coef
		Rom_addrA <= 9'd257;

		//MC1S First
		sum1L_pre_reg <= 64'd0;
		sum1R_pre_reg <= 64'd0;
		mult1L_A_reg <= Ram_dataA;
		mult1L_B_reg <= Rom_dataA;
		mult1R_A_reg <= Ram_dataB;
		mult1R_B_reg <= Rom_dataA;

		//MC0S result
		pcm[0] <= ( sum1L_A[63:32] - mult_out1L[63:32] ) >> 2;
		pcm[1] <= ( sum1R_A[63:32] - mult_out1R[63:32] ) >> 2;
	
	end // else if ( poly_cnt == 9'd17 )

	else if ( poly_cnt <= 9'd23 ) begin
		//vbuf MC1S Final
		Ram_addrA <= 12'd1008 + poly_cnt; //1026-1031
		Ram_addrB <= 12'd1040 + poly_cnt; //1058-1063
		//coef MC1S Final
		Rom_addrA <= 9'd240 + poly_cnt;//258-263

		sum1L_pre_reg <= mult_out1L;
		mult1L_A_reg <= Ram_dataA;
		mult1L_B_reg <= Rom_dataA;

		sum1R_pre_reg <= mult_out1R;
		mult1R_A_reg <= Ram_dataB;
		mult1R_B_reg <= Rom_dataA;	

	end // else if ( poly_cnt <= 9'd23 )

	else if ( poly_cnt == 9'd24 ) begin
		//vbuf clear to re-write

		//coef clear to re_write

		//MC1S Final
		sum1L_pre_reg <= mult_out1L;
		mult1L_A_reg <= Ram_dataA;
		mult1L_B_reg <= Rom_dataA;

		sum1R_pre_reg <= mult_out1R;
		mult1R_A_reg <= Ram_dataB;
		mult1R_B_reg <= Rom_dataA;	
	end // else if ( poly_cnt ==9'd24 )

	else if ( poly_cnt == 9'd25 ) begin

		sum1L_pre_reg <= 64'd0;
		sum1R_pre_reg <= 64'd0;

		pcm[32] <= mult_out1L[63:32] >> 2;
		pcm[33] <= mult_out1R[63:32] >> 2;

		MC2S_cnt <= 5'd15;
		MC2S_sub_cnt <= 9'd0;

	end // else if ( poly_cnt ==9'd25 )

	else begin	//MC2S PART
		if ( MC2S_sub_cnt == 9'd0 ) begin

			//vbuf
			Ram_addrA <= ( ( 12'd16 - MC2S_cnt ) << 6 ) + MC2S_sub_cnt;
			Ram_addrB <= ( ( 12'd16 - MC2S_cnt ) << 6 ) + 12'd32 + MC2S_sub_cnt;
			//coef
			Rom_addrA <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + MC2S_sub_cnt;
			Rom_addrA <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + 12'd1 + MC2S_sub_cnt ;

			sum1L_pre_reg <= 64'd0;
			mult1L_A_reg <= 32'd0;
			mult1L_B_reg <= 32'd0;

			sum1R_pre_reg <= 64'd0;
			mult1R_A_reg <= 32'd0;
			mult1R_B_reg <= 32'd0;

			sum2L_pre_reg <= 64'd0;
			mult2L_A_reg <= 32'd0;
			mult2L_B_reg <= 32'd0;

			sum2R_pre_reg <= 64'd0;
			mult2R_A_reg <= 32'd0;
			mult2R_B_reg <= 32'd0;

		end // if ( MC2S_sub_cnt == 9'd0 )

		else if ( MC2S_sub_cnt <= 9'd7 ) begin
			//vbuf
			Ram_addrA <= ( ( 12'd16 - MC2S_cnt ) << 6 ) + MC2S_sub_cnt;
			Ram_addrB <= ( ( 12'd16 - MC2S_cnt ) << 6 ) + 12'd32 + MC2S_sub_cnt;
			//coef
			Rom_addrA <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + MC2S_sub_cnt;
			Rom_addrB <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + 12'd1 + MC2S_sub_cnt ;

			sum1L_pre_reg <= mult_out1L;
			mult1L_A_reg <= Ram_dataA;
			mult1L_B_reg <= Rom_dataA;

			sum1R_pre_reg <= mult_out1R;
			mult1R_A_reg <= Ram_dataB;
			mult1R_B_reg <= Rom_dataA;

			sum2L_pre_reg <= mult_out2L;
			mult2L_A_reg <= Ram_dataA;
			mult2L_B_reg <= Rom_dataB;

			sum2R_pre_reg <= mult_out2R;
			mult2R_A_reg <= Ram_dataB;
			mult2R_B_reg <= Rom_dataB;

		end // else if ( MC2S_sub_cnt == 9'd7 )

		else begin

		end // else
  


	end // else

end

end


endmodule

