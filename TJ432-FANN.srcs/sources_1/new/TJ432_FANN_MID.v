`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/08/31 17:19:12
// Design Name: 
// Module Name: TJ432_FANN_MID
// Project Name: TJ432-FANN
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


module TJ432_FANN_MID(
	input SYSCLK,
	input RST_n
	);
	
wire [24:0] Activation_Fun_Y_Wire; 
wire [899:0] Weight_BUS_Wire;
(* DONT_TOUCH = "TRUE" *)wire [2399:0] Mult_C_BUS_Wire;
(* DONT_TOUCH = "TRUE" *)wire [2399:0] Mult_P_BUS_Wire;


//mult_add_wrapper i_mult_adder_0(
//	.A_0(Activation_Fun_Y_Wire),				//[24:0]
//	.B_0(Weight_BUS_Wire[17:0]),				//[17:0]
//	.C_0(Mult_C_BUS_Wire[47:0]),				//[47:0]
//	.P_0(Mult_P_BUS_Wire[47:0]),				//[47:0]
//	.SUBTRACT_0(1'b0)
//);

//mult_add_wrapper i_mult_adder_1(
//	.A_0(Activation_Fun_Y_Wire),				//[24:0]
//	.B_0(Weight_BUS_Wire[35:18]),				//[17:0]
//	.C_0(Mult_C_BUS_Wire[95:48]),				//[47:0]
//	.P_0(Mult_P_BUS_Wire[95:48]),				//[47:0]
//	.SUBTRACT_0(1'b0)
//);

//mult_add_wrapper i_mult_adder_2(
//	.A_0(Activation_Fun_Y_Wire),				//[24:0]
//	.B_0(Weight_BUS_Wire[53:36]),				//[17:0]
//	.C_0(Mult_C_BUS_Wire[143:96]),				//[47:0]
//	.P_0(Mult_P_BUS_Wire[143:96]),				//[47:0]
//	.SUBTRACT_0(1'b0)
//);

//mult_add_wrapper i_mult_adder_3(
//	.A_0(Activation_Fun_Y_Wire),				//[24:0]
//	.B_0(Weight_BUS_Wire[71:54]),				//[17:0]
//	.C_0(Mult_C_BUS_Wire[191:144]),				//[47:0]
//	.P_0(Mult_P_BUS_Wire[191:144]),				//[47:0]
//	.SUBTRACT_0(1'b0)
//);



generate
genvar i;
    for ( i = 0 ;i < 4 ;i = i+1 ) begin:GEN_MULT
    mult_add_wrapper i_mult_adder_G(
        .A_0(Activation_Fun_Y_Wire),				//[24:0]
        .B_0(Weight_BUS_Wire[18*(i+1) - 1 : 18 * i]),				//[17:0]
        .C_0(Mult_C_BUS_Wire[48*(i+1) - 1 : 48*i]),				//[47:0]
        .P_0(Mult_P_BUS_Wire[48*(i+1) - 1 : 48*i]),				//[47:0]
        .SUBTRACT_0(1'b0)
    );
    end
    
endgenerate


wire [15:0] Activation_ROM_Addr_Wire;
wire [8:0] Weight_ROM_Wire;

Activation_ROM_wrapper i_Activation_ROM(
	.BRAM_PORTA_0_addr(Activation_ROM_Addr_Wire),		//[15:0]
	.BRAM_PORTA_0_clk(SYSCLK),
	.BRAM_PORTA_0_dout(Activation_Fun_Y_Wire)		//[24:0]
 );

Weight_ROM_wrapper i_Weight_ROM(
	.BRAM_PORTA_0_addr(Weight_ROM_Wire),		//[8:0]
	.BRAM_PORTA_0_clk(SYSCLK),
	.BRAM_PORTA_0_dout(Weight_BUS_Wire)		//[899:0]
);

fann_net i_fann_net(
	.CLK(SYSCLK),    // Clock
	.RST_n(RST_n),  // Asynchronous reset active low
	
	.Activation_ROM_Addr(Activation_ROM_Addr_Wire),
	.Weight_ROM_Addr(Weight_ROM_Wire)
);

endmodule
