//////////////////////////////////////////////////////////////////////////////////
// Company:  WUT 
// Engineer: WUT RUIGE LEE
// Create Date: 2018/06/21 17:44:39
// Last Modified by:   WUT_Ruige_Lee
// Last Modified time: 2019-01-12 16:19:03
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: FB_PWM
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



`timescale 1ns / 1ps


//寄存器读写
//外部读出
always@( negedge BUS_CS or negedge RST_n )
    if ( !RST_n ) begin
        BUS_DATA_REG <= 32'b0;
    end
    
    else begin
        if ( ADD_COMF ) begin        //仲裁通过
            if ( BUS_read == 1'b1 ) begin
                case(BUS_ADDR[21:0])
                    22'b000000:
                        BUS_DATA_REG[31:0] <= FREQ_Cnt_Reg[31:0];
                    22'b000100:
                        BUS_DATA_REG[31:0] <= CH0_duty_Reg[31:0];
                    22'b001000:
                        BUS_DATA_REG[31:0] <= CH1_duty_Reg[31:0];
                    22'b001100:
                        BUS_DATA_REG[31:0] <= CH2_duty_Reg[31:0];
                    22'b010000:
                        BUS_DATA_REG[31:0] <= CH3_duty_Reg[31:0];
                    22'b010100:
                        BUS_DATA_REG[31:0] <= CH4_duty_Reg[31:0];
                    22'b011000:
                        BUS_DATA_REG[31:0] <= CH5_duty_Reg[31:0];
                    22'b011100:
                        BUS_DATA_REG[31:0] <= CH6_duty_Reg[31:0];
                    22'b100000:
                        BUS_DATA_REG[31:0] <= CH7_duty_Reg[31:0];
                    default:
                        BUS_DATA_REG[31:0] <=32'hffffffff;
                endcase
            end
        end
    end

endmodule


module PWM(

	CLK,
	RST_n,

//Register
	FREQ_Cnt_Set,	//作为计数目标，自己外部计算
    CH0_duty_Set,
	CH1_duty_Set,
	CH2_duty_Set,
	CH3_duty_Set,
	CH4_duty_Set,
    CH5_duty_Set,
    CH6_duty_Set,
    CH7_duty_Set,


//OUTPUT
    PWM_CH0,
    PWM_CH1,
    PWM_CH2,
    PWM_CH3,
    PWM_CH4,
    PWM_CH5,
    PWM_CH6,
    PWM_CH7


	);

input CLK;
input RST_n;

//Register
input [31:0] FREQ_Cnt_Set;	//作为计数目标，自己外部计算
input [31:0] CH0_duty_Set;
input [31:0] CH1_duty_Set;
input [31:0] CH2_duty_Set;
input [31:0] CH3_duty_Set;
input [31:0] CH4_duty_Set;
input [31:0] CH5_duty_Set;
input [31:0] CH6_duty_Set;
input [31:0] CH7_duty_Set;


//OUTPUT
output PWM_CH0;
output PWM_CH1;
output PWM_CH2;
output PWM_CH3;
output PWM_CH4;
output PWM_CH5;
output PWM_CH6;
output PWM_CH7;

reg PWM_CH0_reg = 1'b0;
reg PWM_CH1_reg = 1'b0;
reg PWM_CH2_reg = 1'b0;
reg PWM_CH3_reg = 1'b0;
reg PWM_CH4_reg = 1'b0;
reg PWM_CH5_reg = 1'b0;
reg PWM_CH6_reg = 1'b0;
reg PWM_CH7_reg = 1'b0;

assign PWM_CH0 = PWM_CH0_reg;
assign PWM_CH1 = PWM_CH1_reg;
assign PWM_CH2 = PWM_CH2_reg;
assign PWM_CH3 = PWM_CH3_reg;
assign PWM_CH4 = PWM_CH4_reg;
assign PWM_CH5 = PWM_CH5_reg;
assign PWM_CH6 = PWM_CH6_reg;
assign PWM_CH7 = PWM_CH7_reg;

reg [31:0] pwm_cnt = 32'd0;


always@( posedge CLK or negedge RST_n )begin
	if ( !RST_n ) begin
		pwm_cnt <= 32'd0;

		PWM_CH0_reg <= 1'b0;
		PWM_CH1_reg <= 1'b0;
		PWM_CH2_reg <= 1'b0;
		PWM_CH3_reg <= 1'b0;
		PWM_CH4_reg <= 1'b0;
		PWM_CH5_reg <= 1'b0;
		PWM_CH6_reg <= 1'b0;
		PWM_CH7_reg <= 1'b0;

	end
	else begin
		pwm_cnt <= pwm_cnt + 32'd1;


		if ( pwm_cnt >= FREQ_Cnt_Set) begin	//对齐
			PWM_CH0_reg <= 1'b1;
			PWM_CH1_reg <= 1'b1;
			PWM_CH2_reg <= 1'b1;
			PWM_CH3_reg <= 1'b1;
			PWM_CH4_reg <= 1'b1;
			PWM_CH5_reg <= 1'b1;
			PWM_CH6_reg <= 1'b1;
			PWM_CH7_reg <= 1'b1;

			pwm_cnt <= 32'd0;
		end
//占空比
		if ( pwm_cnt == CH0_duty_Set ) PWM_CH0_reg <= 1'b0;
		if ( pwm_cnt == CH1_duty_Set ) PWM_CH1_reg <= 1'b0;
		if ( pwm_cnt == CH2_duty_Set ) PWM_CH2_reg <= 1'b0;
		if ( pwm_cnt == CH3_duty_Set ) PWM_CH3_reg <= 1'b0;
		if ( pwm_cnt == CH4_duty_Set ) PWM_CH4_reg <= 1'b0;
		if ( pwm_cnt == CH5_duty_Set ) PWM_CH5_reg <= 1'b0;
		if ( pwm_cnt == CH6_duty_Set ) PWM_CH6_reg <= 1'b0;
		if ( pwm_cnt == CH7_duty_Set ) PWM_CH7_reg <= 1'b0;


	end

end





endmodule





