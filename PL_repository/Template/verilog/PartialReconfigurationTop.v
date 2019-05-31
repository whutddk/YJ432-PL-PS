//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-05-24 14:15:27
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-05-24 14:22:05
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name:   
// Module Name: PartialReconfigurationTop
// Project Name:   
// Target Devices:   
// Tool Versions:   
// Description:   
// 
// Dependencies:   
// 
// Revision:  
// Revision:    -   
// Additional Comments:  
// 
//
//////////////////////////////////////////////////////////////////////////////////


module PartialReconfigurationTop (
	input i_sysclk,
//	input RST_n,
	
	
    output BZ,
    output LED_R,
    output LED_G,
    output LED_B

);


	
	
PRpwm1to4 i_cfg1(
	.CLK(i_sysclk),
	.RST_n(1'b1),


	.BZ(BZ),
	.LED_R(LED_R),
	.LED_G(LED_G),
	.LED_B(LED_B)

	
);
	
endmodule


