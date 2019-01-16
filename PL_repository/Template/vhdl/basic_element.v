//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: WUT_Ruige_Lee
// Create Date: 2019-01-16 15:52:29
// Last Modified by:   WUT_Ruige_Lee
// Last Modified time: 2019-01-16 15:55:45
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


module basic_reg # (
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
		qout_Reg <= #1 { DW { 1'b0 } };
	end

	else begin
		qout_Reg <= #1 din;
	end

end



endmodule


