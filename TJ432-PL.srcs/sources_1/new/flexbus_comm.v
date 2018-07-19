`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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
    input FB_OE,
    input FB_RW,
    input FB_CS,
    input FB_ALE,
//    input FB_BE31_24,
//    input FB_BE23_16,
//    input FB_BE15_8,
//    input FB_BE7_0,
    inout [31:0] FB_AD,
    
    output reg [31:0] REG0
    
    
    );

reg AD_TRI = 1'b1;//高阻状态标志位,posedge logic
reg ADD_COMF = 1'b0;

reg [31:0] FB_AD_reg = 32'b0;
reg [31:0] ip_ADDR = 32'b0;
           
assign FB_AD[31:0] = ( AD_TRI ) ? 32'bz : FB_AD_reg[31:0];
   
   

always@( negedge FB_CLK or negedge RST_n )  begin
    if ( !RST_n ) begin
    
    end
    else begin
        if ( FB_ALE == 1'b1 ) begin  //flexbus_address latch enable
            AD_TRI <= 1'b1; //  FB_ALE == 1'B1 && FB_CS = X && FB_RW == X && ADD_COMF == X
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
                    
                        AD_TRI <= 1'b1; //  FB_ALE == 1'B0 && FB_CS == 1'b0 && FB_RW == 1'b0 && ADD_COMF == 1'b1
                        
                        case( ip_ADDR & 32'h0fffffff )
                            32'd0: begin
                                REG0[31:0] <= FB_AD[31:0];
                            end
                            32'd4:begin
                            end
                        endcase
                    end // FB_RW == 1'b0
                    
                    else if ( FB_RW == 1'b1 ) begin //in read mode
                        AD_TRI <= 1'b0;     //  FB_ALE == 1'B0 && FB_CS == 1'b0 && FB_RW == 1'b1 && ADD_COMF == 1'b1
                        
                        case( ip_ADDR & 32'h0fffffff )
                            32'd0: begin
                                FB_AD_reg[31:0] <= REG0[31:0];
                            end
                            32'd4:begin
                            end
                        endcase
                    end // FB_RW == 1'b1
                end  // ( FB_CS == 1'b0 )
                else begin //( FB_CS == 1'b1 )
                    AD_TRI <= 1'b1; //  FB_ALE == 1'B0 && FB_CS == 1'b1 && FB_RW == X && ADD_COMF == 1'b1
                end
            end //ADDRESS CONFIRM
            else begin //ADDRESS VOTE
                AD_TRI <= 1'b1; //  FB_ALE == 1'B0 && FB_CS = X && FB_RW == X && ADD_COMF == 1'b0
            end //ADDRESS VOTE
        end // FB_ALE == 1'B0
    end

end
 
    
    
endmodule
