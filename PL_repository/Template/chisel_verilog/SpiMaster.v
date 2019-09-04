module SpiMaster( // @[:@3.2]
  input        clock, // @[:@4.4]
  input        reset, // @[:@5.4]
  input        io_ctl, // @[:@6.4]
  input  [7:0] io_dataTxd, // @[:@6.4]
  output [7:0] io_dataRxd, // @[:@6.4]
  output       io_SCK, // @[:@6.4]
  input        io_MISO, // @[:@6.4]
  output       io_MOSI, // @[:@6.4]
  output       io_CSn // @[:@6.4]
);
  reg [5:0] value; // @[Counter.scala 26:33:@8.4]
  reg [31:0] _RAND_0;
  wire  fullCnt; // @[Counter.scala 34:24:@10.6]
  wire [6:0] _T_25; // @[Counter.scala 35:22:@11.6]
  wire [5:0] _T_26; // @[Counter.scala 35:22:@12.6]
  wire [5:0] _GEN_0; // @[Counter.scala 37:21:@14.6]
  reg  preFullCnt; // @[spiMaster.scala 84:33:@19.4]
  reg [31:0] _RAND_1;
  wire  _T_36; // @[spiMaster.scala 88:66:@25.4]
  wire  cntPosedge; // @[spiMaster.scala 88:51:@26.4]
  reg  SCK_Reg; // @[spiMaster.scala 89:30:@28.4]
  reg [31:0] _RAND_2;
  wire  SCK_Wire; // @[spiMaster.scala 92:21:@30.4]
  wire  _GEN_2; // @[spiMaster.scala 96:27:@32.4]
  reg  preSCK; // @[spiMaster.scala 104:29:@38.4]
  reg [31:0] _RAND_3;
  wire  _T_48; // @[spiMaster.scala 109:31:@44.4]
  wire  SCKPosedge; // @[spiMaster.scala 109:44:@47.4]
  reg [2:0] byteCnt; // @[spiMaster.scala 111:30:@49.4]
  reg [31:0] _RAND_4;
  reg  MOSI_Reg; // @[spiMaster.scala 112:31:@50.4]
  reg [31:0] _RAND_5;
  reg [7:0] dataRxd_Reg; // @[spiMaster.scala 113:34:@51.4]
  reg [31:0] _RAND_6;
  reg  CSn_Reg; // @[spiMaster.scala 114:30:@52.4]
  reg [31:0] _RAND_7;
  wire [3:0] _T_63; // @[spiMaster.scala 117:32:@54.4]
  wire [2:0] byteCntNext; // @[spiMaster.scala 117:32:@55.4]
  wire  _T_65; // @[spiMaster.scala 120:22:@58.6]
  wire [8:0] _GEN_11; // @[spiMaster.scala 127:53:@66.8]
  wire [8:0] _T_70; // @[spiMaster.scala 127:53:@66.8]
  wire [8:0] _GEN_12; // @[spiMaster.scala 127:59:@67.8]
  wire [8:0] _T_71; // @[spiMaster.scala 127:59:@67.8]
  wire [7:0] _T_72; // @[spiMaster.scala 128:48:@69.8]
  wire  _T_73; // @[spiMaster.scala 128:48:@70.8]
  wire [2:0] _GEN_3; // @[spiMaster.scala 120:30:@59.6]
  wire  _GEN_4; // @[spiMaster.scala 120:30:@59.6]
  wire [8:0] _GEN_5; // @[spiMaster.scala 120:30:@59.6]
  wire [2:0] _GEN_7; // @[spiMaster.scala 119:25:@57.4]
  wire  _GEN_8; // @[spiMaster.scala 119:25:@57.4]
  wire [8:0] _GEN_9; // @[spiMaster.scala 119:25:@57.4]
  wire  _GEN_10; // @[spiMaster.scala 119:25:@57.4]
  assign fullCnt = value == 6'h31; // @[Counter.scala 34:24:@10.6]
  assign _T_25 = value + 6'h1; // @[Counter.scala 35:22:@11.6]
  assign _T_26 = value + 6'h1; // @[Counter.scala 35:22:@12.6]
  assign _GEN_0 = fullCnt ? 6'h0 : _T_26; // @[Counter.scala 37:21:@14.6]
  assign _T_36 = preFullCnt == 1'h0; // @[spiMaster.scala 88:66:@25.4]
  assign cntPosedge = fullCnt & _T_36; // @[spiMaster.scala 88:51:@26.4]
  assign SCK_Wire = ~ SCK_Reg; // @[spiMaster.scala 92:21:@30.4]
  assign _GEN_2 = cntPosedge ? SCK_Wire : SCK_Reg; // @[spiMaster.scala 96:27:@32.4]
  assign _T_48 = preSCK == 1'h0; // @[spiMaster.scala 109:31:@44.4]
  assign SCKPosedge = _T_48 & SCK_Reg; // @[spiMaster.scala 109:44:@47.4]
  assign _T_63 = byteCnt + 3'h1; // @[spiMaster.scala 117:32:@54.4]
  assign byteCntNext = byteCnt + 3'h1; // @[spiMaster.scala 117:32:@55.4]
  assign _T_65 = ~ io_ctl; // @[spiMaster.scala 120:22:@58.6]
  assign _GEN_11 = {{1'd0}, dataRxd_Reg}; // @[spiMaster.scala 127:53:@66.8]
  assign _T_70 = _GEN_11 << 1; // @[spiMaster.scala 127:53:@66.8]
  assign _GEN_12 = {{8'd0}, io_MISO}; // @[spiMaster.scala 127:59:@67.8]
  assign _T_71 = _T_70 | _GEN_12; // @[spiMaster.scala 127:59:@67.8]
  assign _T_72 = io_dataTxd >> byteCnt; // @[spiMaster.scala 128:48:@69.8]
  assign _T_73 = _T_72[0]; // @[spiMaster.scala 128:48:@70.8]
  assign _GEN_3 = _T_65 ? 3'h0 : byteCntNext; // @[spiMaster.scala 120:30:@59.6]
  assign _GEN_4 = _T_65 ? 1'h0 : _T_73; // @[spiMaster.scala 120:30:@59.6]
  assign _GEN_5 = _T_65 ? 9'h0 : _T_71; // @[spiMaster.scala 120:30:@59.6]
  assign _GEN_7 = SCKPosedge ? _GEN_3 : byteCnt; // @[spiMaster.scala 119:25:@57.4]
  assign _GEN_8 = SCKPosedge ? _GEN_4 : MOSI_Reg; // @[spiMaster.scala 119:25:@57.4]
  assign _GEN_9 = SCKPosedge ? _GEN_5 : {{1'd0}, dataRxd_Reg}; // @[spiMaster.scala 119:25:@57.4]
  assign _GEN_10 = SCKPosedge ? _T_65 : CSn_Reg; // @[spiMaster.scala 119:25:@57.4]
  assign io_dataRxd = dataRxd_Reg; // @[spiMaster.scala 136:28:@78.4]
  assign io_SCK = SCK_Reg; // @[spiMaster.scala 102:16:@37.4]
  assign io_MOSI = MOSI_Reg; // @[spiMaster.scala 138:25:@80.4]
  assign io_CSn = CSn_Reg; // @[spiMaster.scala 137:24:@79.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  value = _RAND_0[5:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  preFullCnt = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  SCK_Reg = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  preSCK = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  byteCnt = _RAND_4[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  MOSI_Reg = _RAND_5[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  dataRxd_Reg = _RAND_6[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  CSn_Reg = _RAND_7[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      value <= 6'h0;
    end else begin
      if (fullCnt) begin
        value <= 6'h0;
      end else begin
        value <= _T_26;
      end
    end
    if (reset) begin
      preFullCnt <= 1'h0;
    end else begin
      preFullCnt <= fullCnt;
    end
    if (reset) begin
      SCK_Reg <= 1'h0;
    end else begin
      if (cntPosedge) begin
        SCK_Reg <= SCK_Wire;
      end
    end
    if (reset) begin
      preSCK <= 1'h0;
    end else begin
      preSCK <= SCK_Reg;
    end
    if (reset) begin
      byteCnt <= 3'h0;
    end else begin
      if (SCKPosedge) begin
        if (_T_65) begin
          byteCnt <= 3'h0;
        end else begin
          byteCnt <= byteCntNext;
        end
      end
    end
    if (reset) begin
      MOSI_Reg <= 1'h0;
    end else begin
      if (SCKPosedge) begin
        if (_T_65) begin
          MOSI_Reg <= 1'h0;
        end else begin
          MOSI_Reg <= _T_73;
        end
      end
    end
    if (reset) begin
      dataRxd_Reg <= 8'h0;
    end else begin
      dataRxd_Reg <= _GEN_9[7:0];
    end
    if (reset) begin
      CSn_Reg <= 1'h1;
    end else begin
      if (SCKPosedge) begin
        CSn_Reg <= _T_65;
      end
    end
  end
endmodule
