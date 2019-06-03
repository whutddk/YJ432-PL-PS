//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-05-24 16:02:55
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-05-24 16:05:23
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name:   
// Module Name: PRpwm1to4
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


module reconfig (
	input CLK,
	input RST_n,

	output [3:0] data


	
);

reg [3:0] data_Reg;
reg [2:0] cnt_Reg;


always @ (posedge CLK) begin
if ( !RST_n )begin
    data_Reg <= 4'b0;
    cnt_Reg <= 3'd0;
end
else begin
    cnt_Reg <= cnt_Reg + 3'd1;

    if ( cnt_Reg[0] == 1'b1 ) begin
        data_Reg <= data_Reg << 1 | 4'b1 ;
    end
    else begin
        data_Reg <= data_Reg << 1;
    end
end
end

assign data = data_Reg;

endmodule