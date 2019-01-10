//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Thu Aug  9 18:09:17 2018
//Host        : DESKTOP-WHUT running 64-bit major release  (build 9200)
//Command     : generate_target I2S_SUP.bd
//Design      : I2S_SUP
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "I2S_SUP,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=I2S_SUP,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_board_cnt=1,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "I2S_SUP.hwdef" *) 
module I2S_SUP
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
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 EMPTY" *) output FIFO_READ_0_empty;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 RD_DATA" *) output [15:0]FIFO_READ_0_rd_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 RD_EN" *) input FIFO_READ_0_rd_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 FULL" *) output FIFO_WRITE_0_full;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 WR_DATA" *) input [15:0]FIFO_WRITE_0_wr_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 WR_EN" *) input FIFO_WRITE_0_wr_en;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.I2S_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.I2S_CLK, CLK_DOMAIN /clk_wiz_0_clk_out1, FREQ_HZ 16934404, PHASE 0.0" *) output I2S_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, CLK_DOMAIN I2S_SUP_clk_100MHz, FREQ_HZ 100000000, PHASE 0.000" *) input clk_100MHz;
  output prog_empty_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.RD_CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.RD_CLK_0, CLK_DOMAIN I2S_SUP_rd_clk_0, FREQ_HZ 100000000, PHASE 0.000" *) input rd_clk_0;
  input rst_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.WR_CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.WR_CLK_0, CLK_DOMAIN I2S_SUP_wr_clk_0, FREQ_HZ 100000000, PHASE 0.000" *) input wr_clk_0;

  wire FIFO_READ_0_1_EMPTY;
  wire [15:0]FIFO_READ_0_1_RD_DATA;
  wire FIFO_READ_0_1_RD_EN;
  wire FIFO_WRITE_0_1_FULL;
  wire [15:0]FIFO_WRITE_0_1_WR_DATA;
  wire FIFO_WRITE_0_1_WR_EN;
  wire clk_100MHz_1;
  wire clk_wiz_0_clk_out1;
  wire fifo_generator_0_prog_empty;
  wire rd_clk_0_1;
  wire rst_0_1;
  wire wr_clk_0_1;

  assign FIFO_READ_0_1_RD_EN = FIFO_READ_0_rd_en;
  assign FIFO_READ_0_empty = FIFO_READ_0_1_EMPTY;
  assign FIFO_READ_0_rd_data[15:0] = FIFO_READ_0_1_RD_DATA;
  assign FIFO_WRITE_0_1_WR_DATA = FIFO_WRITE_0_wr_data[15:0];
  assign FIFO_WRITE_0_1_WR_EN = FIFO_WRITE_0_wr_en;
  assign FIFO_WRITE_0_full = FIFO_WRITE_0_1_FULL;
  assign I2S_clk = clk_wiz_0_clk_out1;
  assign clk_100MHz_1 = clk_100MHz;
  assign prog_empty_0 = fifo_generator_0_prog_empty;
  assign rd_clk_0_1 = rd_clk_0;
  assign rst_0_1 = rst_0;
  assign wr_clk_0_1 = wr_clk_0;
  I2S_SUP_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_100MHz_1),
        .clk_out1(clk_wiz_0_clk_out1));
  I2S_SUP_fifo_generator_0_0 fifo_generator_0
       (.din(FIFO_WRITE_0_1_WR_DATA),
        .dout(FIFO_READ_0_1_RD_DATA),
        .empty(FIFO_READ_0_1_EMPTY),
        .full(FIFO_WRITE_0_1_FULL),
        .prog_empty(fifo_generator_0_prog_empty),
        .rd_clk(rd_clk_0_1),
        .rd_en(FIFO_READ_0_1_RD_EN),
        .rst(rst_0_1),
        .wr_clk(wr_clk_0_1),
        .wr_en(FIFO_WRITE_0_1_WR_EN));
endmodule
