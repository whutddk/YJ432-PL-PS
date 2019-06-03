//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-05-24 14:15:27
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-05-24 14:22:05
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name:   
// Module Name: PartialReconfigurationTop
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
//
//////////////////////////////////////////////////////////////////////////////////


module PartialReconfigurationTop (
	input i_sysclk,
//	input RST_n,
	
	
    output BZ,
    output LED_R,
    output LED_G,
    output LED_B

);

wire [3:0] dataWire;

assign {BZ,LED_R,LED_G,LED_B} = ~dataWire;

reg [31:0] clk_cnt = 32'd0;
reg clk_div = 1'd0;

always @ (posedge i_sysclk ) begin
if ( clk_cnt == 32'd50000000 ) begin
    clk_cnt <= 32'd0;
    clk_div <= ~clk_div;
end
else begin
clk_cnt <= clk_cnt + 32'd1;

end

end
	
	
reconfig i_cfg1(
	.CLK(clk_div),
	.RST_n(1'b1),


	.data(dataWire)

);
	
endmodule


