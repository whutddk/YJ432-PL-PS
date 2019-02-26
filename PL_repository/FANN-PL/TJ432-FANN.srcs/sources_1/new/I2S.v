`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan University of Technology 
// Engineer: Ruige Lee
// 
// Create Date: 2018/02/02 16:02:17
// Design Name: 
// Module Name: I2S16bit
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


module I2S16bit(
    input CLK,
    input RST, 
    input [7:0] data_input,
//    output ready,

    output LCRK,
    output BSCK,
    output TXD,
    output DATA_CLK //LCRK�������������������
    );
    
//CLK����12MHZ
//MCLK CLK��8.4672M��1��Ƶ
//BSCK��CLK��12��Ƶ
//LCRK(BCLK)24��Ƶ

reg mclk_reg = 1'b1;
reg bsck_reg = 1'b1;
reg lcrk_reg = 1'b1;
reg txd_reg = 1'b0;
reg [7:0] i2s_data = 8'b0; 
reg data_clk_reg = 1'b0;


//assign MCLK = mclk_reg;
assign BSCK = bsck_reg;
assign LCRK = lcrk_reg;
assign TXD = txd_reg;

//assign ready = lcrk_reg;
assign DATA_CLK = data_clk_reg;

//��CLK��?M��4��Ƶ���BSCK(24BIT)
reg [7:0] bsck_div = 8'd0;

always@( posedge CLK ) //����BCLK
begin
    if ( !RST )
    begin
        bsck_div <= 8'd0;
        bsck_reg <= 1'b1;
    end
    else
    begin
        if ( bsck_div == 8'd1 )
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

always@ ( negedge BSCK ) //����LRCK
begin
    if ( !RST )
    begin
        bsck_cnt <= 8'd0;
        lcrk_reg <= 1'b1;
        txd_reg <= 1'b0;
        data_clk_reg <= 1'b0;
    end
    else
    begin
        if ( bsck_cnt < 8'd8 ) //0-7
        begin
            bsck_cnt <= bsck_cnt + 8'd1;    
            lcrk_reg <= lcrk_reg;
            data_clk_reg <= 1'b0;
            txd_reg <= i2s_data[8'd7 - bsck_cnt];//������
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
        else//8-21
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