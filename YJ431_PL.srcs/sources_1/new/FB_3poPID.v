`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WUT
// Engineer: WUT RUIGE LEE
// 
// Create Date: 2018/06/21 17:44:39
// Design Name: 
// Module Name: FB_po3PID
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


module FB_po3PIDREG(
	RST_n,
	BUS_ADDR,
	BUS_DATA,
	BUS_CS,

	BUS_read,
	BUS_write,

	po3PID_BASE,

//Register
	CTL_FREQ_REG,
	PID_AIM_REG,
	PID_CUR_REG,

	PID_ERS_REG,
	PID_KPS_REG,
	PID_KIS_REG,
	PID_KDS_REG,

	PID_ERM_REG,
	PID_KPM_REG,
	PID_KIM_REG,
	PID_KDM_REG,

	PID_ERB_REG,
	PID_KPB_REG,
	PID_KIB_REG,
	PID_KDB_REG,

	PID_OUT_REG
    );
endmodule


	input RST_n;
    input [31:0] BUS_ADDR;
    inout [31:0] BUS_DATA;
    input BUS_CS;

    input BUS_read;
    input BUS_write;

    input [9:0] po3PID_BASE;

//Register
	output reg CTL_FREQ_REG;
	output reg PID_AIM_REG;
	output reg PID_CUR_REG;

	output reg PID_ERS_REG;
	output reg PID_KPS_REG;
	output reg PID_KIS_REG;
	output reg PID_KDS_REG;

	output reg PID_ERM_REG;
	output reg PID_KPM_REG;
	output reg PID_KIM_REG;
	output reg PID_KDM_REG;

	output reg PID_ERB_REG;
	output reg PID_KPB_REG;
	output reg PID_KIB_REG;
	output reg PID_KDB_REG;

	input PID_OUT_REG;
	
	wire AD_TRI_n;//非高阻状态标志位
	wire ADD_COMF;
	
	reg [31:0] BUS_DATA_REG = 32'b0;
	
	assign ADD_COMF = ( BUS_ADDR[31:22] == PWM_BASE[9:0] ) ? 1'b1:1'b0;    //地址仲裁 
	assign AD_TRI_n = ADD_COMF & ~BUS_CS & BUS_read ; //时序逻辑判断是否设置非高阻：同时满足1地址，2片选，3外部请求读
	//进入非高阻态：1 地址仲裁通过 2 片选有效 3 为外部请求读?
	//脱离高阻态：1片选失效脱离 2地址失效 外部读写请求失效安全脱离?
   
	assign BUS_DATA = AD_TRI_n ? BUS_DATA_REG : 32'bz;
    
//寄存器读写
//外部写入
always@( posedge BUS_CS or negedge RST_n )
    if ( !RST_n ) begin
		CTL_FREQ_REG <= 32'd0;
		PID_AIM_REG <= 32'd0;
		PID_CUR_REG <= 32'd0;

		PID_ERS_REG <= 32'd0;
		PID_KPS_REG <= 32'd0;
		PID_KIS_REG <= 32'd0;
		PID_KDS_REG <= 32'd0;

		PID_ERM_REG <= 32'd0;
		PID_KPM_REG <= 32'd0;
		PID_KIM_REG <= 32'd0;
		PID_KDM_REG <= 32'd0;

		PID_ERB_REG <= 32'd0;
		PID_KPB_REG <= 32'd0;
		PID_KIB_REG <= 32'd0;
		PID_KDB_REG <= 32'd0;
    end
    
    else begin
        if ( ADD_COMF ) begin        //仲裁通过
            if ( BUS_write == 1'b1 ) begin
                case(BUS_ADDR[6:0])
                    7'b0000000: begin                
						CTL_FREQ_REG [31:0] <= BUS_DATA [31:0];
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end                
                    7'b0000100: begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG [31:0] <= BUS_DATA [31:0];
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end
                    7'b0001000: begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG [31:0] <= BUS_DATA [31:0];

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end
                    
                    7'b0001100: begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG [31:0] <= BUS_DATA [31:0];
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end
                           
                    7'b0010000: begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG [31:0] <= BUS_DATA [31:0];
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end
                           
                    7'b0010100:begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG [31:0] <= BUS_DATA [31:0];
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end
                           
                    7'b0011000:begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG [31:0] <= BUS_DATA [31:0];

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;                   	
                    end
                           
                    6'b011100:begin
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
                           
                    6'b100000:begin 
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
        end
    end

//寄存器读写
//外部读出
always@( negedge BUS_CS or negedge RST_n )
    if ( !RST_n ) begin
        BUS_DATA_REG <= 32'b0;
    end
    
    else begin
        if ( ADD_COMF ) begin        //仲裁通过
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


