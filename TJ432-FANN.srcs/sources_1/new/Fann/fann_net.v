`timescale 1ns / 1ps
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
	
	output reg [15:0] Activation_ROM_Addr,
	output reg [8:0] Weight_ROM_Addr,

	output reg [48 * MAX_BANDWIDTH - 1:0] Mult_C_BUS_Reg,
	input [48 * MAX_BANDWIDTH - 1:0] Mult_P_BUS
);

parameter INIT_STATE = 1'b0;
parameter WORK_STATE = 1'b1;

reg state_initialize = INIT_STATE;
reg [31:0] init_cnt = 32'd0;
reg [7:0] layer_cnt = 8'd0;
reg [8:0] neure_cnt = 9'd0;




/* GET ALL Connection of a neure in one tick */
reg [18 * MAX_BANDWIDTH - 1 : 0] Weight_Lay;


/* Q24 -16777216~16777215 */
reg [24:0] Neure_Buff_A[ 0 : MAX_BANDWIDTH - 1 ];
reg [24:0] Neure_Buff_B[ 0 : MAX_BANDWIDTH - 1 ];

/* Q17 -131072~131071 */

reg [8:0] LAYER_NEURE_OFFSET = 9'd0;


always @( posedge CLK or negedge RST_n ) begin
	if ( !RST_n ) begin
		state_initialize <= INIT_STATE;
		init_cnt <= 32'd0;
		layer_cnt <= 8'd0;
		neure_cnt <= 8'd0;
		LAYER_NEURE_OFFSET <= 9'd0; //assistant register

	end // if ( !RST_n )

	else begin
		if ( state_initialize == INIT_STATE ) begin

		end // if ( state_initialize == INIT_STATE )

		else begin //( state_initialize == WORK_STATE )

			/* Layer state machine Start*/

			/****************** Input Layer*********************/
			if ( layer_cnt == 8'd0 ) begin	//input layer 

			end // if ( layer_cnt == 8'd0 )

			/******************output Layer*********************/

			else if ( layer_cnt >= LAYER_NUM ) begin //Final Layer

			end // else if ( layer_cnt == LAYER_NUM ) //Final Layer

			/****************** Hidden Layer*********************/

			else begin // Hiden Layer

				/****************** EVEN Hidden Layer*********************/
				if ( layer_cnt[0]  == 1'b0 ) begin // even layer
					// last layer neure data has been put in buff A
					// this layer neure data should be put into buff B
					
				end // if ( layer_cnt[0]  == 1'b0 ) even layer

				/****************** Odd Hidden Layer*********************/

				else begin	// odd LAYER
					/* last layer neure data has been put in buff A*/
					/* this layer neure data should be put into buff B*/
					
					neure_cnt <= neure_cnt + 8'd1;

					begin: DEAL_WITH_ROM_ADDRESS
						if ( neure_cnt <= LAYERX_NEURE_NUM ) begin
							Activation_ROM_Addr <= Neure_Buff_A[LAYER_NEURE_OFFSET + neure_cnt];
							Weight_ROM_Addr <= LAYER_NEURE_OFFSET + neure_cnt;
						end
					end

					begin: CALCULATE
						if ( neure_cnt == 8'd0 ) begin
							Mult_C_BUS_Reg <= {48 * MAX_BANDWIDTH{1'b0}};
						end
						else begin
							Mult_C_BUS_Reg <= Mult_P_BUS; //adder sum reload 
						end
					end

					/*************** final neure in this layer ******************/
					if ( neure_cnt == NEURE_LAY1 + 9'd1 && layer_cnt == 8'd1
						|| neure_cnt == NEURE_LAY3 + 9'd1 && layer_cnt == 8'd3
						|| neure_cnt == NEURE_LAY5 + 9'd1 && layer_cnt == 8'd5
						|| neure_cnt == NEURE_LAY7 + 9'd1 && layer_cnt == 8'd7
						) begin

						generate
							genvar i;
							for ( i = 0; i < MAX_BANDWIDTH ; i = i + 1 ) begin: LOAD_NEURE
								
								if ( (Mult_P_BUS[ 48*i + 47 : 48*i + 41 ] == 7'b1111111) || ( Mult_P_BUS[ 48*i + 47 : 48*i + 41 ] == 7'b0 ) ) begin
									Neure_Buff_B[i] <= { Mult_P_BUS[48*i + 47] , Mult_P_BUS[48*i + 40 : 48*i + 17] };
								end

								else begin //overflow
									Neure_Buff_B[i] <= { Mult_P_BUS[48*i + 47] , { 24{ ~Mult_P_BUS[48*i + 47] } } }
								end // else overflow 								
							end
						endgenerate


						neure_cnt <= 8'd0;

						layer_cnt <= layer_cnt + 7'd1;	//it 's in hidden layer ,so it unnecessary to check if is the output layer
						LAYER_NEURE_OFFSET <= LAYER_NEURE_OFFSET + NEURE_LAYx_num;
					end


				end // else odd layer

			end // else // Hiden Layer

			/* Layer state machine End */



		end // else ( state_initialize == WORK_STATE )




	end // else (RST_n)
end











endmodule

