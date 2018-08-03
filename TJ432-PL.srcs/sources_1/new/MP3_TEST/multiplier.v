`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/08/03 17:27:16
// Design Name: 
// Module Name: multiplier
// Project Name: TJ432-B
// Target Devices: Artix-7 35T
// Tool Versions: 
// Description: multiplier resource for TJ432-B
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

Module multiplier(
	multA,
	multB,
	mult_out,

);

input [31:0] multA;
input [31:0] multB;
output [63:0] mult_out;

assign mult_out[63:0] = multA[31:0] * multB[31:0];

endmodule


