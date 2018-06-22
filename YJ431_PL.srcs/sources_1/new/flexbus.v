`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/18 17:17:54
// Design Name: 
// Module Name: ip_flexbus
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

/*

地址映射表：

起始：0x6000,0000

IP码选[27:22]:MASK:0x0FC0,0000;支持64个IP每个IP可以寻址2MB
仲裁所有高位[31:22] 10'b MAST:0xFFC0,0000

BZLED： 0x00
SWKEY : 0x01
PWM:0x02,0x03,0x04,0x05
QEI:0x06,0x07,0x08,0x09
TCI:0x0a,0x0b
SARM:0X0c
3po_PID:0x0d,0x0e,0x0f,0x10,
3in_PID:0x11,0x12,x013,0x14,
XADC:0X15:0X15

*/


module ip_flexbus(
    input FB_CLK,
    input RST_n,
    input FB_OE,
    input FB_RW,
    input FB_CS,
    input FB_ALE,
//    input FB_BE31_24,
//    input FB_BE23_16,
//    input FB_BE15_8,
//    input FB_BE7_0,
    inout [31:0] FB_AD,
    
    output [31:0] ip_ADDR,
    inout [31:0] ip_DATA,

    output ip_Read,
    output ip_Write
    );
    
reg ip_Read_reg = 1'b0;
reg ip_Write_reg = 1'b0;
reg [31:0] ip_ADDR_reg = 32'b0;
reg [31:0] FB_AD_reg = 32'b0;
reg [31:0] ip_DATA_reg = 32'b0;
//reg FB_AD_TRI = 1'b1; //Flexbus鎬荤嚎楂橀樆鏍囧織

        


assign ip_ADDR[31:0] = ip_ADDR_reg[31:0];    


assign FB_AD[31:0] = ( FB_RW == 1'b1 && FB_ALE == 1'b0 ) ?  FB_AD_reg[31:0] : 32'bz ;//外部读PL内容则输出，外部写入则高阻
assign ip_DATA[31:0] = ( FB_RW == 1'b1 && FB_ALE == 1'b0 ) ? 32'bz  : ip_DATA_reg[31:0];
   
   
assign ip_Read = ip_Read_reg;
assign ip_Write = ip_Write_reg;


always@( negedge FB_CLK or negedge RST_n )
    if ( !RST_n )
    { ip_Read_reg,ip_Write_reg} <= { 1'b0,1'b0 };
    
    else 
    
        begin
        if ( FB_RW == 1'b0 )
            { ip_Read_reg,ip_Write_reg } <= { 1'b0,1'b1 };
        else
            { ip_Read_reg,ip_Write_reg } <= { 1'b1,1'b0 };
       
        if ( FB_ALE == 1'b1 )  //地址锁存有效
        begin 
             ip_ADDR_reg[31:0] <= FB_AD[31:0];//放入地址进行锁存
        end
    
        else if ( FB_CS == 1'b0 )
        begin
            if( FB_RW == 1'b1  ) //从其他IP读入数据，从FB输出
            begin
                FB_AD_reg[31:0] <= ip_DATA [31:0];      //不直通，多拍一下
            end
            else if ( FB_RW == 1'b0 )    //FB输入，写入到其他IP
            begin
                ip_DATA_reg[31:0] <= FB_AD[31:0];       //不直通，多拍一下
            end
        end
    end
    
    
    
    
endmodule


