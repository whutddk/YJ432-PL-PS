//////////////////////////////////////////////////////////////////////////////////
// Company: wuhan university of technology
// Engineer: RUIGE LEE
// Create Date: 2018/07/19 10:35:01
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-01-22 14:52:05
// Email: 295054118@whut.edu.cn
// Design Name: 
// Module Name: ip_flexbus
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
 

`timescale 1ns / 1ps


module perip_flexbus # (
	parameter [31:0] FB_BASE = 32'h60000000
)
(
	input FB_CLK,
	input RST_n,
	// input FB_OE,
	input FB_RW,
	input FB_CS,
	input FB_ALE,
	// input FB_BE31_24,
	// input FB_BE23_16,
	// input FB_BE15_8,
	// input FB_BE7_0,
	inout [31:0] FB_AD,
	
	output [31:0] LED_FREQ_Qout,
	output [31:0] BZ_FREQ_Qout,
	output [31:0] LEDR_Puty_Qout,
	output [31:0] LEDG_Puty_Qout,
	output [31:0] LEDB_Puty_Qout
	
	
	);


wire AD_TRI_n ;
// reg ADD_COMF = 1'b0;

// (* DONT_TOUCH = "TRUE" *) reg [31:0] FB_AD_reg = 32'b0;
// reg [31:0] ip_ADDR = 32'b0;

assign AD_TRI_n = (~FB_ALE) & (ADD_COMF_Qout) & (~FB_CS) & (FB_RW);      
assign FB_AD[31:0] = ( AD_TRI_n ) ? FB_AD_Qout[31:0] : 32'bz;


wire ADDR_COMF_Din;
wire ADDR_COMF_Qout;
basic_reg # (1)
	ADDR_COMF
	(
	.CLK(FB_CLK),
	.RSTn(RST_n),
	.din (ADDR_COMF_Din),
	.qout(ADDR_COMF_Qout)
);

wire [31:0] FB_AD_Din;
wire [31:0] FB_AD_Qout;
basic_reg # (32)
	FB_AD
	(
	.CLK(FB_CLK),
	.RSTn(RST_n),
	.din (FB_AD_Din),
	.qout(FB_AD_Qout)
);

wire [31:0] ip_ADDR_Din;
wire [31:0] ip_ADDR_Qout;
basic_reg # (32)
	ip_ADDR(
	.CLK(FB_CLK),
	.RSTn(RST_n),
	.din (ip_ADDR_Din),
	.qout(ip_ADDR_Qout)
);


//////////////////////////////////////////


wire [31:0] LED_FREQ_Din;
basic_reg # (32)
	LED_FREQ(
	.CLK(FB_CLK),
	.RSTn(RST_n),
	.din (LED_FREQ_Din),
	.qout(LED_FREQ_Qout)
);


wire [31:0] BZ_FREQ_Din;
basic_reg # (32)
	BZ_FREQ(
	.CLK(FB_CLK),
	.RSTn(RST_n),
	.din (BZ_FREQ_Din),
	.qout(BZ_FREQ_Qout)
);


wire [31:0] LEDR_Puty_Din;
basic_reg # (32)
	LEDR_Puty(
	.CLK(FB_CLK),
	.RSTn(RST_n),
	.din (LEDR_Puty_Din),
	.qout(LEDR_Puty_Qout)
);


wire [31:0] LEDG_Puty_Din;
basic_reg # (32)
	LEDG_Puty(
	.CLK(FB_CLK),
	.RSTn(RST_n),
	.din (LEDG_Puty_Din),
	.qout(LEDG_Puty_Qout)
);


wire [31:0] LEDB_Puty_Din;
basic_reg # (32)
	LEDB_Puty(
	.CLK(FB_CLK),
	.RSTn(RST_n),
	.din (LEDB_Puty_Din),
	.qout(LEDB_Puty_Qout)
);

wire baseAddressCheck;
assign baseAddressCheck = ((FB_AD[31:0] & 32'hf0000000) == ( FB_BASE[31:0] & 32'hf0000000 )) ? 1'b1:1'b0;


assign ip_ADDR_Din = (
						{32{FB_ALE}} & 
						(
							{32{baseAddressCheck}} &
							(
								FB_AD[31:0];
							)
							|
							{32{~baseAddressCheck}} &
							(
								32'b0;
							)
						)
					)
					|
					(
						{32{~FB_ALE}} &
						(
							ip_ADDR_Qout;
						)
					);

assign ADDR_COMF_Din = (
							(FB_ALE) & 
							(
								(baseAddressCheck) &
								(
									1'b1
								)
								|
								(~baseAddressCheck) &
								(
									1'b0;
								)
							)
						)
						|
						(	(~FB_ALE) &
							(
								ADDR_COMF_Qout
							)
						);



assign LED_FREQ_SEL  = (ip_ADDR_Qout & 32'h0fffffff == 32'b00000) ? 1'b1:1'b0;
assign BZ_FREQ_SEL   = (ip_ADDR_Qout & 32'h0fffffff == 32'b00100) ? 1'b1:1'b0;
assign LEDR_Puty_SEL = (ip_ADDR_Qout & 32'h0fffffff == 32'b01000) ? 1'b1:1'b0;
assign LEDG_Puty_SEL = (ip_ADDR_Qout & 32'h0fffffff == 32'b01100) ? 1'b1:1'b0;
assign LEDB_Puty_SEL = (ip_ADDR_Qout & 32'h0fffffff == 32'b10000) ? 1'b1:1'b0;

assign FB_AD_Din = (
						{32{(~FB_ALE & ADDR_COMF_Qout & ~FB_CS &  FB_RW)}} & 
						(
							({32{LED_FREQ_SEL}} & LED_FREQ_Qout)
							|
							({32{BZ_FREQ_SEL}} & BZ_FREQ_Qout)
							|
							({32{LEDR_Puty_SEL}} & LEDR_Puty_Qout)
							|
							({32{LEDG_Puty_SEL}} & LEDG_Puty_Qout)
							|
							({32{LEDB_Puty_SEL}} & LEDB_Puty_Qout)
							|
							(
								32'b0
							)

						)
					)
					|
					(
						{32{( FB_ALE | ~ADDR_COMF_Qout |  FB_CS | ~FB_RW)}} &
						(
							FB_AD_Qout
						)
					);

assign LED_FREQ_Din = ( (~FB_ALE & ADDR_COMF_Qout & ~FB_CS & ~FB_RW) & 
						(LED_FREQ_SEL) )
						? FB_AD
						: LED_FREQ_Qout;

assign BZ_FREQ_Din  = ( (~FB_ALE & ADDR_COMF_Qout & ~FB_CS & ~FB_RW) & 
						(BZ_FREQ_SEL) )
						? FB_AD
						: BZ_FREQ_Qout;					

assign LEDR_Puty_Din = ( (~FB_ALE & ADDR_COMF_Qout & ~FB_CS & ~FB_RW) & 
						(LEDR_Puty_SEL) )
						? FB_AD
						: LEDR_Puty_Qout;

assign LEDG_Puty_Din = ( (~FB_ALE & ADDR_COMF_Qout & ~FB_CS & ~FB_RW) & 
						(LEDG_Puty_SEL) )
						? FB_AD
						: LEDG_Puty_Qout;

assign LEDB_Puty_Din = 	( (~FB_ALE & ADDR_COMF_Qout & ~FB_CS & ~FB_RW) & 
						(LEDB_Puty_SEL) )
						? FB_AD
						: LEDB_Puty_Qout;			




// always@( negedge FB_CLK or negedge RST_n )  begin
// 	if ( !RST_n ) begin

// 		ip_ADDR[31:0] <= 32'b0;
// 		ADD_COMF <= 1'b0;
		
// 		FB_AD_reg[31:0] <= 32'b0;

// 		LED_FREQ_Reg <= 32'b0;
// 		BZ_FREQ_Reg <= 32'b0;
// 		LEDR_Puty_Reg <= 32'b0;
// 		LEDG_Puty_Reg <= 32'b0;
// 		LEDB_Puty_Reg <= 32'b0;  
		
// 	end
// 	else begin

		// FB_AD_reg <= FB_AD_reg;

		// ip_ADDR <= ip_ADDR;

		// ADD_COMF <= ADD_COMF;

		// LED_FREQ_Reg <= LED_FREQ_Reg;
		// BZ_FREQ_Reg <= BZ_FREQ_Reg;
		// LEDR_Puty_Reg <= LEDR_Puty_Reg;
		// LEDG_Puty_Reg <= LEDG_Puty_Reg;
		// LEDB_Puty_Reg <= LEDB_Puty_Reg;

		 
		// if ( FB_ALE == 1'b1 ) begin  //flexbus_address latch enable

			// if ( (FB_AD[31:0] & 32'hf0000000) == ( FB_BASE[31:0] & 32'hf0000000 ) ) begin// check base address 
				// ADD_COMF <= 1'b1;
				// ip_ADDR[31:0] <= FB_AD[31:0];

			// end
			// else begin // IN ADDRESS LATCH MODE BUT THE ADDRESS IS NOT SELECT THIS FLEXBUS IP
				// ADD_COMF <= 1'b0;
				// ip_ADDR[31:0] <= 32'b0;
			// end
		// end // FB_ALE == 1'b1

		// else begin //FB_ALE == 1'B0
			// if ( ADD_COMF == 1'b1 ) begin //ADDRESS CONFIRM
				// if ( FB_CS == 1'b0 ) begin //CS is enable 
					// if ( FB_RW == 1'b0 ) begin  //in write mode
											
						// casez( ip_ADDR & 32'h0fffffff )
												
							// 32'b00000: begin
								// LED_FREQ_Reg[31:0] <= FB_AD[31:0];
							// end
							// 32'b00100:begin
								// BZ_FREQ_Reg[31:0] <= FB_AD[31:0];
							// end
							// 32'b01000:begin
								// LEDR_Puty_Reg[31:0] <= FB_AD[31:0];
							// end
							// 32'b01100:begin
								// LEDG_Puty_Reg[31:0] <= FB_AD[31:0];
							// end
							// 32'b10000:begin
								// LEDB_Puty_Reg[31:0] <= FB_AD[31:0];
							// end
							
							
							// 32'h0780zzzz:begin
								
							// end

							// default:begin
							// end // default:
						// endcase
					// end // FB_RW == 1'b0
					
					// else if ( FB_RW == 1'b1 ) begin //in read mode
						
						// casez( ip_ADDR & 32'h0fffffff )
							// 32'b00000: begin
								// FB_AD_reg[31:0] <= LED_FREQ_Reg[31:0];
							// end // 32'b00000:
							// 32'b00100:begin
								// FB_AD_reg[31:0] <= BZ_FREQ_Reg[31:0];
							// end // 32'b00100:
							// 32'b01000:begin
								// FB_AD_reg[31:0] <= LEDR_Puty_Reg[31:0];
							// end // 32'b01000:
							// 32'b01100:begin
								// FB_AD_reg[31:0] <= LEDG_Puty_Reg[31:0];
							// end // 32'b01100:
							// 32'b10000:begin
								// FB_AD_reg[31:0] <= LEDB_Puty_Reg[31:0];
							// end // 32'b10000:

							// default:begin
							// end // default:
						// endcase
					// end // FB_RW == 1'b1
					// else begin
					// end // else
				// end  // ( FB_CS == 1'b0 )
				// else begin //( FB_CS == 1'b1 )
				// end
			// end //ADDRESS CONFIRM
			// else begin //ADDRESS VOTE
			// end //ADDRESS VOTE
		// end // FB_ALE == 1'B0
	// end

// end
 
	
	
endmodule
