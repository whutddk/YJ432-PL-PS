`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WUT
// Engineer: WUT RUIGE LEE
// 
// Create Date: 2018/06/21 17:44:39
// Design Name: 
// Module Name: FB_QEI
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


module FB_QEIREG(
 	RST_n,
	BUS_ADDR,
	BUS_DATA,
	BUS_CS,

	BUS_read,
	BUS_write,

	BZLED_BASE,

//Register
	QEI_CLEAR_Reg,	//读完是否清零?
	QEI_CH0_Read,	//只读寄存器
	QEI_CH1_Read,
	QEI_CH2_Read,
	QEI_CH3_Read

    );


input RST_n;
input [31:0] BUS_ADDR;
inout [31:0] BUS_DATA;
input BUS_CS;

input BUS_read;
input BUS_write;

input [9:0] BZLED_BASE;

output reg [31:0] QEI_CLEAR_Reg;	//读完是否清零?
input [31:0] QEI_CH0_Read;	//只读寄存器
input [31:0] QEI_CH1_Read;
input [31:0] QEI_CH2_Read;
input [31:0] QEI_CH3_Read;

// reg [31:0] QEI_CH0_Reg;	
// reg [31:0] QEI_CH1_Reg;
// reg [31:0] QEI_CH2_Reg;
// reg [31:0] QEI_CH3_Reg;

// assign QEI_CH0_Reg[31:0] = QEI_CH0_Read[31:0];
// assign QEI_CH1_Reg[31:0] = QEI_CH1_Read[31:0];
// assign QEI_CH2_Reg[31:0] = QEI_CH2_Read[31:0];
// assign QEI_CH3_Reg[31:0] = QEI_CH3_Read[31:0];

wire AD_TRI_n;//非高阻状态标志位
wire ADD_COMF;

reg [31:0] BUS_DATA_REG = 32'b0;

assign ADD_COMF = ( BUS_ADDR[31:22] == BZLED_BASE[9:0] ) ? 1'b1:1'b0;    //地址仲裁 
assign AD_TRI_n = ADD_COMF & ~BUS_CS & BUS_read ; //时序逻辑判断是否设置非高阻：同时满足1地址，2片选，3外部请求读
//进入非高阻态：1 地址仲裁通过 2 片选有效 3 为外部请求读?
//脱离高阻态：1片选失效脱离 2地址失效 外部读写请求失效安全脱离?

assign BUS_DATA = AD_TRI_n ? BUS_DATA_REG : 32'bz;

//寄存器读写
   
	always@( negedge BUS_CS or negedge RST_n )
	if ( !RST_n ) begin
		QEI_CLEAR_Reg <= 32'd0;
	end

	else begin
		if ( ADD_COMF ) begin        //仲裁通过
			if ( BUS_write == 1'b1 ) begin
				BUS_DATA_REG <= BUS_DATA_REG;
				case(BUS_ADDR[3:0])
					4'd0: begin                
						QEI_CLEAR_Reg [31:0] <= BUS_DATA [31:0];
					end                
			end        
			else begin //if ( BUS_read == 1'b1 )  
	   
				QEI_CLEAR_Reg <= QEI_CLEAR_Reg;


				case(BUS_ADDR[3:0])
					4'd0:
						BUS_DATA_REG[31:0] <= QEI_CLEAR_Reg[31:0];
					4'd1:
						BUS_DATA_REG[31:0] <= QEI_CH0_Read[31:0];
					4'd2:
						BUS_DATA_REG[31:0] <= QEI_CH1_Read[31:0];
					4'd3:
						BUS_DATA_REG[31:0] <= QEI_CH2_Read[31:0];
					4'd4:
						BUS_DATA_REG[31:0] <= QEI_CH3_Read[31:0];
					default:
						BUS_DATA_REG[31:0] <=32'xffffffff;
				endcase
			end
		end
	end


endmodule
