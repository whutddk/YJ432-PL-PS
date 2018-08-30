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

			// /* Layer state machine Start*/
			// if ( layer_cnt == 8'd0 ) begin	//input layer

			// end // if ( layer_cnt == 8'd0 )

			// else if ( layer_cnt >= LAYER_NUM ) begin //Final Layer

			// end // else if ( layer_cnt == LAYER_NUM ) //Final Layer

			// else begin // Hiden Layer

			// end // else // Hiden Layer

			// /* Layer state machine End */



		end // else ( state_initialize == WORK_STATE )




	end // else (RST_n)
end











endmodule

