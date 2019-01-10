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

module multiplier(
	sum,
	multA,
	multB,
	mult_out

);

inout signed [63:0] sum;
inout signed [31:0] multA;
inout signed [31:0] multB;
output signed [63:0] mult_out;

wire signed [63:0] mult_res;

assign sum = 64'bz;
assign multA = 32'bz;
assign multB = 32'bz;

assign mult_res = multA * multB;

assign mult_out = sum + mult_res;

endmodule


