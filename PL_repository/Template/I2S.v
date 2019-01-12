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
    output DATA_CLK //LCRK对齐的下跳沿请求数据
    );
    
//CLK输入12MHZ
//MCLK CLK（8.4672M）1分频
//BSCK（CLK）12分频
//LCRK(BCLK)24分频

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

//从CLK（?M）8分频获得BSCK(24BIT)
reg [7:0] bsck_div = 8'd0;

always@( posedge CLK or negedge RST_n ) //产生BCLK
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
//从BCLK23分频获得LCRK并放数据、

always@ ( negedge BSCK or negedge RST_n ) //产生LRCK
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
            txd_reg <= i2s_data[8'd15 - bsck_cnt];//放数据
            i2s_data <= i2s_data ;
        end
        else if ( bsck_cnt == 8'd23 )//反转LCRK
        begin
            bsck_cnt <= 8'd0;
            lcrk_reg <= ~lcrk_reg;
            data_clk_reg <= 1'b0;   //上跳沿读取数据
            txd_reg <= 1'b0;          
            i2s_data <= data_input;
        end
        else//16-21
        begin
            bsck_cnt <= bsck_cnt + 8'd1;
            lcrk_reg <= lcrk_reg;
            data_clk_reg <= 1'b1;   //下跳沿请求数据，并保持
            txd_reg <= 1'b0;
            i2s_data <= i2s_data ;
        end
         
    end
end


endmodule