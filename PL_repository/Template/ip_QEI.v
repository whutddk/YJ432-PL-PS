//////////////////////////////////////////////////////////////////////////////////
// Company: WUT  
// Engineer: WUT RUIGE LEE
// Create Date: 2018/06/21 17:44:39
// Last Modified by:   WUT_Ruige_Lee
// Last Modified time: 2019-01-12 16:28:05
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: ip_QEI
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


module perip_QEI(

	CLK,
	RST_n,

	//Register
	QEI_CLEAR_Set,	//是否清零?
	QEI_CH0_Read,	//只读寄存器
	QEI_CH1_Read,
	QEI_CH2_Read,
	QEI_CH3_Read,

	CH0_PHASEA,
	CH0_PHASEB,

	CH1_PHASEA,
	CH1_PHASEB,

	CH2_PHASEA,
	CH2_PHASEB,

	CH3_PHASEA,
	CH3_PHASEB

	);

input CLK;
input RST_n;

	//Register
input [31:0] QEI_CLEAR_Set;	//是否清零?
output reg [31:0] QEI_CH0_Read = 32'd0;
output reg [31:0] QEI_CH1_Read = 32'd0;
output reg [31:0] QEI_CH2_Read = 32'd0;
output reg [31:0] QEI_CH3_Read = 32'd0;

input CH0_PHASEA;
input CH0_PHASEB;

input CH1_PHASEA;
input CH1_PHASEB;

input CH2_PHASEA;
input CH2_PHASEB;

input CH3_PHASEA;
input CH3_PHASEB;

reg [1:0] CH0_state = 2'b0;
reg [1:0] CH1_state = 2'b0;
reg [1:0] CH2_state = 2'b0;
reg [1:0] CH3_state = 2'b0;

reg [1:0] CH0_prestate = 2'b0;
reg [1:0] CH1_prestate = 2'b0;
reg [1:0] CH2_prestate = 2'b0;
reg [1:0] CH3_prestate = 2'b0;

always @( posedge CLK or negedge RST_n )
if ( !RST_n ) begin 

	//寄存器清零
	QEI_CH0_Read <= 32'd0;
	QEI_CH1_Read <= 32'd0;
	QEI_CH2_Read <= 32'd0;
	QEI_CH3_Read <= 32'd0;

	CH0_state[1:0] <= 2'b0;
	CH1_state[1:0] <= 2'b0;
	CH2_state[1:0] <= 2'b0;
	CH3_state[1:0] <= 2'b0;

	CH0_prestate[1:0] <= 2'b0;
	CH1_prestate[1:0] <= 2'b0;
	CH2_prestate[1:0] <= 2'b0;
	CH3_prestate[1:0] <= 2'b0;
end

else begin 

	//时钟快，没关系，多拍一下
	CH0_state[1:0] <= {CH0_PHASEB , CH0_PHASEA};
	CH1_state[1:0] <= {CH1_PHASEB , CH1_PHASEA};
	CH2_state[1:0] <= {CH2_PHASEB , CH2_PHASEA};
	CH3_state[1:0] <= {CH3_PHASEB , CH3_PHASEA};

	CH0_prestate[1:0] <= CH0_state[1:0];
	CH1_prestate[1:0] <= CH1_state[1:0];
	CH2_prestate[1:0] <= CH2_state[1:0];
	CH3_prestate[1:0] <= CH3_state[1:0];

//QEI_CH0
	if ( QEI_CLEAR_Set[0]  == 1'b1 ) begin 
		QEI_CH0_Read <= 32'd0;
	end

	else begin
		case({CH0_prestate[1:0],CH0_state[1:0]})
			4'b1011,4'b0100,4'b0010,4'b1101:	
				QEI_CH0_Read <= QEI_CH0_Read - 32'd1;

			4'b1110,4'b0001,4'b0111,4'b1000:	
				QEI_CH0_Read <= QEI_CH0_Read + 32'd1;

			default:	QEI_CH0_Read <= QEI_CH0_Read;
		endcase
	end

//QEI_CH1
	if ( QEI_CLEAR_Set[1]  == 1'b1 ) begin
		QEI_CH1_Read <= 32'd0;
	end

	else begin
		case({CH1_prestate[1:0],CH1_state[1:0]})
			4'b1011,4'b0100,4'b0010,4'b1101:	
				QEI_CH1_Read <= QEI_CH1_Read - 32'd1;

			4'b1110,4'b0001,4'b0111,4'b1000:	
				QEI_CH1_Read <= QEI_CH1_Read + 32'd1;

			default:	QEI_CH1_Read <= QEI_CH1_Read;
		endcase
	end

//QEI_CH2
	if ( QEI_CLEAR_Set[2]  == 1'b1 ) begin
		QEI_CH2_Read <= 32'd0;
	end

	else begin
		case({CH2_prestate[1:0],CH2_state[1:0]})
			4'b1011,4'b0100,4'b0010,4'b1101:	
				QEI_CH2_Read <= QEI_CH2_Read - 32'd1;

			4'b1110,4'b0001,4'b0111,4'b1000:	
				QEI_CH2_Read <= QEI_CH2_Read + 32'd1;

			default:	QEI_CH2_Read <= QEI_CH2_Read;
		endcase
	end

//QEI_CH3
	if ( QEI_CLEAR_Set[3]  == 1'b1 ) begin
		QEI_CH3_Read <= 32'd0;
	end

	else begin
		case({CH3_prestate[1:0],CH3_state[1:0]})
			4'b1011,4'b0100,4'b0010,4'b1101:	
				QEI_CH3_Read <= QEI_CH3_Read - 32'd1;

			4'b1110,4'b0001,4'b0111,4'b1000:	
				QEI_CH3_Read <= QEI_CH3_Read + 32'd1;

			default:	QEI_CH3_Read <= QEI_CH3_Read;
		endcase
	end


end


endmodule


