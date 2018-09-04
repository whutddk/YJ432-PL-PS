`timescale 1ns / 1ps
`include "ann_para.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan university of technology
// Engineer: Ruige Lee
// 
// Create Date: 2018/08/29 17:05:01
// Design Name: 
// Module Name: Fann_net
// Project Name: 
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

//
//Need initialize after reset
//Load network form Rom
//

// state machine 0
// 1.initialize 	2.working

// state machine 1
// initialize count

// state machine 2
// Layer pointer

// state machine 3
// neure sum pointer



module fann_net (
	input CLK,    // Clock
	input RST_n,  // Asynchronous reset active low
	
	output reg [24:0] Activation_ROM_Addr,
	output reg [8:0] Weight_ROM_Addr,

	output reg [48 * `MAX_BANDWIDTH - 1:0] Mult_C_BUS_Reg,
	input [48 * `MAX_BANDWIDTH - 1:0] Mult_P_BUS,


	input [24:0] NEURE_INPUT0,
	input [24:0] NEURE_INPUT1,
	input [24:0] NEURE_INPUT2,
	input [24:0] NEURE_INPUT3,
	input [24:0] NEURE_INPUT4,
	input [24:0] NEURE_INPUT5,
	input [24:0] NEURE_INPUT6,
	input [24:0] NEURE_INPUT7,

	output reg [24:0] NEURE_OUTPUT0,
	output reg [24:0] NEURE_OUTPUT1,
	output reg [24:0] NEURE_OUTPUT2,
	output reg [24:0] NEURE_OUTPUT3


);

parameter INIT_STATE = 1'b0;
parameter WORK_STATE = 1'b1;

reg state_initialize = INIT_STATE;
reg [31:0] init_cnt = 32'd0;
reg [7:0] layer_cnt = 8'd0;
reg [8:0] neure_cnt = 9'd0;

integer i;


/* GET ALL Connection of a neure in one tick */
reg [18 * `MAX_BANDWIDTH - 1 : 0] Weight_Lay;


/* Q24 -16777216~16777215 */
reg [24:0] Neure_Buff_A[ 0 : `MAX_BANDWIDTH - 1 ];
reg [24:0] Neure_Buff_B[ 0 : `MAX_BANDWIDTH - 1 ];

/* Q17 -131072~131071 */

reg [8:0] LAYER_NEURE_OFFSET = 9'd0;
reg [8:0] LayerX_Neure_num;

always @( layer_cnt ) begin
	case( layer_cnt ) 
		8'd0:begin LayerX_Neure_num = `NEURE_LAY0;end
		8'd1:begin LayerX_Neure_num = `NEURE_LAY1;end
		8'd2:begin LayerX_Neure_num = `NEURE_LAY2;end
		8'd3:begin LayerX_Neure_num = `NEURE_LAY3;end
		8'd4:begin LayerX_Neure_num = `NEURE_LAY4;end
		8'd5:begin LayerX_Neure_num = `NEURE_LAY5;end
		8'd6:begin LayerX_Neure_num = `NEURE_LAY6;end
		8'd7:begin LayerX_Neure_num = `NEURE_LAY7;end
		8'd8:begin LayerX_Neure_num = `NEURE_LAY8;end
		8'd9:begin LayerX_Neure_num = `NEURE_LAY9;end
		default:begin LayerX_Neure_num = 9'd0;end
	endcase // layer_cnt
end

always @( posedge CLK or negedge RST_n ) begin
	if ( !RST_n ) begin
		state_initialize <= INIT_STATE;
		init_cnt <= 32'd0;
		layer_cnt <= 8'd0;
		neure_cnt <= 8'd0;
		LAYER_NEURE_OFFSET <= 9'd0; //assistant register
		LayerX_Neure_num <= 9'd0;

	end // if ( !RST_n )

	else begin
		if ( state_initialize == INIT_STATE ) begin

			state_initialize <= WORK_STATE;
			layer_cnt <= 8'd0;
			neure_cnt <= 8'd0;
			LAYER_NEURE_OFFSET <= 9'd0;


		end // if ( state_initialize == INIT_STATE )

		else begin //( state_initialize == WORK_STATE )

			/* Layer state machine Start */

			/****************** Input Layer*********************/
			if ( layer_cnt == 8'd0 ) begin	//input layer 

				LAYER_NEURE_OFFSET <= `NEURE_LAY0;	//NEURE OFFSET Initialization 
				layer_cnt <= layer_cnt + 7'd1;

				Neure_Buff_A[0] <= NEURE_INPUT0;
				Neure_Buff_A[1] <= NEURE_INPUT1;
				Neure_Buff_A[2] <= NEURE_INPUT2;
				Neure_Buff_A[3] <= NEURE_INPUT3;
				Neure_Buff_A[4] <= NEURE_INPUT4;
				Neure_Buff_A[5] <= NEURE_INPUT5;
				Neure_Buff_A[6] <= NEURE_INPUT6;
				Neure_Buff_A[7] <= NEURE_INPUT7;

				//For the Weight can be set as 0 at the place where no neure exist,so it make no sense to reset them. 

			end // if ( layer_cnt == 8'd0 )

			/****************** output Laye r*********************/

			else if ( layer_cnt >= `LAYER_NUM ) begin //Final Layer

				NEURE_OUTPUT0 <= Neure_Buff_A[0];
				NEURE_OUTPUT1 <= Neure_Buff_A[1];
				NEURE_OUTPUT2 <= Neure_Buff_A[2];
				NEURE_OUTPUT3 <= Neure_Buff_A[3];

				// 1 cycle is finished now , prepar for next cycle
				state_initialize <= INIT_STATE;

			end // else if ( layer_cnt == LAYER_NUM ) //Final Layer

			/****************** Hidden Layer*********************/

			else begin // Hiden Layer

				/****************** EVEN Hidden Layer*********************/
				if ( layer_cnt[0] == 1'b0 ) begin // even layer
					// last layer neure data has been put in buff A
					// this layer neure data should be put into buff B
					
					neure_cnt <= neure_cnt + 8'd1;

					begin//: DEAL_WITH_ROM_ADDRESS_B
						if ( neure_cnt <= LayerX_Neure_num ) begin
							LAYER_NEURE_OFFSET <= LAYER_NEURE_OFFSET + 9'd1;
							Activation_ROM_Addr <= Neure_Buff_B[neure_cnt];
							Weight_ROM_Addr <= LAYER_NEURE_OFFSET;
						end
					end

					begin: CALCULATE_B
						if ( neure_cnt == 8'd0 ) begin
							Mult_C_BUS_Reg <= {48 * `MAX_BANDWIDTH{1'b0}};
						end
						else begin
							Mult_C_BUS_Reg <= Mult_P_BUS; //adder sum reload 
						end
					end

					/*************** final neure in this layer ******************/
					if ( ( neure_cnt == ( `NEURE_LAY2 + 9'd1 ) ) && ( layer_cnt == 8'd2 )
						|| ( neure_cnt == ( `NEURE_LAY4 + 9'd1 ) ) && ( layer_cnt == 8'd4 )
						|| ( neure_cnt == ( `NEURE_LAY6 + 9'd1 ) ) && ( layer_cnt == 8'd6 )
						|| ( neure_cnt == ( `NEURE_LAY8 + 9'd1 ) ) && ( layer_cnt == 8'd8 )
						) begin
						
                        

							
						for ( i = 0; i < `MAX_BANDWIDTH ; i = i + 1 ) begin: LOAD_NEUREA
							
							if ( (Mult_P_BUS[ 48*i + 41 +: 7 ] == 7'b1111111) || ( Mult_P_BUS[ 48*i + 41 +: 7 ] == 7'b0 ) ) begin
								Neure_Buff_A[i] <= { Mult_P_BUS[48*i + 47] , Mult_P_BUS[48*i + 17 +: 24 ] };
							end

							else begin //overflow
								Neure_Buff_A[i] <= { Mult_P_BUS[48*i + 47] , { 24{ ~Mult_P_BUS[48*i + 47] } } };
							end // else overflow 								
						end



						neure_cnt <= 8'd0;

						layer_cnt <= layer_cnt + 7'd1;	//it 's in hidden layer ,so it unnecessary to check if is the output layer

					end



				end // if ( layer_cnt[0]  == 1'b0 ) even layer

				/****************** Odd Hidden Layer*********************/

				else begin	// odd LAYER
					/* last layer neure data has been put in buff A*/
					/* this layer neure data should be put into buff B*/
					
					neure_cnt <= neure_cnt + 8'd1;

					begin: DEAL_WITH_ROM_ADDRESS_A
						if ( neure_cnt <= LayerX_Neure_num ) begin
							LAYER_NEURE_OFFSET <= LAYER_NEURE_OFFSET + 9'd1;
							Activation_ROM_Addr <= Neure_Buff_A[neure_cnt];
							Weight_ROM_Addr <= LAYER_NEURE_OFFSET;
						end
					end

					begin: CALCULATE_A
						if ( neure_cnt == 8'd0 ) begin
							Mult_C_BUS_Reg <= {48 * `MAX_BANDWIDTH{1'b0}};
						end
						else begin
							Mult_C_BUS_Reg <= Mult_P_BUS; //adder sum reload 
						end
					end

					/*************** final neure in this layer ******************/
					if ( ( neure_cnt == ( `NEURE_LAY1 + 9'd1 ) ) && ( layer_cnt == 8'd1 )
						|| ( neure_cnt == ( `NEURE_LAY3 + 9'd1 ) ) && ( layer_cnt == 8'd3 )
						|| ( neure_cnt == ( `NEURE_LAY5 + 9'd1 ) ) && ( layer_cnt == 8'd5 )
						|| ( neure_cnt == ( `NEURE_LAY7 + 9'd1 ) ) && ( layer_cnt == 8'd7 )
						) begin


						for ( i = 0; i < `MAX_BANDWIDTH ; i = i + 1 ) begin: LOAD_NEUREB
							
							if ( (Mult_P_BUS[ 48*i + 41 +: 7 ] == 7'b1111111) || ( Mult_P_BUS[ 48*i + 41 +: 7 ] == 7'b0 ) ) begin
								Neure_Buff_B[i] <= { Mult_P_BUS[48*i + 47] , Mult_P_BUS[48*i + 17 +: 24] };
							end

							else begin //overflow
								Neure_Buff_B[i] <= { Mult_P_BUS[48*i + 47] , { 24{ ~Mult_P_BUS[48*i + 47] } } };
							end // else overflow 								
						end



						neure_cnt <= 8'd0;

						layer_cnt <= layer_cnt + 7'd1;	//it 's in hidden layer ,so it unnecessary to check if is the output layer

					end


				end // else odd layer

			end // else // Hiden Layer

			/* Layer state machine End */

		end // else ( state_initialize == WORK_STATE )

	end // else (RST_n)
end











endmodule

