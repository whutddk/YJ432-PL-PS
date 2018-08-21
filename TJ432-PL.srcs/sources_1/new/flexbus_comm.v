`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: wuhan university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/07/19 10:35:01
// Design Name: 
// Module Name: flexbus_comm
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



module flexbus_comm(
	input [31:0] FB_BASE,

	input FB_CLK,
	input RST_n,
	// input FB_OE,
	input FB_RW,
	input FB_CS,
	input FB_ALE,
//    input FB_BE31_24,
//    input FB_BE23_16,
//    input FB_BE15_8,
//    input FB_BE7_0,
	inout [31:0] FB_AD,
	

	output reg [31:0] FREQ_Cnt_Reg,	//作为计数目标，自己外部计算
	output reg [31:0] BZ_Puty_Reg,
	output reg [31:0] LEDR_Puty_Reg,
	output reg [31:0] LEDG_Puty_Reg,
	output reg [31:0] LEDB_Puty_Reg,
	
	 
	output reg [31:0] MIBUF_DATA_Reg,
	output reg [5:0] MIBUF_ADDR,

	// output reg [3:0] vindex,
	// output reg b,
	
	output reg [11:0] vbuf_offset,
	output reg [31:0] dest_vindex_offset,
	output oddBlock,
	
	output reg [2:0] subband_state,

	input POLY_Done,
	input FDCT_Done,

	input Is_Empty_Wire,
	// output reg [31:0] STEAM_DATA,  //put data into here
	// output reg FIFO_CLK
	
	);

parameter ST_IDLE = 3'd0;
parameter ST_MIBUF = 3'd1;
parameter ST_FDCT = 3'd2;
parameter ST_FBRAM = 3'd3;
parameter ST_PLOY = 3'd4;

wire AD_TRI_n ;//高阻状态标志位,posedge logic
reg ADD_COMF = 1'b0;

(* DONT_TOUCH = "TRUE" *) reg [31:0] FB_AD_reg = 32'b0;
reg [31:0] ip_ADDR = 32'b0;

assign AD_TRI_n = (~FB_ALE) & (ADD_COMF) & (~FB_CS) & (FB_RW);      
assign FB_AD[31:0] = ( AD_TRI_n ) ? FB_AD_reg[31:0] : 32'bz;
   


always@( negedge FB_CLK or negedge RST_n )  begin
	if ( !RST_n ) begin
//        AD_TRI <= 1'b1;
		ip_ADDR[31:0] <= 32'b0;
		ADD_COMF <= 1'b0;
		
		FB_AD_reg[31:0] <= 32'b0;
 
		//register       
		FREQ_Cnt_Reg <= 32'b0;
		BZ_Puty_Reg <= 32'b0;
		LEDR_Puty_Reg <= 32'b0;
		LEDG_Puty_Reg <= 32'b0;
		LEDB_Puty_Reg <= 32'b0;  
		
		subband_state <= ST_IDLE;

		vbuf_offset <= 12'd0;

	end
	else begin

		FB_AD_reg <= FB_AD_reg;

		ip_ADDR <= ip_ADDR;

		ADD_COMF <= ADD_COMF;

		FREQ_Cnt_Reg <= FREQ_Cnt_Reg;
		BZ_Puty_Reg <= BZ_Puty_Reg;
		LEDR_Puty_Reg <= LEDR_Puty_Reg;
		LEDG_Puty_Reg <= LEDG_Puty_Reg;
		LEDB_Puty_Reg <= LEDB_Puty_Reg;

		MIBUF_DATA_Reg <= MIBUF_DATA_Reg;
		MIBUF_ADDR_Reg <= MIBUF_ADDR_Reg;

		subband_state <= subband_state;

		vbuf_offset <= vbuf_offset;
 
		if ( FB_ALE == 1'b1 ) begin  //flexbus_address latch enable
//            AD_TRI <= 1'b1; //  FB_ALE == 1'B1 && FB_CS = X && FB_RW == X && ADD_COMF == X

			// FIFO_CLK <= 1'b1;

			if ( (FB_AD[31:0] & 32'hf0000000) == ( FB_BASE[31:0] & 32'hf0000000 ) ) begin// check base address 
				ADD_COMF <= 1'b1;
				ip_ADDR[31:0] <= FB_AD[31:0];

			end
			else begin // IN ADDRESS LATCH MODE BUT THE ADDRESS IS NOT SELECT THIS FLEXBUS IP
				ADD_COMF <= 1'b0;
				ip_ADDR[31:0] <= 32'b0;
			end
		end // FB_ALE == 1'b1
		else begin //FB_ALE == 1'B0
			if ( ADD_COMF == 1'b1 ) begin //ADDRESS CONFIRM
				if ( FB_CS == 1'b0 ) begin //CS is enable 
					if ( FB_RW == 1'b0 ) begin  //in write mode
					
//                        AD_TRI <= 1'b1; //  FB_ALE == 1'B0 && FB_CS == 1'b0 && FB_RW == 1'b0 && ADD_COMF == 1'b1
						
						casez( ip_ADDR & 32'h0fffffff )
												
							32'b00000: begin
								FREQ_Cnt_Reg[31:0] <= FB_AD[31:0];
							end
							32'b00100:begin
								BZ_Puty_Reg[31:0] <= FB_AD[31:0];
							end
							32'b01000:begin
								LEDR_Puty_Reg[31:0] <= FB_AD[31:0];
							end
							32'b01100:begin
								LEDG_Puty_Reg[31:0] <= FB_AD[31:0];
							end
							32'b10000:begin
								LEDB_Puty_Reg[31:0] <= FB_AD[31:0];
							end
							
							
							32'h0780zzzz:begin
								// STEAM_DATA[31:0] <= FB_AD[31:0];
								// FIFO_CLK <= 1'b0;
								
								if ( (ip_ADDR[13:2]) < 12'd100 ) begin
								
									MIBUF_DATA_Reg[31:0] <= FB_AD[31:0];
									MIBUF_ADDR[5:0] <= ip_ADDR[7:2];

									subband_state <= ST_MIBUF;
								end // if ( (ip_ADDR[13:2]) < 12'd3000 )
								else begin
									MIBUF_DATA_Reg <= MIBUF_DATA_Reg;
									MIBUF_ADDR[11:0] <= MIBUF_ADDR[11:0];

									subband_state <= ST_MIBUF;
								end // else
							end

							32'h07810004:begin
								subband_state <= ST_IDLE;
								vbuf_offset[11:0] <= FB_AD[11:0];							

							end // 32'h07800004:

							32'h07810008:begin
								subband_state <= ST_PLOY;

							end // 32'h07810008:
							
							32'h0781000c:begin
								dest_vindex_offset <= FB_AD;
								subband_state <= ST_IDLE;
							end // 32'h0781000c:

							32'h07810010:begin
								oddBlock <= FB_AD[0];
								subband_state <= ST_FDCT;
							end // 32'h07810010:
							default:begin
							end // default:
						endcase
					end // FB_RW == 1'b0
					
					else if ( FB_RW == 1'b1 ) begin //in read mode
//                        AD_TRI <= 1'b0;     //  FB_ALE == 1'B0 && FB_CS == 1'b0 && FB_RW == 1'b1 && ADD_COMF == 1'b1
						
						casez( ip_ADDR & 32'h0fffffff )
							32'b00000: begin
								FB_AD_reg[31:0] <= FREQ_Cnt_Reg[31:0];
							end
							32'b00100:begin
								FB_AD_reg[31:0] <= BZ_Puty_Reg[31:0];
							end
							32'b01000:begin
								FB_AD_reg[31:0] <= LEDR_Puty_Reg[31:0];
							end
							32'b01100:begin
								FB_AD_reg[31:0] <= LEDG_Puty_Reg[31:0];
							end
							32'b10000:begin
								FB_AD_reg[31:0] <= LEDB_Puty_Reg[31:0];
							end
							
							32'h07810000:begin
								FB_AD_reg[31:0] <= {29'b0,FDCT_Done,POLY_Done,Is_Empty_Wire};
							end


							end // 32'h0782zzzz:

							default:begin
							end // default:
						endcase
					end // FB_RW == 1'b1
					else begin
					end // else
				end  // ( FB_CS == 1'b0 )
				else begin //( FB_CS == 1'b1 )
//                    AD_TRI <= 1'b1; //  FB_ALE == 1'B0 && FB_CS == 1'b1 && FB_RW == X && ADD_COMF == 1'b1
				end
			end //ADDRESS CONFIRM
			else begin //ADDRESS VOTE
//                AD_TRI <= 1'b1; //  FB_ALE == 1'B0 && FB_CS = X && FB_RW == X && ADD_COMF == 1'b0
			end //ADDRESS VOTE
		end // FB_ALE == 1'B0
	end

end
 
	
	
endmodule
