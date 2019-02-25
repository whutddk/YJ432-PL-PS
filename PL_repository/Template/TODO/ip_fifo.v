//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-25 21:35:20
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-02-25 22:41:06
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: ip_fifo
// Project Name:   
// Target Devices:   
// Tool Versions:   
// Description:   
// 
// Dependencies:   
// 
// Revision:  
// Revision:    -   
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////


module yj_asynchronous_fifo #
	(
		parameter fifoDepth = 8,
		parameter prWidth = 3,
		parameter dataWidth = 32
	)
	
	(
	input RST_n,  // Asynchronous reset active low
	input w_clk,    // Clock
	
	input [dataWidth-1:0] w_data,

	input r_clk,
	
	output [dataWidth-1:0] r_data,

	output fifoFull,
	output fifoEmpty
);


grayCode

wire [prWidth-1:0] w_pr_Din;
wire [prWidth-1:0] w_pr_Qin;


yj_basic_signal_2lever_sync # (
		.DW(16)
	)
	w_pr_reg
	(
		.CLK(r_clk),
		.RSTn(RST_n), 
		.din(w_pr_Din),
		.dout(w_pr_Qin)
);




wire [prWidth-1:0] r_pr_Din;
wire [prWidth-1:0] r_pr_Qout;

yj_basic_signal_2lever_sync # (
		.DW(16)
	)
	r_pr_reg
	(
		.CLK(w_clk),
		.RSTn(RST_n),, 
		.din(r_pr_Din),
		.dout(r_pr_Qout)
);





genvar i;
generate
	

	for ( i = 0; i < fifoDepth ; i = i + 1 ) begin
		basic_reg_clk_p # (
		.DW(16)
	)

	(
		input CLK,
		input RSTn,

		input  [ DW-1:0 ] din,
		output [ DW-1:0 ] qout
);
	end


endgenerate





endmodule



