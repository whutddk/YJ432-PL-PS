//////////////////////////////////////////////////////////////////////////////////
// Company:  Wuhan University of Technology  
// Engineer: Ruige Lee
// Create Date: 2018/02/02 16:02:17
// Last Modified by:   WUT_Ruige_Lee
// Last Modified time: 2019-01-12 16:21:06
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: I2S
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


module I2S16bit(
    input CLK,
    input RST_n, 
    input [15:0] data_input,

    output MCLK,
    output LCRK,
    output BSCK,
    output TXD,
    output DATA_CLK //LCRK�������������������
    );
    
//CLK����12MHZ
//MCLK CLK��8.4672M��1��Ƶ
//BSCK��CLK��12��Ƶ
//LCRK(BCLK)24��Ƶ

reg bsck_reg = 1'b1;
reg lcrk_reg = 1'b1;
reg txd_reg = 1'b0;
reg [15:0] i2s_data = 16'b0; 
reg data_clk_reg = 1'b0;


assign MCLK = CLK;
assign BSCK = bsck_reg;
assign LCRK = lcrk_reg;
assign TXD = txd_reg;

//assign ready = lcrk_reg;
assign DATA_CLK = data_clk_reg;

//��CLK��?M��8��Ƶ���BSCK(24BIT)
reg [7:0] bsck_div = 8'd0;

always@( posedge CLK or negedge RST_n ) //����BCLK
begin
    if ( !RST_n )
    begin
        bsck_div <= 8'd0;
        bsck_reg <= 1'b1;
    end
    else
    begin
        if ( bsck_div == 8'd3 )
        begin
            bsck_div <= 8'd0;
            bsck_reg <= ~bsck_reg;
        end
        else
        begin
            bsck_div <= bsck_div + 8'd1;
            bsck_reg <= bsck_reg;
        end
    end
end

reg [7:0] bsck_cnt = 8'd0; 
//��BCLK23��Ƶ���LCRK�������ݡ�

always@ ( negedge BSCK or negedge RST_n ) //����LRCK
begin
    if ( !RST_n )
    begin
        bsck_cnt <= 8'd0;
        lcrk_reg <= 1'b1;
        txd_reg <= 1'b0;
        data_clk_reg <= 1'b0;

        i2s_data <= 16'd0;
    end
    else
    begin
        if ( bsck_cnt < 8'd16 ) //0-15
        begin
            bsck_cnt <= bsck_cnt + 8'd1;    
            lcrk_reg <= lcrk_reg;
            data_clk_reg <= 1'b0;
            txd_reg <= i2s_data[8'd15 - bsck_cnt];//������
            i2s_data <= i2s_data ;
        end
        else if ( bsck_cnt == 8'd23 )//��תLCRK
        begin
            bsck_cnt <= 8'd0;
            lcrk_reg <= ~lcrk_reg;
            data_clk_reg <= 1'b0;   //�����ض�ȡ����
            txd_reg <= 1'b0;          
            i2s_data <= data_input;
        end
        else//16-21
        begin
            bsck_cnt <= bsck_cnt + 8'd1;
            lcrk_reg <= lcrk_reg;
            data_clk_reg <= 1'b1;   //�������������ݣ�������
            txd_reg <= 1'b0;
            i2s_data <= i2s_data ;
        end
         
    end
end


endmodule