`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/21 10:07:43
// Design Name: 
// Module Name: FB_SRAM
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


module FB_SRAM(    
    input RST_n,
    input FB_CS_n,
    input [31:0] FB_ADDR,
    
    input [7:0] ADDR_set,
    
    inout [31:0] FB_DATA,

    input r_Read,
    input r_Write,
    
    output [18:0] SRAM_ADDR,
    inout [7:0] SRAM_DQ,
    output SRAM_CE_n,
    output SRAM_OE_n,
    output SRAM_WE_n
    );
    
reg [31:0] FB_DATA_reg = 32'b0;  
reg [18:0] SRAM_ADDR_reg = 19'b0;
reg [7:0] SRAM_DQ_reg = 8'b0;  

   
   
//assign SRAM_ADDR[18:0] = SRAM_ADDR_reg[18:0];

//assign SRAM_OE = SRAM_OE_reg;
//assign SRAM_WE = SRAM_WE_reg;

assign SRAM_OE_n = ~r_Read;
assign SRAM_WE_n = ~r_Write;
assign SRAM_CE_n = ~FB_CS_n; 

assign SRAM_DQ[7:0] = r_Write ? SRAM_DQ_reg[7:0] : 8'bz;
assign FB_DATA[31:0] = r_Read && ~r_Write ? FB_DATA_reg[31:0]  : 32'bz;
assign SRAM_ADDR[18:0] = FB_ADDR [18:0];

always@( negedge FB_CS_n or negedge RST_n )

    if ( !RST_n )
    
    begin
        FB_DATA_reg <= 32'b0;
        SRAM_ADDR_reg <= 19'b0;
        SRAM_DQ_reg <= 8'b0;
    end
    
    else if ( ADDR_set[7:0] == FB_ADDR [31:24]) //地址仲裁
    
    begin
        if ( r_Write ) //外部请求写SRAM，写的优先级高
        begin
            SRAM_DQ_reg[7:0] <= FB_DATA[7:0];
        end
       
        else if ( r_Read )  //外部请求读SRAM
        begin
            FB_DATA_reg[7:0] <= SRAM_DQ[7:0];
        end  
    end
    

    
    
    
    
endmodule
