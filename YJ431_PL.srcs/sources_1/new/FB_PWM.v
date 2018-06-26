`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WUT
// Engineer: WUT RUIGE LEE
// 
// Create Date: 2018/06/21 17:44:39
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


module FB_PWMREG(
    RST_n,
	BUS_ADDR,
	BUS_DATA,
	BUS_CS,

	BUS_read,
	BUS_write,

	BZLED_BASE,

//Register
	FREQ_Cnt_Reg,	//作为计数目标，自己外部计算
    CH0_duty_Reg,
	CH1_duty_Reg,
	CH2_duty_Reg,
	CH3_duty_Reg,
	CH4_duty_Reg,
    CH5_duty_Reg,
    CH6_duty_Reg,
    CH7_duty_Reg

    );
    
    input RST_n;
    input [31:0] BUS_ADDR;
    inout [31:0] BUS_DATA;
    input BUS_CS;

    input BUS_read;
    input BUS_write;

    input [9:0] BZLED_BASE;

//Register
	output reg [31:0] FREQ_Cnt_Reg;    //作为计数目标，自己外部计算
	output reg [31:0] CH0_duty_Reg;
	output reg [31:0] CH1_duty_Reg;
	output reg [31:0] CH2_duty_Reg;
	output reg [31:0] CH3_duty_Reg;
	output reg [31:0] CH4_duty_Reg;
	output reg [31:0] CH5_duty_Reg;
	output reg [31:0] CH6_duty_Reg;
	output reg [31:0] CH7_duty_Reg;
	
	wire AD_TRI_n;//非高阻状态标志位
	wire ADD_COMF;
	// reg AD_READ = 1'b0;
	// assign AD_TRI = ~BUS_CS &
	
	reg [31:0] BUS_DATA_REG = 32'b0;
	
	assign ADD_COMF = ( BUS_ADDR[31:22] == BZLED_BASE[9:0] ) ? 1'b1:1'b0;    //地址仲裁 
	assign AD_TRI_n = ADD_COMF & ~BUS_CS & BUS_read ; //时序逻辑判断是否设置非高阻：同时满足1地址，2片选，3外部请求读
	//进入非高阻态：1 地址仲裁通过 2 片选有效 3 为外部请求读?
	//脱离高阻态：1片选失效脱离 2地址失效 外部读写请求失效安全脱离?
   
	assign BUS_DATA = AD_TRI_n ? BUS_DATA_REG : 32'bz;
   
   
	//寄存器读写
   
	always@( negedge BUS_CS or negedge RST_n )
	if ( !RST_n ) begin
		FREQ_Cnt_Reg <= 32'd1;
		CH0_duty_Reg <= 32'b0;
		CH1_duty_Reg <= 32'b0;
		CH2_duty_Reg <= 32'b0;
		CH3_duty_Reg <= 32'b0;
		CH4_duty_Reg <= 32'b0;
		CH5_duty_Reg <= 32'b0;
		CH6_duty_Reg <= 32'b0;
		CH7_duty_Reg <= 32'b0;
	end

	else begin
		if ( ADD_COMF ) begin        //仲裁通过
			if ( BUS_write == 1'b1 ) begin
				BUS_DATA_REG <= BUS_DATA_REG;
				case(BUS_ADDR[3:0])
					4'd0: begin                
						FREQ_Cnt_Reg [31:0] <= BUS_DATA [31:0];
						CH0_duty_Reg <= CH0_duty_Reg;
						CH1_duty_Reg <= CH1_duty_Reg;
						CH2_duty_Reg <= CH2_duty_Reg;
						CH3_duty_Reg <= CH4_duty_Reg;   
						CH4_duty_Reg <= CH4_duty_Reg;
						CH5_duty_Reg <= CH5_duty_Reg;
						CH6_duty_Reg <= CH6_duty_Reg;
						CH7_duty_Reg <= CH7_duty_Reg;  
					end                
					4'd1: begin
						FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;

						if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin
							CH0_duty_Reg [31:0] <= BUS_DATA [31:0];
						end

						CH1_duty_Reg <= CH1_duty_Reg;
						CH2_duty_Reg <= CH2_duty_Reg;
						CH3_duty_Reg <= CH4_duty_Reg;   
						CH4_duty_Reg <= CH4_duty_Reg;
						CH5_duty_Reg <= CH5_duty_Reg;
						CH6_duty_Reg <= CH6_duty_Reg;
						CH7_duty_Reg <= CH7_duty_Reg;
					end
					4'd2: begin
						FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
						CH0_duty_Reg <= CH0_duty_Reg;
						if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护：占空比不能大于频率计数
							CH1_duty_Reg[31:0] <= BUS_DATA [31:0];
						end
						CH2_duty_Reg <= CH2_duty_Reg;
						CH3_duty_Reg <= CH4_duty_Reg;   
						CH4_duty_Reg <= CH4_duty_Reg;
						CH5_duty_Reg <= CH5_duty_Reg;
						CH6_duty_Reg <= CH6_duty_Reg;
						CH7_duty_Reg <= CH7_duty_Reg;
					end
					
					4'd3: begin
						FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
						CH0_duty_Reg <= CH0_duty_Reg;
						CH1_duty_Reg <= CH1_duty_Reg;
						if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护：占空比不能大于频率计数
							CH2_duty_Reg[31:0] <= BUS_DATA [31:0];
						end
						CH3_duty_Reg <= CH4_duty_Reg;   
						CH4_duty_Reg <= CH4_duty_Reg;
						CH5_duty_Reg <= CH5_duty_Reg;
						CH6_duty_Reg <= CH6_duty_Reg;
						CH7_duty_Reg <= CH7_duty_Reg;
					end
	                       
					4'd4: begin
						FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
						CH0_duty_Reg <= CH0_duty_Reg;
						CH1_duty_Reg <= CH1_duty_Reg;
						CH2_duty_Reg <= CH2_duty_Reg;
						if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护：占空比不能大于频率计数
							CH3_duty_Reg[31:0] <= BUS_DATA [31:0];
						end
						CH4_duty_Reg <= CH4_duty_Reg;
						CH5_duty_Reg <= CH5_duty_Reg;
						CH6_duty_Reg <= CH6_duty_Reg;
						CH7_duty_Reg <= CH7_duty_Reg;
					end
	                       
					4'd5:begin
						FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
						CH0_duty_Reg <= CH0_duty_Reg;
						CH1_duty_Reg <= CH1_duty_Reg;
						CH2_duty_Reg <= CH2_duty_Reg; 
						CH3_duty_Reg <= CH4_duty_Reg;
						if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护：占空比不能大于频率计数
							CH4_duty_Reg[31:0] <= BUS_DATA [31:0];
						end
						CH5_duty_Reg <= CH5_duty_Reg;
						CH6_duty_Reg <= CH6_duty_Reg;
						CH7_duty_Reg <= CH7_duty_Reg;
					end
	                       
					4'd6:begin
						FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
						CH0_duty_Reg <= CH0_duty_Reg;
						CH1_duty_Reg <= CH1_duty_Reg;
						CH2_duty_Reg <= CH2_duty_Reg; 
						CH3_duty_Reg <= CH4_duty_Reg;   
						CH4_duty_Reg <= CH4_duty_Reg;
						if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护：占空比不能大于频率计数
							CH5_duty_Reg[31:0] <= BUS_DATA [31:0];
						end
						CH6_duty_Reg <= CH6_duty_Reg;
						CH7_duty_Reg <= CH7_duty_Reg;                    	
					end
	                       
					4'd7:begin
						FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
						CH0_duty_Reg <= CH0_duty_Reg;
						CH1_duty_Reg <= CH1_duty_Reg;
						CH2_duty_Reg <= CH2_duty_Reg; 
						CH3_duty_Reg <= CH4_duty_Reg;   
						CH4_duty_Reg <= CH4_duty_Reg;
						CH5_duty_Reg <= CH5_duty_Reg;
						if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护：占空比不能大于频率计数
							CH6_duty_Reg[31:0] <= BUS_DATA [31:0];
						end
						CH7_duty_Reg <= CH7_duty_Reg;
					end
	                       
					4'd8:begin 
						FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
						CH0_duty_Reg <= CH0_duty_Reg;
						CH1_duty_Reg <= CH1_duty_Reg;
						CH2_duty_Reg <= CH2_duty_Reg; 
						CH3_duty_Reg <= CH4_duty_Reg;   
						CH4_duty_Reg <= CH4_duty_Reg;
						CH5_duty_Reg <= CH5_duty_Reg;
						CH6_duty_Reg <= CH6_duty_Reg;
						if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护：占空比不能大于频率计数
							CH7_duty_Reg[31:0] <= BUS_DATA [31:0];
						end 
					end
				endcase
			end        
			else begin //if ( BUS_read == 1'b1 )  
	   
				FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
				CH0_duty_Reg <= CH0_duty_Reg;
				CH1_duty_Reg <= CH1_duty_Reg;
				CH2_duty_Reg <= CH2_duty_Reg; 
				CH3_duty_Reg <= CH4_duty_Reg;   
				CH4_duty_Reg <= CH4_duty_Reg;
				CH5_duty_Reg <= CH5_duty_Reg;
				CH6_duty_Reg <= CH6_duty_Reg;
				CH7_duty_Reg <= CH7_duty_Reg;

				case(BUS_ADDR[3:0])
					4'd0:
						BUS_DATA_REG[31:0] <= FREQ_Cnt_Reg[31:0];
					4'd1:
						BUS_DATA_REG[31:0] <= CH0_duty_Reg[31:0];
					4'd2:
						BUS_DATA_REG[31:0] <= CH1_duty_Reg[31:0];
					4'd3:
						BUS_DATA_REG[31:0] <= CH2_duty_Reg[31:0];
					4'd4:
						BUS_DATA_REG[31:0] <= CH3_duty_Reg[31:0];
					4'd5:
						BUS_DATA_REG[31:0] <= CH4_duty_Reg[31:0];
					4'd6:
						BUS_DATA_REG[31:0] <= CH5_duty_Reg[31:0];
					4'd7:
						BUS_DATA_REG[31:0] <= CH6_duty_Reg[31:0];
					4'd8:
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

reg [31:0] ch0_cnt = 32'd0;
reg [31:0] ch1_cnt = 32'd0;
reg [31:0] ch2_cnt = 32'd0;
reg [31:0] ch3_cnt = 32'd0;
reg [31:0] ch4_cnt = 32'd0;
reg [31:0] ch5_cnt = 32'd0;
reg [31:0] ch6_cnt = 32'd0;
reg [31:0] ch7_cnt = 32'd0;

always@( posedge CLK or negedge RST_n )begin
	if ( !RST_n ) begin
		ch0_cnt <= 32'd0;
		ch1_cnt <= 32'd0;
		ch2_cnt <= 32'd0;
		ch3_cnt <= 32'd0;
		ch4_cnt <= 32'd0;
		ch5_cnt <= 32'd0;
		ch6_cnt <= 32'd0;
		ch7_cnt <= 32'd0;

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
		ch0_cnt <= ch0_cnt + 32'd1;
		ch1_cnt <= ch1_cnt + 32'd1;
		ch2_cnt <= ch2_cnt + 32'd1;
		ch3_cnt <= ch3_cnt + 32'd1;
		ch4_cnt <= ch4_cnt + 32'd1;
		ch5_cnt <= ch5_cnt + 32'd1;
		ch6_cnt <= ch6_cnt + 32'd1;
		ch7_cnt <= ch7_cnt + 32'd1;

		if ( ch0_cnt == FREQ_Cnt_Set) begin	//对齐
			PWM_CH0_reg <= 1'b1;
			PWM_CH1_reg <= 1'b1;
			PWM_CH2_reg <= 1'b1;
			PWM_CH3_reg <= 1'b1;
			PWM_CH4_reg <= 1'b1;
			PWM_CH5_reg <= 1'b1;
			PWM_CH6_reg <= 1'b1;
			PWM_CH7_reg <= 1'b1;

			ch0_cnt <= 32'd0;
			ch1_cnt <= 32'd0;
			ch2_cnt <= 32'd0;
			ch3_cnt <= 32'd0;
			ch4_cnt <= 32'd0;
			ch5_cnt <= 32'd0;
			ch6_cnt <= 32'd0;
			ch7_cnt <= 32'd0;

		end
//占空比
		if ( ch0_cnt == PWM_CH0_reg ) PWM_CH0_reg <= 1'b0;
		if ( ch1_cnt == PWM_CH1_reg ) PWM_CH1_reg <= 1'b0;
		if ( ch2_cnt == PWM_CH2_reg ) PWM_CH2_reg <= 1'b0;
		if ( ch3_cnt == PWM_CH3_reg ) PWM_CH3_reg <= 1'b0;
		if ( ch4_cnt == PWM_CH4_reg ) PWM_CH4_reg <= 1'b0;
		if ( ch5_cnt == PWM_CH5_reg ) PWM_CH5_reg <= 1'b0;
		if ( ch6_cnt == PWM_CH6_reg ) PWM_CH6_reg <= 1'b0;
		if ( ch7_cnt == PWM_CH7_reg ) PWM_CH7_reg <= 1'b0;


	end

end





endmodule





