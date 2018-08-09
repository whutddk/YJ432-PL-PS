`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhn university of technology
// Engineer: RUIGE LEE
// 
// Create Date: 2018/08/09 11:21:50
// Design Name: 
// Module Name: mp3_mid
// Project Name: TJ432-B
// Target Devices: XC7A35T
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


module mp3_mid(
    input MP3_CLK,
    input RST_n,
    input [31:0] RAM_data,
    input [11:0] RAM_addr,
    output FIFO_EN,
    output [15:0] FIFO_DATA
    );
    
polyphase 
(
input CLK,    // Clock
input RST_n,  // Asynchronous reset active low

//state
input [3:0] subband_state,

//CTL
input [3:0] vindex,
input b,
output reg IP_Done,

//ram operate
inout [11:0] Ram_addrA,
inout [11:0] Ram_addrB,
input [31:0] Ram_dataA,
input [31:0] Ram_dataB,

//Rom operate
inout [8:0] Rom_addrA,
inout [8:0] Rom_addrB,
input [31:0] Rom_dataA,
input [31:0] Rom_dataB,    

//FIFO pcm DATA
output reg [31:0] fifo_data,
output reg fifo_enable,

inout [63:0] sum1L_pre,
inout [31:0] mult1L_A,
inout [31:0] mult1L_B,
input [63:0] mult_out1L,

inout [63:0] sum2L_pre,
inout [31:0] mult2L_A,
inout [31:0] mult2L_B,
input [63:0] mult_out2L,

inout [63:0] sum1R_pre,
inout [31:0] mult1R_A,
inout [31:0] mult1R_B,
input [63:0] mult_out1R,

inout [63:0] sum2R_pre,
inout [31:0] mult2R_A,
inout [31:0] mult2R_B,
input [63:0] mult_out2R
    
    );
    
    
    
    
    
endmodule
