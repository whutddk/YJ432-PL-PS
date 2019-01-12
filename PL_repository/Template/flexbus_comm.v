//////////////////////////////////////////////////////////////////////////////////
// Company: wuhan university of technology
// Engineer: RUIGE LEE
// Create Date: 2018/07/19 10:35:01
// Last Modified by:   WUT_Ruige_Lee
// Last Modified time: 2019-01-12 15:50:17
// Email: 295054118@whut.edu.cn
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
 

`timescale 1ns / 1ps


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
	





	output reg [31:0] FREQ_Cnt_Reg,	//��Ϊ����Ŀ�꣬�Լ��ⲿ����
	output reg [31:0] BZ_Puty_Reg,
	output reg [31:0] LEDR_Puty_Reg,
	output reg [31:0] LEDG_Puty_Reg,
	output reg [31:0] LEDB_Puty_Reg,
	
	
	);


wire AD_TRI_n ;//����״̬��־λ,posedge logic
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

		 
		if ( FB_ALE == 1'b1 ) begin  //flexbus_address latch enable
//            AD_TRI <= 1'b1; //  FB_ALE == 1'B1 && FB_CS = X && FB_RW == X && ADD_COMF == X


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
								
							end

							default:begin
							end // default:
						endcase
					end // FB_RW == 1'b0
					
					else if ( FB_RW == 1'b1 ) begin //in read mode
//                        AD_TRI <= 1'b0;     //  FB_ALE == 1'B0 && FB_CS == 1'b0 && FB_RW == 1'b1 && ADD_COMF == 1'b1
						
						casez( ip_ADDR & 32'h0fffffff )
							32'b00000: begin
								FB_AD_reg[31:0] <= FREQ_Cnt_Reg[31:0];
							end // 32'b00000:
							32'b00100:begin
								FB_AD_reg[31:0] <= BZ_Puty_Reg[31:0];
							end // 32'b00100:
							32'b01000:begin
								FB_AD_reg[31:0] <= LEDR_Puty_Reg[31:0];
							end // 32'b01000:
							32'b01100:begin
								FB_AD_reg[31:0] <= LEDG_Puty_Reg[31:0];
							end // 32'b01100:
							32'b10000:begin
								FB_AD_reg[31:0] <= LEDB_Puty_Reg[31:0];
							end // 32'b10000:

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