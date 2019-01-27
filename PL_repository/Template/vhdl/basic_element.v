//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: WUT_Ruige_Lee
// Create Date: 2019-01-16 15:52:29
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-01-27 16:23:26
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
// Revision 0.01 - File Created
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////


module basic_reg_clk_p # (
		parameter DW = 32
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
		qout_Reg <= { DW { 1'b0 } };
	end

	else begin
		qout_Reg <= #1 din;
	end

end



endmodule


module basic_reg_clk_n # (
		parameter DW = 32
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
		qout_Reg <= { DW { 1'b0 } };
	end

	else begin
		qout_Reg <= #1 din;
	end

end



endmodule