//////////////////////////////////////////////////////////////////////////////////
// Company:  WUT 
// Engineer: Ruige_Lee
// Create Date: 2019-05-24 14:14:36
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-05-24 14:36:13
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name:   
// Module Name: ip_PWM
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


`timescale 1ns / 1ps




module perip_PWM 
	(
		input CLK,
		input RST_n,

		input [31:0] FREQ_Cnt_Set,
		input [31:0] Chn_duty_Set,

		output PWM_CHn
	);




wire pwm_chn_Din;
	
	yj_basic_reg_clk_p # (
		.DW(1),
		.RSTVAL(1'b0)
	) 
	PWM_CHn_reg
	(
		.CLK(CLK),
		.RSTn(RST_n),

		.din(pwm_chn_Din),
		.qout(PWM_CHn)
);


wire [31:0] pwm_cnt_Din;
wire [31:0] pwm_cnt_Qout;


	yj_basic_reg_clk_p # (
		.DW(32),
		.RSTVAL(32'd0)
	) 
	pwm_cnt
	(
		.CLK(CLK),
		.RSTn(RST_n),

		.din(pwm_cnt_Din),
		.qout(pwm_cnt_Qout)
);

wire pwm_reset_Wire = (pwm_cnt_Qout == FREQ_Cnt_Set) ? 1'b1 : 1'b0;
wire pwm_set_Wire = (pwm_cnt_Qout < Chn_duty_Set) ? 1'b1 : 1'b0;

assign pwm_cnt_Din = pwm_reset_Wire ? 32'd0 : pwm_cnt_Qout + 32'd1;
assign pwm_chn_Din = pwm_set_Wire ? 1'b1 : 1'b0;


endmodule





