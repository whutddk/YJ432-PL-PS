//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-05-24 16:02:55
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-05-24 16:05:23
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name:   
// Module Name: PRpwm1to4
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


module PRpwm1to4 (
	input CLK,
	input RST_n,


	output BZ,
	output LED_R,
	output LED_G,
	output LED_B

	
);


perip_PWM i_pwm_cfg(
		.CLK(CLK),
		.RST_n(RST_n),

		.FREQ_Cnt_Set(10000),
		.Chn_duty_Set(1000),

		.PWM_CHn(LED_B)
	);

reg BZ_reg = 1'b0;
reg R_reg = 1'b1;
reg G_reg = 1'b1;

assign BZ = BZ_reg;
assign LED_R = R_reg;
assign LED_G = G_reg;




endmodule