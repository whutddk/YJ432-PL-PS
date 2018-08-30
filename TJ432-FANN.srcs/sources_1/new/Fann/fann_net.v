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
	input RST_n  // Asynchronous reset active low
	
);

parameter INIT_STATE = 1'b0;
parameter WORK_STATE = 1'b1;

reg state_initialize = INIT_STATE;
reg [31:0] init_cnt = 32'd0;
reg [7:0] layer_cnt = 8'd0;
reg [7:0] neure_cnt = 8'd0;


/* USER Patameter */
`define LAYER_NUM  8'd9 //10 layer

`define NEURE_LAY0 8'd8	//input layer:number of input
`define NEURE_LAY1 8'd50
`define NEURE_LAY2 8'd50
`define NEURE_LAY3 8'd50
`define NEURE_LAY4 8'd50
`define NEURE_LAY5 8'd50
`define NEURE_LAY6 8'd50
`define NEURE_LAY7 8'd50
`define NEURE_LAY8 8'd50
`define NEURE_LAY9 8'd4	//output layer:number of output

`define MAX_BANDWIDTH 	50

//放在一起方便寻址
// reg [17:0] Weight_Lay[0:400 + 2500 * 7 + 200 - 1];

/*打一拍直接把下一拍需要的所有数据读出来 18bit*50 */
reg [900:0] Weight_Lay;

//generate
//    genvar i;

//endgenerate
reg [24:0] Neure_Buff_A[ 0 : MAX_BANDWIDTH - 1 ];
reg [24:0] Neure_Buff_B[ 0 : MAX_BANDWIDTH - 1 ];

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
				if ( layer_cnt[0]  == 1'b0 ) begin // 偶数层
					//上一层神经元装在A buff中
					//本层神经元装在B buff中
					



				end // if ( layer_cnt[0]  == 1'b0 )偶数层

				else begin	//奇数层
					/*上一层神经元装在B buff中*/
					/*本层神经元装在A buff中*/
					
					/*乘和累加*/
					//Neure_Buff_B[0] <= Neure_Buff_B[0] + Neure_Buff_A[neure_cnt] * Weight_Lay[]
					// ...
					//Neure_Buff_B[49] <= Neure_Buff_B[49] + Neure_Buff_A[neure_cnt] * Weight_Lay[]

					//neure_cnt <= neure_cnt + 8'd1;

					//if ( neure_cnt == NEURE_LAY1 && layer_cnt == 1 
					//	|| neure_cnt == NEURE_LAY2 && layer_cnt == 2
					//	|| ...
					//	|| ...) begin
					//layer_cnt <= layer_cnt + 8'd1
					//neure_cnt <= 8'd0;
					
					/*激活*/
					//Neure_Buff_B[0] <= Neure_Buff_B[0] * Sign_ROM
					//Neure_Buff_B[1] <= Neure_Buff_B[0] * Sign_ROM
					//...
					//Neure_Buff_B[49] <= Neure_Buff_B[49] * Sign_ROM
					//end


				end // else 奇数层

			end // else // Hiden Layer

			/* Layer state machine End */



		end // else ( state_initialize == WORK_STATE )




	end // else (RST_n)
end











endmodule

