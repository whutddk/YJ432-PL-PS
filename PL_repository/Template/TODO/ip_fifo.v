//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-25 21:35:20
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-02-26 10:41:47
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
		parameter fifoDepth = 4,
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


parameter grayCode0 = 3'b000;
parameter grayCode1 = 3'b001;
parameter grayCode2 = 3'b011;
parameter grayCode3 = 3'b010;
parameter grayCode4 = 3'b110;
parameter grayCode5 = 3'b111;
parameter grayCode6 = 3'b101;
parameter grayCode7 = 3'b100;


wire w_pr_state0 = (w_pr_Qout == grayCode0) ? 1'b1 : 1'b0;
wire w_pr_state1 = (w_pr_Qout == grayCode1) ? 1'b1 : 1'b0;
wire w_pr_state2 = (w_pr_Qout == grayCode2) ? 1'b1 : 1'b0;
wire w_pr_state3 = (w_pr_Qout == grayCode3) ? 1'b1 : 1'b0;
wire w_pr_state4 = (w_pr_Qout == grayCode4) ? 1'b1 : 1'b0;
wire w_pr_state5 = (w_pr_Qout == grayCode5) ? 1'b1 : 1'b0;
wire w_pr_state6 = (w_pr_Qout == grayCode6) ? 1'b1 : 1'b0;
wire w_pr_state7 = (w_pr_Qout == grayCode7) ? 1'b1 : 1'b0;

wire r_pr_state0 = (r_pr_Qout == grayCode0) ? 1'b1 : 1'b0;
wire r_pr_state1 = (r_pr_Qout == grayCode1) ? 1'b1 : 1'b0;
wire r_pr_state2 = (r_pr_Qout == grayCode2) ? 1'b1 : 1'b0;
wire r_pr_state3 = (r_pr_Qout == grayCode3) ? 1'b1 : 1'b0;
wire r_pr_state4 = (r_pr_Qout == grayCode4) ? 1'b1 : 1'b0;
wire r_pr_state5 = (r_pr_Qout == grayCode5) ? 1'b1 : 1'b0;
wire r_pr_state6 = (r_pr_Qout == grayCode6) ? 1'b1 : 1'b0;
wire r_pr_state7 = (r_pr_Qout == grayCode7) ? 1'b1 : 1'b0;


wire [2:0] w_pr_Din;
wire [2:0] w_pr_Qout;


basic_reg_clk_p # (
		.DW(3)
	)
	w_pr_reg
	(
		.CLK(w_clk),
		.RSTn(RST_n), 
		.din(w_pr_Din),
		.dout(w_pr_Qout)
);

w_pr_Din =	( {3{w_pr_state0}} & grayCode1 )
			| ( {3{w_pr_state1}} & grayCode2 )
			| ( {3{w_pr_state2}} & grayCode3 )
			| ( {3{w_pr_state3}} & grayCode4 )
			| ( {3{w_pr_state4}} & grayCode5 )
			| ( {3{w_pr_state5}} & grayCode6 )
			| ( {3{w_pr_state6}} & grayCode7 )
			| ( {3{w_pr_state7}} & grayCode0 );



wire [2:0] w_pr_sync_Din;
wire [2:0] w_pr_sync_Qout;

yj_basic_signal_2lever_sync # (
		.DW(3)
	)
	w_pr_sync
	(
		.CLK(r_clk),
		.RSTn(RST_n), 
		.din(w_pr_sync_Din),
		.dout(w_pr_sync_Qout)
);


assign w_pr_sync_Din = w_pr_Qout;




wire [2:0] r_pr_Din;
wire [2:0] r_pr_Qout;

basic_reg_clk_p # (
		.DW(3)
	)
	r_pr_reg
	(
		.CLK(r_clk),
		.RSTn(RST_n),, 
		.din(r_pr_Din),
		.dout(r_pr_Qout)
);


r_pr_Din =	( {3{r_pr_state0}} & grayCode1 )
			| ( {3{r_pr_state1}} & grayCode2 )
			| ( {3{r_pr_state2}} & grayCode3 )
			| ( {3{r_pr_state3}} & grayCode4 )
			| ( {3{r_pr_state4}} & grayCode5 )
			| ( {3{r_pr_state5}} & grayCode6 )
			| ( {3{r_pr_state6}} & grayCode7 )
			| ( {3{r_pr_state7}} & grayCode0 );



wire [2:0] r_pr_sync_Din;
wire [2:0] r_pr_sync_Qout;

yj_basic_signal_2lever_sync # (
		.DW(3)
	)
	r_pr_sync
	(
		.CLK(w_clk),
		.RSTn(RST_n),, 
		.din(r_pr_sync_Din),
		.dout(r_pr_sync_Qout)
);

assign r_pr_sync_Din = r_pr_Qout;





wire fifo_full_Din;
wire fifo_full_Qout;

basic_reg_clk_p # (
		.DW(1)
	)
	fifo_full_reg
	(
		.CLK(w_clk),
		.RSTn(RST_n), 
		.din(fifo_full_Din),
		.dout(fifo_full_Qout)
);

assign fifoFull = fifo_full_Qout;
assign fifo_full_Din = ( (r_pr_sync_Qout ^ w_pr_Qout) == 3'b110 ) ? 1'b1 : 1'b0;


wire fifo_empty_Din;
wire fifo_empty_Qout;

basic_reg_clk_p # (
		.DW(1)
	)
	fifo_empty_reg
	(
		.CLK(r_clk),
		.RSTn(RST_n), 
		.din(fifo_empty_Din),
		.dout(fifo_empty_Qout)
);

assign fifoEmpty = fifo_empty_Qout;
assign fifo_empty_Din = ( r_pr_Qout == w_pr_sync_Qout ) ? 1'b1 : 1'b0;








///////////////////////////////////////////////////







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



