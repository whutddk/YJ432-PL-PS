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
reg [7:0] neure_cnt = 8'd0;




/* GET ALL Connection of a neure in one tick */
reg [18 * MAX_BANDWIDTH - 1 : 0] Weight_Lay;


/* Q24 -16777216~16777215 */
reg [24:0] Neure_Buff_A[ 0 : MAX_BANDWIDTH - 1 ];
reg [24:0] Neure_Buff_B[ 0 : MAX_BANDWIDTH - 1 ];

/* Q17 -131072~131071 */


always @( posedge CLK or negedge RST_n ) begin
	if ( !RST_n ) begin
		state_initialize <= INIT_STATE;
		init_cnt <= 32'd0;
		layer_cnt <= 8'd0;
		neure_cnt <= 8'd0;
	end // if ( !RST_n )

	else begin
		if ( state_initialize == INIT_STATE ) begin

		end // if ( state_initialize == INIT_STATE )

		else begin //( state_initialize == WORK_STATE )

			/* Layer state machine Start*/
			if ( layer_cnt == 8'd0 ) begin	//input layer 

			end // if ( layer_cnt == 8'd0 )

			else if ( layer_cnt >= LAYER_NUM ) begin //Final Layer

			end // else if ( layer_cnt == LAYER_NUM ) //Final Layer

			else begin // Hiden Layer
				if ( layer_cnt[0]  == 1'b0 ) begin // even layer
					// last layer neure data has been put in buff A
					// this layer neure data should be put into buff B
					



				end // if ( layer_cnt[0]  == 1'b0 ) even layer

				else begin	// odd LAYER
					/* last layer neure data has been put in buff A*/
					/* this layer neure data should be put into buff B*/
					
					

					neure_cnt <= neure_cnt + 8'd1;

					begin:  DEAL_WITH_ROM_ADDRESS
						if ( neure_cnt <= LAYERX_NEURE_NUM ) begin
							Activation_ROM_Addr <= Neure_Buff_A[LAYERX_NEURE_OFFSET + neure_cnt];
							Weight_ROM_Addr <= LAYERX_NEURE_OFFSET + neure_cnt;
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

					if ( neure_cnt == NEURE_LAYx_num + 1 && layer_cnt == 
						|| neure_cnt == && 
						|| ) begin
						Neure_Buff_B[0] <= Mult_P_BUS[:];
								...
						Neure_Buff_B[49] <= Mult_P_BUS[:];

						neure_cnt <= 8'd0;

						layer_cnt <= layer_cnt + 7'd1;	//it 's in hidden layer ,so it unnecessary to check if is the output layer
					end




					/* mult and add */
					//Neure_Buff_B[0] <= Neure_Buff_B[0] + Neure_Buff_A[neure_cnt] * Weight_Lay[Address_Wire]
					// ...
					//Neure_Buff_B[49] <= Neure_Buff_B[49] + Neure_Buff_A[neure_cnt] * Weight_Lay[Address_Wire + 49]

					//neure_cnt <= neure_cnt + 8'd1;

					//if ( neure_cnt == NEURE_LAY1 && layer_cnt == 1 
					//	|| neure_cnt == NEURE_LAY2 && layer_cnt == 2
					//	|| ...
					//	|| ...) begin
					//layer_cnt <= layer_cnt + 8'd1
					//neure_cnt <= 8'd0;
					
					/* activation through lookup table */
					//Neure_Buff_B[0] <= Neure_Buff_B[0] * Sign_ROM
					//Neure_Buff_B[1] <= Neure_Buff_B[0] * Sign_ROM
					//...
					//Neure_Buff_B[49] <= Neure_Buff_B[49] * Sign_ROM
					//end


				end // else odd layer

			end // else // Hiden Layer

			/* Layer state machine End */



		end // else ( state_initialize == WORK_STATE )




	end // else (RST_n)
end











endmodule

