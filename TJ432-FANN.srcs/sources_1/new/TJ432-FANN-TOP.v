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
    input [24:0] A_0,
    input [17:0] B_0,

    output [47:0] P_0

    );

reg [24:0] A_0_reg = 25'd0;
reg [17:0] B_0_reg = 18'd0;
reg [47:0] C_0_reg = 48'd0;
reg [47:0] P_0_reg = 48'd0;


assign P_0 = P_0_reg;

wire [47:0] mult_P0;

mult_add_wrapper i_mult_add(
    .A_0(A_0_reg),
    .B_0(B_0_reg),
    .C_0(C_0_reg),
    .P_0(mult_P0),
    .SUBTRACT_0(1'b0)
);    

always @( posedge i_sysclk ) begin
    A_0_reg <= A_0;
    B_0_reg <= B_0;
    C_0_reg <= mult_P0;
    P_0_reg <= mult_P0;
end

endmodule
