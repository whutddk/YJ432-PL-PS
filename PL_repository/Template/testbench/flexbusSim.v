//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-01-24 15:16:29
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-01-24 15:27:54
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: flexbusSim
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


module flexbusSim (
	
);

	reg CLK;
	reg RST_n;

	reg FB_RW;
	reg FB_CS;
	reg FB_ALE;


	reg [31:0] FB_AD_REG;
	wire [31:0] FB_AD_Wire;
	
	wire [31:0] LED_FREQ_Qout;
	wire [31:0] BZ_FREQ_Qout;
	wire [31:0] LEDR_Puty_Qout;
	wire [31:0] LEDG_Puty_Qout;
	wire [31:0] LEDB_Puty_Qout;

wire read_n_write_p;
assign FB_AD_Wire =  read_n_write_p  ? FB_AD_REG : 32'bz;

perip_flexbus # (
	.FB_BASE(32'h60000000)
)
	s_flexbus
(
	.FB_CLK(CLK),
	.RST_n(RST_n),

	.FB_RW(FB_RW),
	.FB_CS(FB_CS),
	.FB_ALE(FB_ALE),

	.FB_AD(FB_AD_Wire),
	
	.LED_FREQ_Qout(LED_FREQ_Qout),
	.BZ_FREQ_Qout(BZ_FREQ_Qout),
	.LEDR_Puty_Qout(LEDR_Puty_Qout),
	.LEDG_Puty_Qout(LEDG_Puty_Qout),
	.LEDB_Puty_Qout(LEDB_Puty_Qout)
	
	
	);
endmodule

