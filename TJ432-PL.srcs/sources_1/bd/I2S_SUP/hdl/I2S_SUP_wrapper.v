//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Fri Jul 20 19:16:32 2018
//Host        : DESKTOP-WHUT running 64-bit major release  (build 9200)
//Command     : generate_target I2S_SUP_wrapper.bd
//Design      : I2S_SUP_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module I2S_SUP_wrapper
   (FIFO_READ_0_empty,
    FIFO_READ_0_rd_data,
    FIFO_READ_0_rd_en,
    FIFO_WRITE_0_full,
    FIFO_WRITE_0_wr_data,
    FIFO_WRITE_0_wr_en,
    I2S_clk,
    clk_100MHz,
    prog_empty_0,
    rd_clk_0,
    rst_0,
    wr_clk_0);
  output FIFO_READ_0_empty;
  output [15:0]FIFO_READ_0_rd_data;
  input FIFO_READ_0_rd_en;
  output FIFO_WRITE_0_full;
  input [31:0]FIFO_WRITE_0_wr_data;
  input FIFO_WRITE_0_wr_en;
  output I2S_clk;
  input clk_100MHz;
  output prog_empty_0;
  input rd_clk_0;
  input rst_0;
  input wr_clk_0;

  wire FIFO_READ_0_empty;
  wire [15:0]FIFO_READ_0_rd_data;
  wire FIFO_READ_0_rd_en;
  wire FIFO_WRITE_0_full;
  wire [31:0]FIFO_WRITE_0_wr_data;
  wire FIFO_WRITE_0_wr_en;
  wire I2S_clk;
  wire clk_100MHz;
  wire prog_empty_0;
  wire rd_clk_0;
  wire rst_0;
  wire wr_clk_0;

  I2S_SUP I2S_SUP_i
       (.FIFO_READ_0_empty(FIFO_READ_0_empty),
        .FIFO_READ_0_rd_data(FIFO_READ_0_rd_data),
        .FIFO_READ_0_rd_en(FIFO_READ_0_rd_en),
        .FIFO_WRITE_0_full(FIFO_WRITE_0_full),
        .FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data),
        .FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en),
        .I2S_clk(I2S_clk),
        .clk_100MHz(clk_100MHz),
        .prog_empty_0(prog_empty_0),
        .rd_clk_0(rd_clk_0),
        .rst_0(rst_0),
        .wr_clk_0(wr_clk_0));
endmodule
