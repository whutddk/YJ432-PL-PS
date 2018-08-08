`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/08/08 11:02:15
// Design Name: 
// Module Name: FDCT32
// Project Name: TJ432-B
// Target Devices: Artix-7 35T
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

module polyphase 
(
	input CLK,    // Clock
	input RST_n,  // Asynchronous reset active low
	
	//ram operate
	output reg [11:0] Ram_addrA,
	output reg [11:0] Ram_addrB,
	input [31:0] Ram_dataA,
	input [31:0] Ram_dataB,

	//Rom operate
	output reg [8:0] Rom_addrA,
	output reg [8:0] Rom_addrB,
	input [31:0] Rom_dataA,
	input [31:0] Rom_dataB,	

	//FIFO pcm DATA
	output reg [31:0] fifo_data,
	output reg fifo_clk


);

reg [31:0] pcm[0:64];
reg [7:0] poly_cnt = 8'd0; 
always @( posedge CLK or negedge RST_n ) begin
if ( !RST_n ) begin
	Ram_addrA <= 12'b0;
	Ram_addrB <= 12'b0;
	Rom_addrA <= 9'b0;
	Rom_addrB <= 9'b0;
	fifo_data <= 32'd0;
	fifo_clk <= 1'b0;

	poly_cnt <= 8'd0;
end

else begin
	poly_cnt <= poly_cnt + 8'd1;
end

end


endmodule

