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

	PWM_BASE,

//Register
	FREQ_Cnt_Reg,	//��Ϊ����Ŀ�꣬�Լ��ⲿ����
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

    input [9:0] PWM_BASE;

//Register
	output reg [31:0] FREQ_Cnt_Reg = 32'd10000;    //��Ϊ����Ŀ�꣬�Լ��ⲿ����
	output reg [31:0] CH0_duty_Reg = 32'd1 ;
	output reg [31:0] CH1_duty_Reg = 32'd1;
	output reg [31:0] CH2_duty_Reg = 32'd1;
	output reg [31:0] CH3_duty_Reg = 32'd1;
	output reg [31:0] CH4_duty_Reg;
	output reg [31:0] CH5_duty_Reg;
	output reg [31:0] CH6_duty_Reg;
	output reg [31:0] CH7_duty_Reg;
	
	wire AD_TRI_n;//�Ǹ���״̬��־λ
	wire ADD_COMF;
	// reg AD_READ = 1'b0;
	// assign AD_TRI = ~BUS_CS &
	
	reg [31:0] BUS_DATA_REG = 32'b0;
	
	assign ADD_COMF = ( BUS_ADDR[31:22] == PWM_BASE[9:0] ) ? 1'b1:1'b0;    //��ַ�ٲ� 
	assign AD_TRI_n = ADD_COMF & ~BUS_CS & BUS_read ; //ʱ���߼��ж��Ƿ����÷Ǹ��裺ͬʱ����1��ַ��2Ƭѡ��3�ⲿ�����
	//����Ǹ���̬��1 ��ַ�ٲ�ͨ�� 2 Ƭѡ��Ч 3 Ϊ�ⲿ�����?
	//�������̬��1ƬѡʧЧ���� 2��ַʧЧ �ⲿ��д����ʧЧ��ȫ����?
   
	assign BUS_DATA = AD_TRI_n ? BUS_DATA_REG : 32'bz;
   
   
//�Ĵ�����д
//�ⲿд��
always@( posedge BUS_CS or negedge RST_n )
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
        if ( ADD_COMF ) begin        //�ٲ�ͨ����
            if ( BUS_write == 1'b1 ) begin
                case(BUS_ADDR[5:0])
                    6'b000000: begin                
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
                    6'b000100: begin
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
                    6'b001000: begin
                        FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
                        CH0_duty_Reg <= CH0_duty_Reg;
                        if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //������ռ�ձȲ��ܴ���Ƶ�ʼ���
                            CH1_duty_Reg[31:0] <= BUS_DATA [31:0];
                        end
                        CH2_duty_Reg <= CH2_duty_Reg;
                        CH3_duty_Reg <= CH4_duty_Reg;   
                        CH4_duty_Reg <= CH4_duty_Reg;
                        CH5_duty_Reg <= CH5_duty_Reg;
                        CH6_duty_Reg <= CH6_duty_Reg;
                        CH7_duty_Reg <= CH7_duty_Reg;
                    end
                    
                    6'b001100: begin
                        FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
                        CH0_duty_Reg <= CH0_duty_Reg;
                        CH1_duty_Reg <= CH1_duty_Reg;
                        if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //������ռ�ձȲ��ܴ���Ƶ�ʼ���
                            CH2_duty_Reg[31:0] <= BUS_DATA [31:0];
                        end
                        CH3_duty_Reg <= CH4_duty_Reg;   
                        CH4_duty_Reg <= CH4_duty_Reg;
                        CH5_duty_Reg <= CH5_duty_Reg;
                        CH6_duty_Reg <= CH6_duty_Reg;
                        CH7_duty_Reg <= CH7_duty_Reg;
                    end
                           
                    6'b010000: begin
                        FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
                        CH0_duty_Reg <= CH0_duty_Reg;
                        CH1_duty_Reg <= CH1_duty_Reg;
                        CH2_duty_Reg <= CH2_duty_Reg;
                        if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //������ռ�ձȲ��ܴ���Ƶ�ʼ���
                            CH3_duty_Reg[31:0] <= BUS_DATA [31:0];
                        end
                        CH4_duty_Reg <= CH4_duty_Reg;
                        CH5_duty_Reg <= CH5_duty_Reg;
                        CH6_duty_Reg <= CH6_duty_Reg;
                        CH7_duty_Reg <= CH7_duty_Reg;
                    end
                           
                    6'b010100:begin
                        FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
                        CH0_duty_Reg <= CH0_duty_Reg;
                        CH1_duty_Reg <= CH1_duty_Reg;
                        CH2_duty_Reg <= CH2_duty_Reg; 
                        CH3_duty_Reg <= CH4_duty_Reg;
                        if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //������ռ�ձȲ��ܴ���Ƶ�ʼ���
                            CH4_duty_Reg[31:0] <= BUS_DATA [31:0];
                        end
                        CH5_duty_Reg <= CH5_duty_Reg;
                        CH6_duty_Reg <= CH6_duty_Reg;
                        CH7_duty_Reg <= CH7_duty_Reg;
                    end
                           
                    6'b011000:begin
                        FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
                        CH0_duty_Reg <= CH0_duty_Reg;
                        CH1_duty_Reg <= CH1_duty_Reg;
                        CH2_duty_Reg <= CH2_duty_Reg; 
                        CH3_duty_Reg <= CH4_duty_Reg;   
                        CH4_duty_Reg <= CH4_duty_Reg;
                        if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //������ռ�ձȲ��ܴ���Ƶ�ʼ���
                            CH5_duty_Reg[31:0] <= BUS_DATA [31:0];
                        end
                        CH6_duty_Reg <= CH6_duty_Reg;
                        CH7_duty_Reg <= CH7_duty_Reg;                    	
                    end
                           
                    6'b011100:begin
                        FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
                        CH0_duty_Reg <= CH0_duty_Reg;
                        CH1_duty_Reg <= CH1_duty_Reg;
                        CH2_duty_Reg <= CH2_duty_Reg; 
                        CH3_duty_Reg <= CH4_duty_Reg;   
                        CH4_duty_Reg <= CH4_duty_Reg;
                        CH5_duty_Reg <= CH5_duty_Reg;
                        if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //������ռ�ձȲ��ܴ���Ƶ�ʼ���
                            CH6_duty_Reg[31:0] <= BUS_DATA [31:0];
                        end
                        CH7_duty_Reg <= CH7_duty_Reg;
                    end
                           
                    6'b100000:begin 
                        FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
                        CH0_duty_Reg <= CH0_duty_Reg;
                        CH1_duty_Reg <= CH1_duty_Reg;
                        CH2_duty_Reg <= CH2_duty_Reg; 
                        CH3_duty_Reg <= CH4_duty_Reg;   
                        CH4_duty_Reg <= CH4_duty_Reg;
                        CH5_duty_Reg <= CH5_duty_Reg;
                        CH6_duty_Reg <= CH6_duty_Reg;
                        if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //������ռ�ձȲ��ܴ���Ƶ�ʼ���
                            CH7_duty_Reg[31:0] <= BUS_DATA [31:0];
                        end 
                    end
                endcase
            end        
        end
    end

//�Ĵ�����д
//�ⲿ����
always@( negedge BUS_CS or negedge RST_n )
    if ( !RST_n ) begin
        BUS_DATA_REG <= 32'b0;
    end
    
    else begin
        if ( ADD_COMF ) begin        //�ٲ�ͨ����
            if ( BUS_read == 1'b1 ) begin
                case(BUS_ADDR[5:0])
                    6'b000000:
                        BUS_DATA_REG[31:0] <= FREQ_Cnt_Reg[31:0];
                    6'b000100:
                        BUS_DATA_REG[31:0] <= CH0_duty_Reg[31:0];
                    6'b001000:
                        BUS_DATA_REG[31:0] <= CH1_duty_Reg[31:0];
                    6'b001100:
                        BUS_DATA_REG[31:0] <= CH2_duty_Reg[31:0];
                    6'b010000:
                        BUS_DATA_REG[31:0] <= CH3_duty_Reg[31:0];
                    6'b010100:
                        BUS_DATA_REG[31:0] <= CH4_duty_Reg[31:0];
                    6'b011000:
                        BUS_DATA_REG[31:0] <= CH5_duty_Reg[31:0];
                    6'b011100:
                        BUS_DATA_REG[31:0] <= CH6_duty_Reg[31:0];
                    6'b100000:
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
	FREQ_Cnt_Set,	//��Ϊ����Ŀ�꣬�Լ��ⲿ����
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
input [31:0] FREQ_Cnt_Set;	//��Ϊ����Ŀ�꣬�Լ��ⲿ����
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


		if ( pwm_cnt >= FREQ_Cnt_Set) begin	//����
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
//ռ�ձ�
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





