`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/29 14:25:32
// Design Name: 
// Module Name: TJ432-FANN-TOP
// Project Name: 
// Target Devices: 
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


module TJ432_FANN_TOP(
    input i_sysclk,

    output LED0,
    output LED1,
    output LED2,
    output LED3,
    output LED4,
    output LED5,
    output LED6,
    output LED7

);

reg [24:0] i_NEURE_INPUT0_Reg;
reg [24:0] i_NEURE_INPUT1_Reg;
reg [24:0] i_NEURE_INPUT2_Reg;
reg [24:0] i_NEURE_INPUT3_Reg;
	
wire [24:0] i_NEURE_OUTPUT0_Wire;

wire state_wire;


reg [3:0] shift_reg;

TJ432_FANN_MID i_FANN(
	.SYSCLK(i_sysclk),
	.RST_n(1'b1),

	.i_NEURE_INPUT0(i_NEURE_INPUT0_Reg),
	.i_NEURE_INPUT1(i_NEURE_INPUT1_Reg),
	.i_NEURE_INPUT2(i_NEURE_INPUT2_Reg),
	.i_NEURE_INPUT3(i_NEURE_INPUT3_Reg),

	
	.i_NEURE_OUTPUT0(i_NEURE_OUTPUT0_Wire),


	.state(state_wire)
);




always @( posedge i_sysclk ) begin
	if ( state_wire == 0 ) begin

		i_NEURE_INPUT0_Reg <= { i_NEURE_OUTPUT0_Wire[24:22] , {22{1'b0}} };
		i_NEURE_INPUT1_Reg <= i_NEURE_INPUT0_Reg;
		i_NEURE_INPUT2_Reg <= i_NEURE_INPUT1_Reg;
		i_NEURE_INPUT3_Reg <= i_NEURE_INPUT2_Reg;
		shift_reg <= i_NEURE_OUTPUT0_Wire[24:22];
	end
	else begin

	end // else

end

assign {LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7} = (1 << shift_reg);

endmodule
