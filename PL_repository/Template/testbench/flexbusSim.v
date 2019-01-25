//////////////////////////////////////////////////////////////////////////////////
// Company:  Wuhan university of technology  
// Engineer: Ruige_Lee
// Create Date: 2019-01-24 15:16:29
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-01-24 18:22:16
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

reg read_n_write_p;
assign FB_AD_Wire =  read_n_write_p ? FB_AD_REG : 32'bz;

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

initial begin

CLK = 1'b0;
RST_n = 1'b0;

FB_RW = 1'b0;
FB_CS = 1'b0;
FB_ALE = 1'b0;

FB_AD_REG = 32'b0;
read_n_write_p = 1'b1;

#1

RST_n = 1'b1;




//write 0

#30 CLK = 1'b1; 
FB_RW = 0;
FB_CS = 1;
FB_ALE = 1;
FB_AD_REG = 32'h60000000;
read_n_write_p = 1;

#30 CLK = 1'b0;



#30 CLK = 1'b1;
FB_RW = 0;
FB_CS = 0;
FB_ALE = 0;
FB_AD_REG = 32'd1000;
read_n_write_p = 1;

#30 CLK = 1'b0;


#30 CLK = 1'b1;
FB_RW = 0;
FB_CS = 1;
FB_ALE = 0;
FB_AD_REG = 32'd1001;
read_n_write_p = 1;

#30 CLK = 1'b0;



//write 1

#30 CLK = 1'b1; 
FB_RW = 0;
FB_CS = 1;
FB_ALE = 1;
FB_AD_REG = 32'h60000004;
read_n_write_p = 1;

#30 CLK = 1'b0;



#30 CLK = 1'b1;
FB_RW = 0;
FB_CS = 0;
FB_ALE = 0;
FB_AD_REG = 32'd2000;
read_n_write_p = 1;

#30 CLK = 1'b0;


#30 CLK = 1'b1;
FB_RW = 0;
FB_CS = 1;
FB_ALE = 0;
FB_AD_REG = 32'd2001;
read_n_write_p = 1;

#30 CLK = 1'b0;



//read 0

#30 CLK = 1'b1; 
FB_RW = 1;
FB_CS = 1;
FB_ALE = 1;
FB_AD_REG = 32'h60000000;
read_n_write_p = 1;

#30 CLK = 1'b0;



#30 CLK = 1'b1;
FB_RW = 1;
FB_CS = 0;
FB_ALE = 0;
FB_AD_REG = 32'd4000;
read_n_write_p = 0;

#30 CLK = 1'b0;


#30 CLK = 1'b1;
FB_RW = 1;
FB_CS = 1;
FB_ALE = 0;
FB_AD_REG = 32'd4001;
read_n_write_p = 0;

#30 CLK = 1'b0;



//read 1

#30 CLK = 1'b1; 
FB_RW = 1;
FB_CS = 1;
FB_ALE = 1;
FB_AD_REG = 32'h60000004;
read_n_write_p = 1;

#30 CLK = 1'b0;



#30 CLK = 1'b1;
FB_RW = 1;
FB_CS = 0;
FB_ALE = 0;
FB_AD_REG = 32'd3000;
read_n_write_p = 0;

#30 CLK = 1'b0;


#30 CLK = 1'b1;
FB_RW = 1;
FB_CS = 1;
FB_ALE = 0;
FB_AD_REG = 32'd3001;
read_n_write_p = 0;

#30 CLK = 1'b0;

end


endmodule

