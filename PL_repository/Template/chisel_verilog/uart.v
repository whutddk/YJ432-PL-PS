module uart( // @[:@3.2]
  input        clock, // @[:@4.4]
  input        reset, // @[:@5.4]
  input        io_TXD_enable, // @[:@6.4]
  input  [7:0] io_TXD_data, // @[:@6.4]
  output [7:0] io_RXD_data, // @[:@6.4]
  output       io_TXD, // @[:@6.4]
  input        io_RXD // @[:@6.4]
);
  reg  TxdLine; // @[uart.scala 18:30:@8.4]
  reg [31:0] _RAND_0;
  reg  TxdEnablePre; // @[uart.scala 19:35:@9.4]
  reg [31:0] _RAND_1;
  wire  _T_21; // @[uart.scala 23:37:@13.4]
  wire  TxdPosedge; // @[uart.scala 23:50:@15.4]
  reg [3:0] TxdCnt; // @[uart.scala 24:29:@17.4]
  reg [31:0] _RAND_2;
  wire  _T_27; // @[uart.scala 26:35:@18.4]
  wire  _T_28; // @[uart.scala 26:52:@19.4]
  wire  _T_29; // @[uart.scala 26:39:@20.4]
  wire  _T_30; // @[uart.scala 26:69:@21.4]
  wire  _T_31; // @[uart.scala 26:56:@22.4]
  wire  _T_32; // @[uart.scala 26:86:@23.4]
  wire  _T_33; // @[uart.scala 26:73:@24.4]
  wire  _T_34; // @[uart.scala 26:103:@25.4]
  wire  _T_35; // @[uart.scala 26:90:@26.4]
  wire  _T_36; // @[uart.scala 26:120:@27.4]
  wire  _T_37; // @[uart.scala 26:107:@28.4]
  wire  _T_38; // @[uart.scala 26:137:@29.4]
  wire  _T_39; // @[uart.scala 26:124:@30.4]
  wire  _T_40; // @[uart.scala 26:154:@31.4]
  wire  TxdCheckBit; // @[uart.scala 26:141:@32.4]
  wire  _T_45; // @[uart.scala 33:27:@39.6]
  wire [4:0] _T_47; // @[uart.scala 35:34:@41.8]
  wire [3:0] _T_48; // @[uart.scala 35:34:@42.8]
  wire [7:0] _T_49; // @[uart.scala 36:39:@44.8]
  wire  _T_50; // @[uart.scala 36:39:@45.8]
  wire  _T_52; // @[uart.scala 38:27:@49.8]
  wire  _GEN_0; // @[uart.scala 39:9:@50.8]
  wire [3:0] _GEN_1; // @[uart.scala 39:9:@50.8]
  wire [3:0] _GEN_2; // @[uart.scala 34:9:@40.6]
  wire  _GEN_3; // @[uart.scala 34:9:@40.6]
  wire [3:0] _GEN_4; // @[uart.scala 29:9:@34.4]
  wire  _GEN_5; // @[uart.scala 29:9:@34.4]
  reg  RxdLinePre; // @[uart.scala 51:33:@59.4]
  reg [31:0] _RAND_3;
  wire  _T_63; // @[uart.scala 55:60:@65.4]
  wire  RxdStart; // @[uart.scala 55:47:@66.4]
  reg [3:0] RxdCnt; // @[uart.scala 56:29:@68.4]
  reg [31:0] _RAND_4;
  reg [7:0] RxdReg; // @[uart.scala 57:29:@69.4]
  reg [31:0] _RAND_5;
  reg [7:0] RxdTempReg; // @[uart.scala 58:33:@70.4]
  reg [31:0] _RAND_6;
  wire  _T_72; // @[uart.scala 61:34:@72.4]
  wire  _T_73; // @[uart.scala 61:50:@73.4]
  wire  _T_74; // @[uart.scala 61:38:@74.4]
  wire  _T_75; // @[uart.scala 61:66:@75.4]
  wire  _T_76; // @[uart.scala 61:54:@76.4]
  wire  _T_77; // @[uart.scala 61:82:@77.4]
  wire  _T_78; // @[uart.scala 61:70:@78.4]
  wire  _T_79; // @[uart.scala 61:98:@79.4]
  wire  _T_80; // @[uart.scala 61:86:@80.4]
  wire  _T_81; // @[uart.scala 61:114:@81.4]
  wire  _T_82; // @[uart.scala 61:102:@82.4]
  wire  _T_83; // @[uart.scala 61:130:@83.4]
  wire  _T_84; // @[uart.scala 61:118:@84.4]
  wire  _T_85; // @[uart.scala 61:146:@85.4]
  wire  RxdCheckBit; // @[uart.scala 61:134:@86.4]
  wire  _T_90; // @[uart.scala 68:27:@93.6]
  wire [4:0] _T_92; // @[uart.scala 70:34:@95.8]
  wire [3:0] _T_93; // @[uart.scala 70:34:@96.8]
  wire [7:0] _GEN_15; // @[uart.scala 71:42:@98.8]
  wire [7:0] _T_94; // @[uart.scala 71:42:@98.8]
  wire  _T_96; // @[uart.scala 73:27:@102.8]
  wire  _T_101; // @[uart.scala 77:38:@108.10]
  wire [7:0] _GEN_6; // @[uart.scala 78:17:@109.10]
  wire [3:0] _GEN_7; // @[uart.scala 74:9:@103.8]
  wire [7:0] _GEN_8; // @[uart.scala 74:9:@103.8]
  wire [3:0] _GEN_9; // @[uart.scala 69:9:@94.6]
  wire [7:0] _GEN_10; // @[uart.scala 69:9:@94.6]
  wire [7:0] _GEN_11; // @[uart.scala 69:9:@94.6]
  wire [3:0] _GEN_12; // @[uart.scala 64:9:@88.4]
  wire [7:0] _GEN_13; // @[uart.scala 64:9:@88.4]
  wire [7:0] _GEN_14; // @[uart.scala 64:9:@88.4]
  assign _T_21 = TxdEnablePre == 1'h0; // @[uart.scala 23:37:@13.4]
  assign TxdPosedge = _T_21 & io_TXD_enable; // @[uart.scala 23:50:@15.4]
  assign _T_27 = io_TXD_data[7]; // @[uart.scala 26:35:@18.4]
  assign _T_28 = io_TXD_data[6]; // @[uart.scala 26:52:@19.4]
  assign _T_29 = _T_27 ^ _T_28; // @[uart.scala 26:39:@20.4]
  assign _T_30 = io_TXD_data[5]; // @[uart.scala 26:69:@21.4]
  assign _T_31 = _T_29 ^ _T_30; // @[uart.scala 26:56:@22.4]
  assign _T_32 = io_TXD_data[4]; // @[uart.scala 26:86:@23.4]
  assign _T_33 = _T_31 ^ _T_32; // @[uart.scala 26:73:@24.4]
  assign _T_34 = io_TXD_data[3]; // @[uart.scala 26:103:@25.4]
  assign _T_35 = _T_33 ^ _T_34; // @[uart.scala 26:90:@26.4]
  assign _T_36 = io_TXD_data[2]; // @[uart.scala 26:120:@27.4]
  assign _T_37 = _T_35 ^ _T_36; // @[uart.scala 26:107:@28.4]
  assign _T_38 = io_TXD_data[1]; // @[uart.scala 26:137:@29.4]
  assign _T_39 = _T_37 ^ _T_38; // @[uart.scala 26:124:@30.4]
  assign _T_40 = io_TXD_data[0]; // @[uart.scala 26:154:@31.4]
  assign TxdCheckBit = _T_39 ^ _T_40; // @[uart.scala 26:141:@32.4]
  assign _T_45 = TxdCnt < 4'h8; // @[uart.scala 33:27:@39.6]
  assign _T_47 = TxdCnt + 4'h1; // @[uart.scala 35:34:@41.8]
  assign _T_48 = TxdCnt + 4'h1; // @[uart.scala 35:34:@42.8]
  assign _T_49 = io_TXD_data >> TxdCnt; // @[uart.scala 36:39:@44.8]
  assign _T_50 = _T_49[0]; // @[uart.scala 36:39:@45.8]
  assign _T_52 = TxdCnt == 4'h8; // @[uart.scala 38:27:@49.8]
  assign _GEN_0 = _T_52 ? TxdCheckBit : 1'h1; // @[uart.scala 39:9:@50.8]
  assign _GEN_1 = _T_52 ? _T_48 : TxdCnt; // @[uart.scala 39:9:@50.8]
  assign _GEN_2 = _T_45 ? _T_48 : _GEN_1; // @[uart.scala 34:9:@40.6]
  assign _GEN_3 = _T_45 ? _T_50 : _GEN_0; // @[uart.scala 34:9:@40.6]
  assign _GEN_4 = TxdPosedge ? 4'h0 : _GEN_2; // @[uart.scala 29:9:@34.4]
  assign _GEN_5 = TxdPosedge ? 1'h0 : _GEN_3; // @[uart.scala 29:9:@34.4]
  assign _T_63 = io_RXD == 1'h0; // @[uart.scala 55:60:@65.4]
  assign RxdStart = RxdLinePre & _T_63; // @[uart.scala 55:47:@66.4]
  assign _T_72 = RxdTempReg[7]; // @[uart.scala 61:34:@72.4]
  assign _T_73 = RxdTempReg[6]; // @[uart.scala 61:50:@73.4]
  assign _T_74 = _T_72 ^ _T_73; // @[uart.scala 61:38:@74.4]
  assign _T_75 = RxdTempReg[5]; // @[uart.scala 61:66:@75.4]
  assign _T_76 = _T_74 ^ _T_75; // @[uart.scala 61:54:@76.4]
  assign _T_77 = RxdTempReg[4]; // @[uart.scala 61:82:@77.4]
  assign _T_78 = _T_76 ^ _T_77; // @[uart.scala 61:70:@78.4]
  assign _T_79 = RxdTempReg[3]; // @[uart.scala 61:98:@79.4]
  assign _T_80 = _T_78 ^ _T_79; // @[uart.scala 61:86:@80.4]
  assign _T_81 = RxdTempReg[2]; // @[uart.scala 61:114:@81.4]
  assign _T_82 = _T_80 ^ _T_81; // @[uart.scala 61:102:@82.4]
  assign _T_83 = RxdTempReg[1]; // @[uart.scala 61:130:@83.4]
  assign _T_84 = _T_82 ^ _T_83; // @[uart.scala 61:118:@84.4]
  assign _T_85 = RxdTempReg[0]; // @[uart.scala 61:146:@85.4]
  assign RxdCheckBit = _T_84 ^ _T_85; // @[uart.scala 61:134:@86.4]
  assign _T_90 = RxdCnt < 4'h8; // @[uart.scala 68:27:@93.6]
  assign _T_92 = RxdCnt + 4'h1; // @[uart.scala 70:34:@95.8]
  assign _T_93 = RxdCnt + 4'h1; // @[uart.scala 70:34:@96.8]
  assign _GEN_15 = {{7'd0}, io_RXD}; // @[uart.scala 71:42:@98.8]
  assign _T_94 = RxdTempReg | _GEN_15; // @[uart.scala 71:42:@98.8]
  assign _T_96 = RxdCnt == 4'h8; // @[uart.scala 73:27:@102.8]
  assign _T_101 = io_RXD == RxdCheckBit; // @[uart.scala 77:38:@108.10]
  assign _GEN_6 = _T_101 ? RxdTempReg : RxdReg; // @[uart.scala 78:17:@109.10]
  assign _GEN_7 = _T_96 ? _T_93 : RxdCnt; // @[uart.scala 74:9:@103.8]
  assign _GEN_8 = _T_96 ? _GEN_6 : RxdReg; // @[uart.scala 74:9:@103.8]
  assign _GEN_9 = _T_90 ? _T_93 : _GEN_7; // @[uart.scala 69:9:@94.6]
  assign _GEN_10 = _T_90 ? _T_94 : RxdTempReg; // @[uart.scala 69:9:@94.6]
  assign _GEN_11 = _T_90 ? RxdReg : _GEN_8; // @[uart.scala 69:9:@94.6]
  assign _GEN_12 = RxdStart ? 4'h0 : _GEN_9; // @[uart.scala 64:9:@88.4]
  assign _GEN_13 = RxdStart ? 8'h0 : _GEN_10; // @[uart.scala 64:9:@88.4]
  assign _GEN_14 = RxdStart ? RxdReg : _GEN_11; // @[uart.scala 64:9:@88.4]
  assign io_RXD_data = RxdReg; // @[uart.scala 83:21:@113.4]
  assign io_TXD = TxdLine; // @[uart.scala 84:16:@114.4]
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
  TxdLine = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  TxdEnablePre = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  TxdCnt = _RAND_2[3:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  RxdLinePre = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  RxdCnt = _RAND_4[3:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  RxdReg = _RAND_5[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  RxdTempReg = _RAND_6[7:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      TxdLine <= 1'h1;
    end else begin
      if (TxdPosedge) begin
        TxdLine <= 1'h0;
      end else begin
        if (_T_45) begin
          TxdLine <= _T_50;
        end else begin
          if (_T_52) begin
            TxdLine <= TxdCheckBit;
          end else begin
            TxdLine <= 1'h1;
          end
        end
      end
    end
    TxdEnablePre <= io_TXD_enable;
    if (reset) begin
      TxdCnt <= 4'hf;
    end else begin
      if (TxdPosedge) begin
        TxdCnt <= 4'h0;
      end else begin
        if (_T_45) begin
          TxdCnt <= _T_48;
        end else begin
          if (_T_52) begin
            TxdCnt <= _T_48;
          end
        end
      end
    end
    RxdLinePre <= io_RXD;
    if (reset) begin
      RxdCnt <= 4'hf;
    end else begin
      if (RxdStart) begin
        RxdCnt <= 4'h0;
      end else begin
        if (_T_90) begin
          RxdCnt <= _T_93;
        end else begin
          if (_T_96) begin
            RxdCnt <= _T_93;
          end
        end
      end
    end
    if (reset) begin
      RxdReg <= 8'h0;
    end else begin
      if (!(RxdStart)) begin
        if (!(_T_90)) begin
          if (_T_96) begin
            if (_T_101) begin
              RxdReg <= RxdTempReg;
            end
          end
        end
      end
    end
    if (reset) begin
      RxdTempReg <= 8'h0;
    end else begin
      if (RxdStart) begin
        RxdTempReg <= 8'h0;
      end else begin
        if (_T_90) begin
          RxdTempReg <= _T_94;
        end
      end
    end
  end
endmodule
