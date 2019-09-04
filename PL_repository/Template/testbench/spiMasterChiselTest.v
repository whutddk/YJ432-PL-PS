
module SpiMasterChiselSim (
	
);

	reg CLK;
	reg RST_n;

	reg ctl;
	reg [7:0] dataTxd;
	wire [7:0] dataRxd;
	wire SCLK;
	reg MISO;
	wire MOSI;
	wire CSn;



SpiMaster s_SpiMaster( // @[:@3.2]
  .io_ctl(ctl), // @[:@4.4]
  .clock(CLK), // @[:@4.4]
  .reset(~RST_n), // @[:@4.4]
  .io_dataTxd(dataTxd), // @[:@4.4]
  .io_dataRxd(dataRxd), // @[:@4.4]
  .io_SCK(SCLK), // @[:@4.4]
  .io_MISO(MISO), // @[:@4.4]
  .io_MOSI(MOSI), // @[:@4.4]
  .io_CSn(CSn) // @[:@4.4]
);



always begin
	#1000	CLK = ~CLK;
end

	



initial begin
# 1
RST_n = 1'b0;
ctl = 1'b0;
CLK = 1'b0;
MISO = 1'b0;
dataTxd = 8'b0;
# 4000
RST_n = 1'b0;
# 10
RST_n = 1'b1;

dataTxd = 8'hab;
MISO = 1'b1;

# 2000
ctl = 1'b1;

end


endmodule

