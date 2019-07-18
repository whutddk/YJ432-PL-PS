//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-01-16 17:35:01
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-03-03 16:43:57
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: basic_element
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


//mainly refer to risc-V e203


`timescale 1 ns / 1 ps


module yj_basic_reg_clk_p # (
		parameter DW = 32,
		parameter RSTVAL = 1'b0
	)
	(
		input CLK,
		input RSTn,

		input  [ DW-1:0 ] din,
		output [ DW-1:0 ] qout
);

reg [DW-1:0] qout_Reg;

assign qout = qout_Reg;

always @( posedge CLK or negedge RSTn ) begin

	if ( !RSTn ) begin
		qout_Reg <= { DW { RSTVAL } };
	end

	else begin
		qout_Reg <= #1 din;
	end

end

endmodule


module yj_basic_reg_clk_n # (
		parameter DW = 32,
		parameter RSTVAL = 1'b0
	)
	(
		input CLK,
		input RSTn,

		input  [ DW-1:0 ] din,
		output [ DW-1:0 ] qout
);

reg [DW-1:0] qout_Reg;

assign qout = qout_Reg;

always @( negedge CLK or negedge RSTn ) begin

	if ( !RSTn ) begin
		qout_Reg <= { DW { RSTVAL } };
	end

	else begin
		qout_Reg <= #1 din;
	end

end



endmodule




module yj_basic_signal_2lever_sync # 
	(
		parameter DW = 32
	) 
	(
	input	CLK,
	input	RSTn, 
	input  [DW-1:0] din,
	output [DW-1:0] dout


);

	wire [DW-1:0] sync_dat [1:0];
    
    yj_basic_reg_clk_p #(.DW(DW),.RSTVAL(1'b0)) sync_1lever(CLK, RSTn, din, sync_dat[0]);
    yj_basic_reg_clk_p #(.DW(DW),.RSTVAL(1'b0)) sync_2lever(CLK, RSTn, sync_dat[0], sync_dat[1]);


	assign dout = sync_dat[1];
  
endmodule

