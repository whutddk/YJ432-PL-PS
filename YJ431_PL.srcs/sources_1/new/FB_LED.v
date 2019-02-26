`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WUT
// Engineer: WUT RUIGE LEE
// 
// Create Date: 2018/06/21 17:44:39
// Design Name: 
// Module Name: FB_BZLEDREG BZLED
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


module FB_BZLEDREG(
	RST_n,
	BUS_ADDR,
	BUS_DATA,
	BUS_CS,

	BUS_read,
	BUS_write,

	BZLED_BASE,

//Register
	FREQ_Cnt_Reg,	//��Ϊ����Ŀ�꣬�Լ��ⲿ����
	BZ_Puty_Reg,
	LEDR_Puty_Reg,
	LEDG_Puty_Reg,
	LEDB_Puty_Reg
    );


input RST_n;
input [31:0] BUS_ADDR;
inout [31:0] BUS_DATA;
input BUS_CS;

input BUS_read;
input BUS_write;

input [9:0]BZLED_BASE;

//Register
output reg [31:0] FREQ_Cnt_Reg = 32'd100000;	//��Ϊ����Ŀ�꣬�Լ��ⲿ����
output reg [31:0] BZ_Puty_Reg = 32'd1000000000;
output reg [31:0] LEDR_Puty_Reg = 32'd50000;
output reg [31:0] LEDG_Puty_Reg = 32'd50000;
output reg [31:0] LEDB_Puty_Reg = 32'd80000;



wire AD_TRI_n;//�Ǹ���״̬��־λ
wire ADD_COMF;
// reg AD_READ = 1'b0;
// assign AD_TRI = ~BUS_CS &

reg [31:0] BUS_DATA_REG = 32'b0;


assign ADD_COMF = ( BUS_ADDR[31:22] == BZLED_BASE[9:0] ) ? 1'b1:1'b0;	//��ַ�ٲ�

assign AD_TRI_n = ADD_COMF & ~BUS_CS & BUS_read ; //ʱ���߼��ж��Ƿ����÷Ǹ��裺ͬʱ����1��ַ��2Ƭѡ��3�ⲿ�����
//����Ǹ���̬��1 ��ַ�ٲ�ͨ�� 2 Ƭѡ��Ч 3 Ϊ�ⲿ�����?
//�������̬��1ƬѡʧЧ���� 2��ַʧЧ �ⲿ��д����ʧЧ��ȫ����?

assign BUS_DATA = AD_TRI_n ? BUS_DATA_REG : 32'bz;


//�Ĵ�����д
//����д��
always@( posedge BUS_CS or negedge RST_n )
	if ( !RST_n ) begin
		FREQ_Cnt_Reg <= 32'd1;
		BZ_Puty_Reg <= 32'b0;
		LEDR_Puty_Reg <= 32'b0;
		LEDG_Puty_Reg <= 32'b0;
		LEDB_Puty_Reg <= 32'b0;
	end
	else begin
		if ( ADD_COMF ) begin		//�ٲ�ͨ����
			if ( BUS_write == 1'b1 ) begin
				case(BUS_ADDR[21:0])
					22'b00000: begin				
                        FREQ_Cnt_Reg [31:0] <= BUS_DATA [31:0];
                        BZ_Puty_Reg   <= BZ_Puty_Reg;
                        LEDR_Puty_Reg <= LEDR_Puty_Reg;
                        LEDG_Puty_Reg <= LEDG_Puty_Reg;
                        LEDB_Puty_Reg <= LEDB_Puty_Reg;	
					end				
					22'b00100: begin
                        FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
                        BZ_Puty_Reg [31:0] <= BUS_DATA [31:0];
                        LEDR_Puty_Reg <= LEDR_Puty_Reg;
                        LEDG_Puty_Reg <= LEDG_Puty_Reg;
                        LEDB_Puty_Reg <= LEDB_Puty_Reg;
					end
					22'b01000: begin
                        FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
                        BZ_Puty_Reg   <= BZ_Puty_Reg;
                        if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //������ռ�ձȲ��ܴ���Ƶ�ʼ���
                            LEDR_Puty_Reg[31:0] <= BUS_DATA [31:0];
                        end
                        LEDG_Puty_Reg <= LEDG_Puty_Reg;
                        LEDB_Puty_Reg <= LEDB_Puty_Reg;
					end
					22'b01100: begin
                        FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
                        BZ_Puty_Reg   <= BZ_Puty_Reg;
                        LEDR_Puty_Reg <= LEDR_Puty_Reg;
                        if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //������ռ�ձȲ��ܴ���Ƶ�ʼ���
                            LEDG_Puty_Reg[31:0] <= BUS_DATA [31:0];
                        end
                        LEDB_Puty_Reg <= LEDB_Puty_Reg;
					end
					22'b10000: begin
                        FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
                        BZ_Puty_Reg   <= BZ_Puty_Reg;
                        LEDR_Puty_Reg <= LEDR_Puty_Reg;
                        LEDG_Puty_Reg <= LEDG_Puty_Reg;
                        if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //������ռ�ձȲ��ܴ���Ƶ�ʼ���
                            LEDB_Puty_Reg[31:0] <= BUS_DATA [31:0];
                        end
					end
				endcase
			end		
		end
	end

//�Ĵ���
//�������
always@( negedge BUS_CS or negedge RST_n )
	if ( !RST_n ) begin
		BUS_DATA_REG <= 32'b0;
	end

	else begin
		if ( ADD_COMF ) begin		//�ٲ�ͨ����
			if ( BUS_write == 1'b0 ) begin //if ( BUS_read == 1'b1 )  
				case(BUS_ADDR[21:0])
					22'b00000:
					BUS_DATA_REG [31:0] <= FREQ_Cnt_Reg [31:0];
					22'b00100:
					BUS_DATA_REG [31:0] <= BZ_Puty_Reg [31:0];
					22'b01000:
					BUS_DATA_REG [31:0] <= LEDR_Puty_Reg[31:0];
					22'b01100:
					BUS_DATA_REG [31:0] <= LEDG_Puty_Reg[31:0];
					22'b10000:
					BUS_DATA_REG [31:0] <= LEDB_Puty_Reg[31:0];
					default:
					BUS_DATA_REG[31:0] <=  32'hffffffff;
				endcase
			end
		end
	end

endmodule //FB_BZLEDREG



module BZLED(
	RST_n,
	CLK,
	FREQ_Cnt_Set,	//��Ϊ����Ŀ�꣬�Լ��ⲿ����
	BZ_Puty_Set,
	LEDR_Puty_Set,
	LEDG_Puty_Set,
	LEDB_Puty_Set,

	BZ,
	LED_R,
	LED_G,
	LED_B
	);

input RST_n;
input CLK;

input [31:0] FREQ_Cnt_Set;	//��Ϊ����Ŀ�꣬�Լ��ⲿ����
input [31:0] BZ_Puty_Set;
input [31:0] LEDR_Puty_Set;
input [31:0] LEDG_Puty_Set;
input [31:0] LEDB_Puty_Set;

output BZ;
output LED_R;
output LED_G;
output LED_B;

reg BZ_reg;
reg LED_R_reg;
reg LED_G_reg;
reg LED_B_reg;

assign BZ = BZ_reg;
assign LED_R = LED_R_reg;
assign LED_G = LED_G_reg;
assign LED_B = LED_B_reg;

//LED���Ʋ���
reg [31:0] LED_Cnt = 32'd0;

always @(posedge CLK or negedge RST_n) begin
	if ( !RST_n ) begin

		LED_Cnt <= 32'd0;

		LED_R_reg <= 1'b1;
		LED_G_reg <= 1'b1;
		LED_B_reg <= 1'b1;
	end
	else begin

		if ( LED_Cnt >= FREQ_Cnt_Set ) begin
			LED_Cnt <= 32'd0;
			
			LED_R_reg <= 1'b0;	//���߼�������?
			LED_G_reg <= 1'b0;
			LED_B_reg <= 1'b0;
		end
		else begin
			LED_Cnt <= LED_Cnt + 32'd1;

		end

		if ( LED_Cnt == LEDR_Puty_Set ) begin
			LED_R_reg <= 1'b1;
		end

		if ( LED_Cnt == LEDG_Puty_Set) begin
			LED_G_reg <= 1'b1;
		end

		if ( LED_Cnt == LEDB_Puty_Set ) begin
			LED_B_reg <= 1'b1;
		end
	end
end

//BZ ���������Ʋ���

reg [31:0] BZ_Cnt = 32'd0;

always@( posedge CLK or negedge RST_n ) begin
	if ( !RST_n ) begin
			BZ_Cnt <= 32'd0;
			BZ_reg <= 1'b0;
	end
	else begin
		if ( BZ_Cnt >= BZ_Puty_Set ) begin
			BZ_Cnt <= 32'd0;
			BZ_reg <= 1'd0;
		end
		else if ( BZ_Cnt == ( BZ_Puty_Set >> 1) ) begin	//50%ռ�ձ�	
			BZ_Cnt <= BZ_Cnt + 32'd1;
			BZ_reg <= 1'd1;
		end
		else begin
			BZ_Cnt <= BZ_Cnt + 32'd1;
			BZ_reg <= BZ_reg;
		end
		

	end
end




endmodule // BZLED

