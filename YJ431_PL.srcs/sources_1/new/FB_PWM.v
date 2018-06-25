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
                           
                           if ( BUS_DATA [31:0] < FREQ_Cnt_Reg ) begin
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
                           FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
                           BZ_Puty_Reg   <= BZ_Puty_Reg;
                           LEDR_Puty_Reg <= LEDR_Puty_Reg;
                           if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护：占空比不能大于频率计数
                               LEDG_Puty_Reg[31:0] <= BUS_DATA [31:0];
                           end
                           LEDB_Puty_Reg <= LEDB_Puty_Reg;
                       end
                       4'd4: begin
                           FREQ_Cnt_Reg  <= FREQ_Cnt_Reg;
                           BZ_Puty_Reg   <= BZ_Puty_Reg;
                           LEDR_Puty_Reg <= LEDR_Puty_Reg;
                           LEDG_Puty_Reg <= LEDG_Puty_Reg;
                           if ( BUS_DATA [31:0] < FREQ_Cnt_Reg [31:0] ) begin //保护：占空比不能大于频率计数
                               LEDB_Puty_Reg[31:0] <= BUS_DATA [31:0];
                           end
                       end
                   endcase
               end        
               else begin //if ( BUS_read == 1'b1 )  
   
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
               end
           end
       end
    
    
    
    
    
endmodule