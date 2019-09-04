`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/09/04 16:57:34
// Design Name: 
// Module Name: uartChiselTest
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


module uartChiselTest(


    );

	reg CLK;
	reg RSTn;

	reg TXDCTL;
	wire TXD;
	reg RXD;
	reg [7:0] TxdData;
	wire [7:0] RxdData;


uart s_uart( // @[:@3.2]
	.clock(CLK), // @[:@4.4]
	.reset(~RSTn), // @[:@5.4]
	.io_TXD_enable(TXDCTL), // @[:@6.4]
	.io_TXD_data(TxdData), // @[:@6.4]
	.io_RXD_data(RxdData), // @[:@6.4]
	.io_TXD(TXD), // @[:@6.4]
	.io_RXD(RXD) // @[:@6.4]
);

always begin
#1000 CLK = ~CLK;
end

initial begin
	CLK = 1'b0;
	RSTn = 1'b0;
	TXDCTL = 1'b0;
	RXD = 1'B0;
	TxdData = 8'B0;
#3400	

	RSTn = 1'b1;
	TxdData = 8'haa;

#3000
	TXDCTL = 1'b1;
	RXD = 1'B1;


end




endmodule
