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
	
	//state
	
	(* DONT_TOUCH = "TRUE" *) input [2:0] subband_state,

	//CTL
	// input [3:0] vindex,
	// input b,
	
	(* DONT_TOUCH = "TRUE" *)input [11:0] vbuf_offset,

	output reg IP_Done,

	//ram operate
	(* DONT_TOUCH = "TRUE" *)inout [11:0] Ram_addrA,
	(* DONT_TOUCH = "TRUE" *)inout [11:0] Ram_addrB,
	(* DONT_TOUCH = "TRUE" *)input signed [31:0] Ram_dataA,
	(* DONT_TOUCH = "TRUE" *)input signed [31:0] Ram_dataB,

	//Rom operate
	(* DONT_TOUCH = "TRUE" *)output reg [8:0] Rom_addrA,
	(* DONT_TOUCH = "TRUE" *)output reg [8:0] Rom_addrB,
	(* DONT_TOUCH = "TRUE" *)input signed [31:0] Rom_dataA,
	(* DONT_TOUCH = "TRUE" *)input signed [31:0] Rom_dataB,	

	//FIFO pcm DATA
	(* DONT_TOUCH = "TRUE" *)output reg signed [15:0] fifo_data,
	(* DONT_TOUCH = "TRUE" *)output reg fifo_enable,

	(* DONT_TOUCH = "TRUE" *)output signed [63:0] sum1L_pre,
	(* DONT_TOUCH = "TRUE" *)output signed [31:0] mult1L_A,
	(* DONT_TOUCH = "TRUE" *)output signed [31:0] mult1L_B,
	(* DONT_TOUCH = "TRUE" *)input signed [63:0] mult_out1L,

	(* DONT_TOUCH = "TRUE" *)output signed [63:0] sum2L_pre,
	(* DONT_TOUCH = "TRUE" *)output signed [31:0] mult2L_A,
	(* DONT_TOUCH = "TRUE" *)output signed [31:0] mult2L_B,
	(* DONT_TOUCH = "TRUE" *)input signed [63:0] mult_out2L,

	(* DONT_TOUCH = "TRUE" *)output signed [63:0] sum1R_pre,
	(* DONT_TOUCH = "TRUE" *)output signed [31:0] mult1R_A,
	(* DONT_TOUCH = "TRUE" *)output signed [31:0] mult1R_B,
	(* DONT_TOUCH = "TRUE" *)input signed [63:0] mult_out1R,

	(* DONT_TOUCH = "TRUE" *)output signed [63:0] sum2R_pre,
	(* DONT_TOUCH = "TRUE" *)output signed [31:0] mult2R_A,
	(* DONT_TOUCH = "TRUE" *)output signed [31:0] mult2R_B,
	(* DONT_TOUCH = "TRUE" *)input signed [63:0] mult_out2R

	);

	parameter ST_IDLE = 3'd0;
	parameter ST_MIBUF = 3'd1;
	parameter ST_FDCT = 3'd2;
	parameter ST_FBRAM = 3'd3;
	parameter ST_PLOY = 3'd4;

	(* DONT_TOUCH = "TRUE" *)reg signed [63:0] sum1L_pre_reg;
	(* DONT_TOUCH = "TRUE" *)reg signed [31:0] mult1L_A_reg;
	(* DONT_TOUCH = "TRUE" *)reg signed [31:0] mult1L_B_reg;

	(* DONT_TOUCH = "TRUE" *)reg signed [63:0] sum2L_pre_reg;
	(* DONT_TOUCH = "TRUE" *)reg signed [31:0] mult2L_A_reg;
	(* DONT_TOUCH = "TRUE" *)reg signed [31:0] mult2L_B_reg;

	(* DONT_TOUCH = "TRUE" *)reg signed [63:0] sum1R_pre_reg;
	(* DONT_TOUCH = "TRUE" *)reg signed [31:0] mult1R_A_reg;
	(* DONT_TOUCH = "TRUE" *)reg signed [31:0] mult1R_B_reg;

	(* DONT_TOUCH = "TRUE" *)reg signed [63:0] sum2R_pre_reg;
	(* DONT_TOUCH = "TRUE" *)reg signed [31:0] mult2R_A_reg;
	(* DONT_TOUCH = "TRUE" *)reg signed [31:0] mult2R_B_reg;

//memory
reg [11:0] Ram_addrA_reg;
reg [11:0] Ram_addrB_reg;

//conntion
assign sum1L_pre =  sum1L_pre_reg;
assign mult1L_A =  mult1L_A_reg;
assign mult1L_B =  mult1L_B_reg;

assign sum2L_pre = sum2L_pre_reg;
assign mult2L_A =  mult2L_A_reg;
assign mult2L_B =  mult2L_B_reg;

assign sum1R_pre =  sum1R_pre_reg;
assign mult1R_A =  mult1R_A_reg;
assign mult1R_B =  mult1R_B_reg;

assign sum2R_pre =  sum2R_pre_reg;
assign mult2R_A =  mult2R_A_reg;
assign mult2R_B =  mult2R_B_reg;

assign Ram_addrA = ( subband_state != ST_PLOY ) ? 12'bz : Ram_addrA_reg;
assign Ram_addrB = ( subband_state != ST_PLOY ) ? 12'bz : Ram_addrB_reg;

reg signed [15:0] pcm[0:63];
(* DONT_TOUCH = "TRUE" *)reg [8:0] poly_cnt = 9'd0; 
(* DONT_TOUCH = "TRUE" *)reg [3:0] MC2S_cnt = 4'd15;
(* DONT_TOUCH = "TRUE" *)reg [8:0] MC2S_sub_cnt = 9'd0;
(* DONT_TOUCH = "TRUE" *)reg [7:0] fifo_cnt = 8'd0;

(* DONT_TOUCH = "TRUE" *)reg signed [63:0] sum1L_A;
// reg [63:0] sum1L_B;
(* DONT_TOUCH = "TRUE" *)reg signed [63:0] sum2L_A;
// reg [63:0] sum2L_B;

(* DONT_TOUCH = "TRUE" *)reg signed [63:0] sum1R_A;
// reg [63:0] sum1R_B;
(* DONT_TOUCH = "TRUE" *)reg signed [63:0] sum2R_A;
// reg [63:0] sum2R_B;

always @( negedge CLK or negedge RST_n ) begin
	if ( !RST_n ) begin
		Ram_addrA_reg <= 12'b0;
		Ram_addrB_reg <= 12'b0;
		Rom_addrA <= 9'b0;
		Rom_addrB <= 9'b0;

		poly_cnt <= 9'd0;

		sum1L_A <= 64'd0;
		sum2L_A <= 64'd0;
		sum1R_A <= 64'd0;
		sum2R_A <= 64'd0;

		MC2S_cnt <= 4'd15;
		MC2S_sub_cnt <= 9'd0;

		fifo_cnt <= 8'd0;
		fifo_data <= 16'd0;
		fifo_enable <= 1'b0;					

		IP_Done <= 1'b0;

		sum1L_pre_reg <= 64'd0;
		mult1L_A_reg <= 32'd0;
		mult1L_B_reg <= 32'd0;
		sum2L_pre_reg <= 64'd0;
		mult2L_A_reg <= 32'd0;
		mult2L_B_reg <= 32'd0;
		sum1R_pre_reg <= 64'd0;
		mult1R_A_reg <= 32'd0;
		mult1R_B_reg <= 32'd0;
		sum2R_pre_reg <= 64'd0;
		mult2R_A_reg <= 32'd0;
		mult2R_B_reg <= 32'd0;

	end

	else begin
		poly_cnt <= poly_cnt;

		Ram_addrA_reg <= Ram_addrA_reg;
		Ram_addrB_reg <= Ram_addrB_reg;
		Rom_addrA <= Rom_addrA;
		Rom_addrB <= Rom_addrB;

		sum1L_A <= sum1L_A;
		// sum1L_B <= sum1L_B;
		sum2L_A <= sum2L_A;
		// sum2L_B <= sum2L_B;
		sum1R_A <= sum1R_A;
		// sum1R_B <= sum1R_B;
		sum2R_A <= sum2R_A;
		// sum2R_B <= sum2R_B;

		MC2S_cnt <= MC2S_cnt;
		MC2S_sub_cnt <= MC2S_sub_cnt;

		fifo_cnt <= fifo_cnt;
		fifo_data <= fifo_data;
		fifo_enable <= fifo_enable;					

		IP_Done <= IP_Done;

		if ( subband_state != ST_PLOY ) begin
			//reset
			MC2S_cnt <= 4'd15;
			fifo_cnt <= 8'd0;
			poly_cnt <= 9'd0;

			fifo_data <= fifo_data;
			fifo_enable <= 1'b0;

			IP_Done <= 1'b0;

		end

		else begin
			if ( poly_cnt == 9'd0 ) begin
				poly_cnt <= poly_cnt + 9'd1;
				// sum1L <= 64'd0;
				// sum2L <= 64'd0;
				// sum1R <= 64'd0;
				// sum2R <= 64'd0;

				//vbuf
				Ram_addrA_reg <= vbuf_offset[11:0] + 12'd0;//0-7
				Ram_addrB_reg <= vbuf_offset[11:0] + 12'd32;//32-39
				//coef
				Rom_addrA <= 9'd0;//0,2,4,6,8,10,12,14

				sum1L_pre_reg <= 64'd0;
				mult1L_A_reg <= 32'd0;
				mult1L_B_reg <= 32'd0;

				sum1R_pre_reg <= 64'd0;
				mult1R_A_reg <= 32'd0;
				mult1R_B_reg <= 32'd0;


			end // if ( poly_cnt == 9'd0 )

			else if ( poly_cnt <= 9'd7 ) begin
				poly_cnt <= poly_cnt + 9'd1;
				//vbuf
				Ram_addrA_reg <= vbuf_offset[11:0] + poly_cnt;//1-7
				Ram_addrB_reg <= vbuf_offset[11:0] + 12'd32 + poly_cnt;//33-39
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
				poly_cnt <= poly_cnt + 9'd1;
				//vbuf
				Ram_addrA_reg <= vbuf_offset[11:0] + 12'd23;//23
				Ram_addrB_reg <= vbuf_offset[11:0] + 12'd55;//55
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
				poly_cnt <= poly_cnt + 9'd1;
				//vbuf
				Ram_addrA_reg <= vbuf_offset[11:0] + 12'd22;//22
				Ram_addrB_reg <= vbuf_offset[11:0] + 12'd54;//54
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
				poly_cnt <= poly_cnt + 9'd1;
				//vbuf MC0S Final
				Ram_addrA_reg <= vbuf_offset[11:0] + 12'd31 - poly_cnt ;//21-16
				Ram_addrB_reg <= vbuf_offset[11:0] + 12'd63 - poly_cnt ;//53-48
				//coef MC0S Final
				Rom_addrA <= ((poly_cnt - 9'd8) << 1) + 9'd1;//5.7.9.11.13.15

				sum1L_pre_reg <= mult_out1L;
				mult1L_A_reg <= Ram_dataA;
				mult1L_B_reg <= Rom_dataA;

				sum1R_pre_reg <= mult_out1R;
				mult1R_A_reg <= Ram_dataB;
				mult1R_B_reg <= Rom_dataA;	

			end // else if ( poly_cnt <= 9'd15 )

			else if ( poly_cnt == 9'd16 ) begin
				poly_cnt <= poly_cnt + 9'd1;
				//vbuf MC1S First
				Ram_addrA_reg <= vbuf_offset[11:0] + 12'd1024 ;
				Ram_addrB_reg <= vbuf_offset[11:0] + 12'd1056 ;
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
				poly_cnt <= poly_cnt + 9'd1;
				//vbuf
				Ram_addrA_reg <= vbuf_offset[11:0] + 12'd1025 ;
				Ram_addrB_reg <= vbuf_offset[11:0] + 12'd1057 ;
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
				pcm[0] <= ( sum1L_A[49:34] - mult_out1L[49:34] );
				pcm[1] <= ( sum1R_A[49:34] - mult_out1R[49:34] );

			end // else if ( poly_cnt == 9'd17 )

			else if ( poly_cnt <= 9'd23 ) begin
				poly_cnt <= poly_cnt + 9'd1;
				//vbuf MC1S Final
				Ram_addrA_reg <= vbuf_offset[11:0] + 12'd1008 + poly_cnt; //1026-1031
				Ram_addrB_reg <= vbuf_offset[11:0] + 12'd1040 + poly_cnt; //1058-1063
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
				poly_cnt <= poly_cnt + 9'd1;
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
				poly_cnt <= poly_cnt + 9'd1;

				sum1L_pre_reg <= 64'd0;
				sum1R_pre_reg <= 64'd0;

				pcm[32] <= mult_out1L[49:34];
				pcm[33] <= mult_out1R[49:34];

				MC2S_cnt <= 4'd15;
				MC2S_sub_cnt <= 9'd0;

			end // else if ( poly_cnt ==9'd25 )

			else begin	//MC2S PART
				poly_cnt <= poly_cnt;

			
				if ( MC2S_sub_cnt == 9'd0 ) begin
					MC2S_sub_cnt <= MC2S_sub_cnt + 9'd1;
					//vbuf
					Ram_addrA_reg <= vbuf_offset[11:0] + ( ( 12'd16 - MC2S_cnt ) << 6 ) + MC2S_sub_cnt;
					Ram_addrB_reg <= vbuf_offset[11:0] + ( ( 12'd16 - MC2S_cnt ) << 6 ) + 12'd32 + MC2S_sub_cnt;
					//coef
					Rom_addrA <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + ( MC2S_sub_cnt << 1 );
					Rom_addrA <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + 12'd1 + ( MC2S_sub_cnt << 1) ;

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
					MC2S_sub_cnt <= MC2S_sub_cnt + 9'd1;
					//vbuf Final
					Ram_addrA_reg <= vbuf_offset[11:0] + ( ( 12'd16 - MC2S_cnt ) << 6 ) + MC2S_sub_cnt;
					Ram_addrB_reg <= vbuf_offset[11:0] + ( ( 12'd16 - MC2S_cnt ) << 6 ) + 12'd32 + MC2S_sub_cnt;
					//coef Final
					Rom_addrA <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + ( MC2S_sub_cnt << 1 );
					Rom_addrB <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + ( MC2S_sub_cnt << 1 ) + 12'd1;

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

				end // else if ( MC2S_sub_cnt <= 9'd7 )

				else if ( MC2S_sub_cnt == 9'd8 ) begin
					MC2S_sub_cnt <= MC2S_sub_cnt + 9'd1;

					//vbuf First
					Ram_addrA_reg <= vbuf_offset[11:0] + ( ( 12'd16 - MC2S_cnt ) << 6 ) + 12'd31 - MC2S_sub_cnt;
					Ram_addrB_reg <= vbuf_offset[11:0] + ( ( 12'd16 - MC2S_cnt ) << 6 ) + 12'd63 - MC2S_sub_cnt;
					//coef First
					Rom_addrA <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + ( MC2S_sub_cnt - 12'd8 ) << 1;
					Rom_addrB <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + ( MC2S_sub_cnt - 12'd8 ) << 1 + 12'd1;

					//cal Final
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

				end // else if ( MC2S_sub_cnt == 9'd8 )

				else if ( MC2S_sub_cnt == 9'd9 ) begin
					MC2S_sub_cnt <= MC2S_sub_cnt + 9'd1;

					//vbuf 
					Ram_addrA_reg <= vbuf_offset[11:0] + ( ( 12'd16 - MC2S_cnt ) << 6 ) + 12'd31 - MC2S_sub_cnt;
					Ram_addrB_reg <= vbuf_offset[11:0] + ( ( 12'd16 - MC2S_cnt ) << 6 ) + 12'd63 - MC2S_sub_cnt;
					//coef 
					Rom_addrA <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + ( MC2S_sub_cnt - 12'd8 ) << 1;
					Rom_addrB <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + ( MC2S_sub_cnt - 12'd8 ) << 1 + 12'd1;

					//cal First
					sum1L_pre_reg <= 64'd0;
					mult1L_A_reg <= Ram_dataA;
					mult1L_B_reg <= Rom_dataA;

					sum1R_pre_reg <= 64'd0;
					mult1R_A_reg <= Ram_dataB;
					mult1R_B_reg <= Rom_dataA;

					sum2L_pre_reg <= 64'd0;
					mult2L_A_reg <= Ram_dataA;
					mult2L_B_reg <= Rom_dataB;

					sum2R_pre_reg <= 64'd0;
					mult2R_A_reg <= Ram_dataB;
					mult2R_B_reg <= Rom_dataB;	

					//checkout result
					sum1L_A <= mult_out1L;
					sum2L_A <= mult_out2L;
					sum1R_A <= mult_out1R;
					sum2R_A <= mult_out2R;

				end // else if ( MC2S_sub_cnt == 9'd9 )

				else if ( MC2S_sub_cnt <= 9'd15 ) begin
					MC2S_sub_cnt <= MC2S_sub_cnt + 9'd1;

					//vbuf Final
					Ram_addrA_reg <= vbuf_offset[11:0] + ( ( 12'd16 - MC2S_cnt ) << 6 ) + 12'd31 - MC2S_sub_cnt;
					Ram_addrB_reg <= vbuf_offset[11:0] + ( ( 12'd16 - MC2S_cnt ) << 6 ) + 12'd63 - MC2S_sub_cnt;
					//coef Final
					Rom_addrA <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + ( MC2S_sub_cnt - 12'd8 ) << 1;
					Rom_addrB <= ( ( 12'd16 - MC2S_cnt ) << 4 ) + ( MC2S_sub_cnt - 12'd8 ) << 1 + 12'd1;

					//cal
					sum1L_pre_reg <= mult_out1L;
					mult1L_A_reg  <= Ram_dataA;
					mult1L_B_reg  <= Rom_dataA;
					sum1R_pre_reg <= mult_out1R;
					mult1R_A_reg  <= Ram_dataB;
					mult1R_B_reg  <= Rom_dataA;
					sum2L_pre_reg <= mult_out2L;
					mult2L_A_reg  <= Ram_dataA;
					mult2L_B_reg  <= Rom_dataB;
					sum2R_pre_reg <= mult_out2R;
					mult2R_A_reg  <= Ram_dataB;
					mult2R_B_reg  <= Rom_dataB;

				end // else if ( MC2S_sub_cnt <= 9'd15 )

				else if ( MC2S_sub_cnt == 9'd16 ) begin
					MC2S_sub_cnt <= MC2S_sub_cnt + 9'd1;
					//cal Final
					sum1L_pre_reg <= mult_out1L;
					mult1L_A_reg  <= Ram_dataA;
					mult1L_B_reg  <= Rom_dataA;

					sum1R_pre_reg <= mult_out1R;
					mult1R_A_reg  <= Ram_dataB;
					mult1R_B_reg  <= Rom_dataA;

					sum2L_pre_reg <= mult_out2L;
					mult2L_A_reg  <= Ram_dataA;
					mult2L_B_reg  <= Rom_dataB;
					
					sum2R_pre_reg <= mult_out2R;
					mult2R_A_reg  <= Ram_dataB;
					mult2R_B_reg  <= Rom_dataB;

				end // else if ( MC2S_sub_cnt == 9'd16 )

				else begin //if ( MC2S_sub_cnt == 9'd17 )
				

					pcm[ ( ( 12'd16 - MC2S_cnt ) << 1 ) ] 						<= ( sum1L_A[49:34] - mult_out1L[49:34] ) ;
					pcm[ ( ( 12'd16 - MC2S_cnt ) << 1 ) + 12'd1 ] 					<= ( sum1R_A[49:34] - mult_out1R[49:34] );
					pcm[ ( ( 12'd16 - MC2S_cnt ) << 1 ) + MC2S_cnt << 2  ] 		<= ( sum2L_A[49:34] + mult_out2L[49:34] );
					pcm[ ( ( 12'd16 - MC2S_cnt ) << 1 ) + MC2S_cnt << 2 + 12'd1 ] 	<= ( sum2R_A[49:34] + mult_out2R[49:34] );

				

					if ( MC2S_cnt != 4'd1  ) begin
						MC2S_cnt <= MC2S_cnt - 4'd1;
						MC2S_sub_cnt <= 9'd0;
					end // if ( MC2S_cnt != 9'd1  )

					else begin //MC2S_cnt == 9'd1
						MC2S_sub_cnt <= MC2S_sub_cnt;
						if ( fifo_cnt <= 8'd63 ) begin
							fifo_cnt <= fifo_cnt + 8'd1;
							fifo_data <= pcm[fifo_cnt];
							fifo_enable <= 1'b1;
						end

						else begin //module complete
							//wait to reset
							MC2S_cnt <= MC2S_cnt;
							fifo_cnt <= fifo_cnt;
							poly_cnt <= poly_cnt;

							fifo_data <= fifo_data;
							fifo_enable <= 1'b0;

							IP_Done <= 1'b1;
						end // if ( fifo_cnt == 8'd63 )

					end // else
				end // else //( MC2S_sub_cnt == 9'd17 )
			end // else MC2S
		end // else //POLY
	end // else RST_N
end


endmodule

