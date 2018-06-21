`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WUT
// Engineer: WUT RUIGE LEE
// 
// Create Date: 2018/06/21 17:44:39
// Design Name: 
// Module Name: FB_BZLED
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


module FB_BZLED(
	RST_n,
	CLK,
	BUS_ADDR,
	BUS_DATA,
	BUS_CS,

	BUS_read,
	BUS_write,

	BZLED_BASE,

	BZ,
	LED_R,
	LED_G,
	LED_B,
    );


input RST_n;
input CLK;
input [31:0] BUS_ADDR;
inout [31:0] BUS_DATA;
input BUS_CS;

input BUS_read;
input BUS_write;

input reg [9:0]BZLED_BASE;

output BZ;
output LED_R;
output LED_G;
output LED_B;


reg BZ_reg = 1'b0;
reg LED_R_reg = 1'b1;
reg LED_G_reg = 1'b1;
reg LED_B_reg = 1'b1;

wire AD_TRI_n;//非高阻标志位
wire ADD_COMF;
// reg AD_READ = 1'b0;
// assign AD_TRI = ~BUS_CS &

reg [31:0] BUS_DATA_REG = 32'b0;

//Register
reg [31:0] FREQ_Cnt_Reg;	//还是搞成分批计数吧
reg [31:0] BZ_Puty_Reg;
reg [31:0] LEDR_Puty_Reg;
reg [31:0] LEDG_Puty_Reg;
reg [31:0] LEDB_Puty_Reg;

assign ADD_COMF = ( BUS_ADDR[31:22] == BZLED_BASE[9:0] ) ? 1'b1:1'b0;	//用组合逻辑仲裁地址

assign AD_TRI_n = ADD_COMF & ~BUS_CS & BUS_read ; //要产生非高阻,必须同时满足三个条件
//进入非高阻：1地址仲裁通过，外部要读信号有效，2片选到来
//脱离非高阻态：1片选失效，摆脱，2地址失效，安全脱离

assign BUS_DATA = AD_TRI_n ? BUS_DATA_REG : 32'bz;


//读写寄存器
always@( negedge BUS_CS or negedge RST_n )
	if ( !RST_n ) begin
		FREQ_Cnt_Reg <= 32'd1;
		BZ_Puty_Reg <= 32'b0;
		LEDR_Puty_Reg <= 32'b0;
		LEDG_Puty_Reg <= 32'b0;
		LEDB_Puty_Reg <= 32'b0;
		// AD_TRI <= 1'b1;
		BUS_DATA_REG <= 32'b0;
	end

	else begin
		if ( ADD_COMF ) begin		//仲裁
			if ( BUS_write == 1'b1 ) begin
				BUS_DATA_REG <= BUS_DATA_REG;
				case(BUS_ADDR[3:0])
					4'd0:
					FREQ_Cnt_Reg [31:0] <= BUS_DATA [31:0];
					BZ_Puty_Reg   <= BZ_Puty_Reg;
					LEDR_Puty_Reg <= LEDR_Puty_Reg;
					LEDG_Puty_Reg <= LEDG_Puty_Reg;
					LEDB_Puty_Reg <= LEDB_Puty_Reg;					
					4'd1:
					FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
					BZ_Puty_Reg [31:0] <= BUS_DATA [31:0];
					LEDR_Puty_Reg <= LEDR_Puty_Reg;
					LEDG_Puty_Reg <= LEDG_Puty_Reg;
					LEDB_Puty_Reg <= LEDB_Puty_Reg;
					4'd2:
					FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
					BZ_Puty_Reg   <= BZ_Puty_Reg;
					if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护占空比不大于频率计数
						LEDR_Puty_Reg[31:0] <= BUS_DATA [31:0];
					end
					LEDG_Puty_Reg <= LEDG_Puty_Reg;
					LEDB_Puty_Reg <= LEDB_Puty_Reg;
					4'd3:
					FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
					BZ_Puty_Reg   <= BZ_Puty_Reg;
					LEDR_Puty_Reg <= LEDR_Puty_Reg;
					if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护占空比不大于频率计数
						LEDG_Puty_Reg[31:0] <= BUS_DATA [31:0];
					end
					LEDB_Puty_Reg <= LEDB_Puty_Reg;
					4'd4:
					FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
					BZ_Puty_Reg   <= BZ_Puty_Reg;
					LEDR_Puty_Reg <= LEDR_Puty_Reg;
					LEDG_Puty_Reg <= LEDG_Puty_Reg;
					if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护占空比不大于频率计数
						LEDB_Puty_Reg[31:0] <= BUS_DATA [31:0];
					end
				endcase
			end		
			else begin //if ( BUS_read == 1'b1 )  

				// AD_TRI = 1'b0;
				FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
				BZ_Puty_Reg   <= BZ_Puty_Reg;
				LEDR_Puty_Reg <= LEDR_Puty_Reg;
				LEDG_Puty_Reg <= LEDG_Puty_Reg;
				LEDB_Puty_Reg <= LEDB_Puty_Reg;

				case(BUS_ADDR[3:0])
					4'd0:
					BUS_DATA_REG [31:0] = FREQ_Cnt_Reg [31:0];
					4'd1:
					BUS_DATA_REG [31:0] = BZ_Puty_Reg [31:0];
					4'd2:
					BUS_DATA_REG [31:0] = LEDR_Puty_Reg[31:0];
					4'd3:
					BUS_DATA_REG [31:0] = LEDG_Puty_Reg[31:0];
					4'd4:
					BUS_DATA_REG [31:0] = LEDB_Puty_Reg[31:0];
				endcase
				// AD_TRI = 1'b1;
			end
		end
	end

//时钟分频信号发生器
reg [31:0] RED_Cnt = 32'd0;
reg [31:0] GREEN_Cnt = 32'd0;
reg [31:0] BLUE_Cnt = 32'd0;


always @(posedge CLK or negedge RST_n) begin
	if ( !RST_n ) begin

		RED_Cnt <= 32'd0;
		GREEN_Cnt <= 32'd0;
		BLUE_Cnt <= 32'd0;

		LED_R_reg <= 1'b1;
		LED_G_reg <= 1'b1;
		LED_B_reg <= 1'b1;
	end
	else begin

		if ( RED_Cnt == FREQ_Cnt_Reg ) begin
			RED_Cnt <= 32'd0;
			GREEN_Cnt <= 32'd0;
			BLUE_Cnt <= 32'd0;

			LED_R_reg <= 1'b0;	//负逻辑，点亮
			LED_G_reg <= 1'b0;
			LED_B_reg <= 1'b0;
		end
		else begin
			RED_Cnt 	<= RED_Cnt + 32'd1;
			GREEN_Cnt 	<= GREEN_Cnt + 32'd1;
			BLUE_Cnt 	<= BLUE_Cnt + 32'd1;
		end

		if ( RED_Cnt == LEDR_Puty_Reg ) begin
			LED_R_reg <= 1'b1;
		end

		if ( GREEN_Cnt == LEDG_Puty_Reg) begin
			LED_G_reg <= 1'b1;
		end

		if ( BLUE_Cnt == LEDB_Puty_Reg ) begin
			LED_B_reg <= 1'b1;
		end
	end
end

//BZ

reg [31:0] BZ_Cnt = 32'd0;

always@( posedge CLK or negedge RST_n ) begin
	if ( !RST_n ) begin
			BZ_Cnt <= 32'd0;
			BZ_reg <= 1'b0;
	end
	else begin
		if ( BZ_Cnt == BZ_Puty_Reg ) begin
			BZ_Cnt <= 32'd0;
			BZ_reg <= 1'd0;
		end
		else if ( BZ_Cnt == ( BZ_Puty_Reg >> 2) ) begin	//50%占空比	
			BZ_Cnt <= BZ_Cnt + 32'd1;
			BZ_reg <= 1'd1;
		end
		else begin
			BZ_Cnt <= BZ_Cnt + 32'd1;
			BZ_reg <= BZ_reg;
		end
		

	end
end



endmodule