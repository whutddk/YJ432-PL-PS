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

	QEI_BASE,

//Register
	QEI_CLEAR_Reg,	//是否清零?
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

input [9:0] QEI_BASE;

output reg [31:0] QEI_CLEAR_Reg = 32'd0;	//读完是否清零?
input [31:0] QEI_CH0_Read;	//只读寄存器
input [31:0] QEI_CH1_Read;
input [31:0] QEI_CH2_Read;
input [31:0] QEI_CH3_Read;

wire AD_TRI_n;//非高阻状态标志位
wire ADD_COMF;

reg [31:0] BUS_DATA_REG = 32'b0;

assign ADD_COMF = ( BUS_ADDR[31:22] == QEI_BASE[9:0] ) ? 1'b1:1'b0;    //地址仲裁  
assign AD_TRI_n = ADD_COMF & ~BUS_CS & BUS_read ; //时序逻辑判断是否设置非高阻：同时满足1地址，2片选，3外部请求读
//进入非高阻态：1 地址仲裁通过 2 片选有效 3 为外部请求读?
//脱离高阻态：1片选失效脱离 2地址失效 外部读写请求失效安全脱离?

assign BUS_DATA = AD_TRI_n ? BUS_DATA_REG : 32'bz;

//寄存器读写
//外部写入 
always@( posedge BUS_CS or negedge RST_n )
if ( !RST_n ) begin
	QEI_CLEAR_Reg <= 32'd0;
end

else begin
	if ( ADD_COMF && BUS_write == 1'b1) begin        //仲裁通过且为写
        case(BUS_ADDR[5:0])
            5'b00000: begin
                QEI_CLEAR_Reg [31:0] <= BUS_DATA [31:0];
            end
        endcase
	end
end

//寄存器读写
//外部读出
always@( negedge BUS_CS or negedge RST_n )
if ( !RST_n ) begin

end

else begin
	if ( ADD_COMF && BUS_write == 1'b0) begin         //仲裁通过
        case(BUS_ADDR[4:0])
            5'b00000:
                BUS_DATA_REG[31:0] <= QEI_CLEAR_Reg[31:0];
            5'b00100:
                BUS_DATA_REG[31:0] <= QEI_CH0_Read[31:0];
            5'b01000:
                BUS_DATA_REG[31:0] <= QEI_CH1_Read[31:0];
            5'b01100:
                BUS_DATA_REG[31:0] <= QEI_CH2_Read[31:0];
            5'b10000:
                BUS_DATA_REG[31:0] <= QEI_CH3_Read[31:0];
            default:
                BUS_DATA_REG[31:0] <=32'hffffffff;
        endcase
	end
end


endmodule


module QEI(

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


