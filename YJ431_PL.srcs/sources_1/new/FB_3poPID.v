`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WUT
// Engineer: WUT RUIGE LEE
// 
// Create Date: 2018/06/21 17:44:39
// Design Name: 
// Module Name: FB_po3PID
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


module FB_po3PIDREG(
	RST_n,
	BUS_ADDR,
	BUS_DATA,
	BUS_CS,

	BUS_read,
	BUS_write,

	po3PID_BASE,

//Register
	CTL_FREQ_REG,
	PID_AIM_REG,
	PID_CUR_REG,

	PID_ERS_REG,
	PID_KPS_REG,
	PID_KIS_REG,
	PID_KDS_REG,

	PID_ERM_REG,
	PID_KPM_REG,
	PID_KIM_REG,
	PID_KDM_REG,

	PID_ERB_REG,
	PID_KPB_REG,
	PID_KIB_REG,
	PID_KDB_REG,

	PID_OUT_REG
    );



	input RST_n;
    input [31:0] BUS_ADDR;
    inout [31:0] BUS_DATA;
    input BUS_CS;

    input BUS_read;
    input BUS_write;

    input [9:0] po3PID_BASE;

//Register
	output reg [31:0] CTL_FREQ_REG;
	output reg [31:0] PID_AIM_REG;
	output reg [31:0] PID_CUR_REG;

	output reg [31:0] PID_ERS_REG;
	output reg [31:0] PID_KPS_REG;
	output reg [31:0] PID_KIS_REG;
	output reg [31:0] PID_KDS_REG;

	output reg [31:0] PID_ERM_REG;
	output reg [31:0] PID_KPM_REG;
	output reg [31:0] PID_KIM_REG;
	output reg [31:0] PID_KDM_REG;

	output reg [31:0] PID_ERB_REG;
	output reg [31:0] PID_KPB_REG;
	output reg [31:0] PID_KIB_REG;
	output reg [31:0] PID_KDB_REG;

	input [31:0] PID_OUT_REG;
	
	wire AD_TRI_n;//éžé«˜é˜»çŠ¶æ€æ �?�å¿�?�ä½�?
	wire ADD_COMF;
	
	reg [31:0] BUS_DATA_REG = 32'b0;
	
	assign ADD_COMF = ( BUS_ADDR[31:22] == po3PID_BASE[9:0] ) ? 1'b1:1'b0;    //åœ°å€ä»²è£�? 
	assign AD_TRI_n = ADD_COMF & ~BUS_CS & BUS_read ; //æ—¶åºé€»è¾‘åˆ¤æ�?�­æ˜¯å¦è®¾ç½®éžé«˜é˜»ï¼šåŒæ�?�¶æ»¡è¶�?1åœ°å€ï�??2ç‰�?��??‰ï¼�?3å¤–éƒ¨è¯·æ±�?�è�??
	//è¿›å�?�¥éžé«˜é˜»�??ï¼š1 åœ°å€ä»²è£é€šè¿�? 2 ç‰�?��??‰æœ�?�æ�??? 3 ä¸ºå¤–éƒ¨è¯·æ±�?�è¯�??
	//è„±ç¦»é«˜é˜»æ€ï¼š1ç‰�?��??‰å¤±æ�?�ˆè�?�±ç�?? 2åœ°å€å¤±æ�?��? å¤–éƒ¨è¯»å�?�™è¯·æ±‚å¤±æ�?�ˆå®�?�å�?�¨è�?�±ç¦�??
   
	assign BUS_DATA = AD_TRI_n ? BUS_DATA_REG : 32'bz;
    
//å¯„å­˜å™¨è¯»å�??
//å¤–éƒ¨å�?�™å…�?
always@( posedge BUS_CS or negedge RST_n )
    if ( !RST_n ) begin
		CTL_FREQ_REG <= 32'd0;
		PID_AIM_REG <= 32'd0;
		PID_CUR_REG <= 32'd0;

		PID_ERS_REG <= 32'd0;
		PID_KPS_REG <= 32'd0;
		PID_KIS_REG <= 32'd0;
		PID_KDS_REG <= 32'd0;

		PID_ERM_REG <= 32'd0;
		PID_KPM_REG <= 32'd0;
		PID_KIM_REG <= 32'd0;
		PID_KDM_REG <= 32'd0;

		PID_ERB_REG <= 32'd0;
		PID_KPB_REG <= 32'd0;
		PID_KIB_REG <= 32'd0;
		PID_KDB_REG <= 32'd0;
    end
    
    else begin
        if ( ADD_COMF ) begin        //ä»²è£é€šè¿�?�î�???
            if ( BUS_write == 1'b1 ) begin
                case(BUS_ADDR[21:0])
                    22'b0000000: begin    
                    	if ( BUS_DATA[31:0] > 32'd100 ) begin       //pretect   
							CTL_FREQ_REG[31:0] <= BUS_DATA[31:0];
						end 	
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end                
                    22'b0000100: begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG[31:0] <= BUS_DATA[31:0];
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end
                    22'b0001000: begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG[31:0] <= BUS_DATA[31:0];

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end
                    
                    22'b0001100: begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG[31:0] <= BUS_DATA[31:0];
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end
                           
                    22'b0010000: begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG[31:0] <= BUS_DATA[31:0];
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end
                           
                    22'b0010100:begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG[31:0] <= BUS_DATA[31:0];
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;
                    end
                           
                    22'b0011000:begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG[31:0] <= BUS_DATA[31:0];

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;                   	
                    end
                           
                    22'b0011100:begin
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG[31:0] <= BUS_DATA[31:0];
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;  
                    end
                           
					22'b0100000:begin 
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG[31:0] <= BUS_DATA[31:0];
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG; 
					end 

					22'b0100100:begin 
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG[31:0] <= BUS_DATA[31:0];
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;  
					end

					22'b0101000:begin 
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG[31:0] <= BUS_DATA[31:0];

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;  
					end

					22'b0101100:begin 
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG[31:0] <= BUS_DATA[31:0];
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;  
					end

					22'b0110000:begin 
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG[31:0] <= BUS_DATA[31:0];
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG <= PID_KDB_REG;  
					end

					22'b0110100:begin 
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG [31:0] <= BUS_DATA [31:0];
						PID_KDB_REG <= PID_KDB_REG;  
					end

					22'b0111000:begin 
						CTL_FREQ_REG <= CTL_FREQ_REG;
						PID_AIM_REG <= PID_AIM_REG;
						PID_CUR_REG <= PID_CUR_REG;

						PID_ERS_REG <= PID_ERS_REG;
						PID_KPS_REG <= PID_KPS_REG;
						PID_KIS_REG <= PID_KIS_REG;
						PID_KDS_REG <= PID_KDS_REG;

						PID_ERM_REG <= PID_ERM_REG;
						PID_KPM_REG <= PID_KPM_REG;
						PID_KIM_REG <= PID_KIM_REG;
						PID_KDM_REG <= PID_KDM_REG;

						PID_ERB_REG <= PID_ERB_REG;
						PID_KPB_REG <= PID_KPB_REG;
						PID_KIB_REG <= PID_KIB_REG;
						PID_KDB_REG [31:0] <= BUS_DATA [31:0];  
					end
                endcase
            end // if ( BUS_write == 1'b1 )
        end // if ( ADD_COMF )
    end

//å¯„å­˜å™¨è¯»å�??
//å¤–éƒ¨è¯»å�?��?
always@( negedge BUS_CS or negedge RST_n )
    if ( !RST_n ) begin
        BUS_DATA_REG <= 32'b0;
    end // if ( !RST_n )
    
    else begin
        if ( ADD_COMF ) begin        //ä»²è£é€šè¿�?�î�???
            if ( BUS_read == 1'b1 ) begin
                case(BUS_ADDR[21:0])
                	22'b0000000:begin 
						BUS_DATA_REG[31:0] <= CTL_FREQ_REG[31:0];
					end
					22'b0000100:begin
						BUS_DATA_REG[31:0] <= PID_AIM_REG[31:0];
					end
					22'b0001000:begin
						BUS_DATA_REG[31:0] <= PID_CUR_REG[31:0];
					end
					22'b0001100:begin
						BUS_DATA_REG[31:0] <= PID_ERS_REG[31:0];
					end
					22'b0010000:begin
						BUS_DATA_REG[31:0] <= PID_KPS_REG[31:0];
					end
					22'b0010100:begin
						BUS_DATA_REG[31:0] <= PID_KIS_REG[31:0];
					end
					22'b0011000:begin
						BUS_DATA_REG[31:0] <= PID_KDS_REG[31:0];
					end
					22'b0011100:begin
						BUS_DATA_REG[31:0] <= PID_ERM_REG[31:0];
					end
					22'b0100000:begin
						BUS_DATA_REG[31:0] <= PID_KPM_REG[31:0];
					end
					22'b0100100:begin
						BUS_DATA_REG[31:0] <= PID_KIM_REG[31:0];
					end
					22'b0101000:begin
						BUS_DATA_REG[31:0] <= PID_KDM_REG[31:0];
					end
					22'b0101100:begin
						BUS_DATA_REG[31:0] <= PID_ERB_REG[31:0];
					end
					22'b0110000:begin
						BUS_DATA_REG[31:0] <= PID_KPB_REG[31:0];
					end
					22'b0110100:begin
						BUS_DATA_REG[31:0] <= PID_KIB_REG[31:0];
					end
					22'b0111000:begin
						BUS_DATA_REG[31:0] <= PID_KDB_REG[31:0];
					end
					22'b0111100:begin
					   BUS_DATA_REG[31:0] <= PID_OUT_REG[31:0];
					end
                    default:
                        BUS_DATA_REG[31:0] <= 32'hffffffff;
                endcase
            end // if ( BUS_read == 1'b1 )
        end // if ( ADD_COMF )
    end // else

endmodule



module po3PID(

	CLK,
	RST_n,

//Register
	CTL_FREQ_Set,
	PID_AIM_Set,
	PID_CUR_Set,

	PID_ERS_Set,
	PID_KPS_Set,
	PID_KIS_Set,
	PID_KDS_Set,

	PID_ERM_Set,
	PID_KPM_Set,
	PID_KIM_Set,
	PID_KDM_Set,

	PID_ERB_Set,
	PID_KPB_Set,
	PID_KIB_Set,
	PID_KDB_Set,

	PID_OUT_REG

	);

input CLK;
input RST_n;

input [31:0] CTL_FREQ_Set;
input [31:0] PID_AIM_Set;
input [31:0] PID_CUR_Set;

input [31:0] PID_ERS_Set;
input [31:0] PID_KPS_Set;
input [31:0] PID_KIS_Set;
input [31:0] PID_KDS_Set;

input [31:0] PID_ERM_Set;
input [31:0] PID_KPM_Set;
input [31:0] PID_KIM_Set;
input [31:0] PID_KDM_Set;

input [31:0] PID_ERB_Set;
input [31:0] PID_KPB_Set;
input [31:0] PID_KIB_Set;
input [31:0] PID_KDB_Set;

output reg [31:0] PID_OUT_REG;


//add a tick to protect
reg [31:0] CTL_FREQ_REG = 32'd1000000000;
reg signed [31:0] PID_AIM_REG = 32'd0;
reg signed [31:0] PID_CUR_REG = 32'd0;
reg signed [31:0] PID_ERS_REG = 32'd0;
reg signed [31:0] PID_KPS_REG = 32'd0;
reg signed [31:0] PID_KIS_REG = 32'd0;
reg signed [31:0] PID_KDS_REG = 32'd0;
reg signed [31:0] PID_ERM_REG = 32'd0;
reg signed [31:0] PID_KPM_REG = 32'd0;
reg signed [31:0] PID_KIM_REG = 32'd0;
reg signed [31:0] PID_KDM_REG = 32'd0;
reg signed [31:0] PID_ERB_REG = 32'd0;
reg signed [31:0] PID_KPB_REG = 32'd0;
reg signed [31:0] PID_KIB_REG = 32'd0;
reg signed [31:0] PID_KDB_REG = 32'd0;

//add a negedge eage tick to protect
always @(negedge CLK or negedge RST_n)begin
	if ( !RST_n )begin
		CTL_FREQ_REG <= 32'd1000000000;
		PID_AIM_REG <= 32'd0;
		PID_CUR_REG <= 32'd0;
		PID_ERS_REG <= 32'd0;
		PID_KPS_REG <= 32'd0; 
		PID_KIS_REG <= 32'd0;
		PID_KDS_REG <= 32'd0;
		PID_ERM_REG <= 32'd0;
		PID_KPM_REG <= 32'd0;
		PID_KIM_REG <= 32'd0;
		PID_KDM_REG <= 32'd0;
		PID_ERB_REG <= 32'd0;
		PID_KPB_REG <= 32'd0;
		PID_KIB_REG <= 32'd0;
		PID_KDB_REG <= 32'd0;
	end // if ( !RST_n )
	else begin
		CTL_FREQ_REG <= CTL_FREQ_Set;
		
		PID_AIM_REG <= PID_AIM_Set;
		PID_CUR_REG <= PID_CUR_Set;
		
		PID_ERS_REG <= PID_ERS_Set;
		PID_KPS_REG <= PID_KPS_Set; 
		PID_KIS_REG <= PID_KIS_Set;
		PID_KDS_REG <= PID_KDS_Set;
		
		PID_ERM_REG <= PID_ERM_Set;
		PID_KPM_REG <= PID_KPM_Set;
		PID_KIM_REG <= PID_KIM_Set;
		PID_KDM_REG <= PID_KDM_Set;
		
		PID_ERB_REG <= PID_ERB_Set;
		PID_KPB_REG <= PID_KPB_Set;
		PID_KIB_REG <= PID_KIB_Set;
		PID_KDB_REG <= PID_KDB_Set;
	end 
end // always @(negedge CLK or negedge RST_n)

//Control Frequence

reg [31:0] ctl_cnt = 32'd0;
reg signed [31:0] ERROR[2:0];

reg signed [31:0] KP_CAL32_REG = 32'd0;     //PµÄ32Î»Ñ¡¶¨
// reg signed [31:0] KP_OUT32_REG = 32'd0;     //P¼ÆËã½á¹û

reg [63:0] KP_CAL_PRE[31:0];

//reg signed [63:0] KI_CAL64_REG = 64'd0;     //IµÄ64Î»À©Õ¹
//reg signed [63:0] KI_SUM64_REG = 64'd0;     //I¼ÆËã½á¹û
//reg signed [63:0] KI_OUT64_REG = 64'd0;

reg signed [31:0] KD_CAL32_REG = 32'd0;         //DµÄ32Î»Ñ¡¶¨
reg signed [31:0] KD_DIF32_REG = 32'd0;         //²î·Ö½á¹û
// reg signed [31:0] KD_OUT32_REG = 32'd0;         //D¼ÆËã½á¹û
reg [63:0] KD_CAL_PRE[31:0];


reg signed [63:0] ERR0_CAL64_REG = 64'd0;       //Æ«²îµÄ64Î»À©Õ¹

reg signed [31:0] PID_NERS_REG = 32'd0;
reg signed [31:0] PID_NERM_REG = 32'd0;
reg signed [31:0] PID_NERB_REG = 32'd0;

reg clk_pre = 1'b0;

always@ ( posedge CLK or negedge RST_n ) begin
    if ( !RST_n ) begin
        clk_pre <= 1'b0;
    end
    else begin
        clk_pre <= ~clk_pre;
    end  
end

always@ ( posedge clk_pre or negedge RST_n )begin
	if ( !RST_n ) begin 
		ctl_cnt <= 32'd0;
        ERROR[0] <= 32'd0;
        ERROR[1] <= 32'd0;
        ERROR[2] <= 32'd0;
        
        KP_CAL_PRE[0] <= 32'd0;
        KD_CAL_PRE[0] <= 32'd0;
        
        KP_CAL_PRE[1] <= 32'd0;
        KD_CAL_PRE[1] <= 32'd0;
        
        KP_CAL_PRE[2] <= 32'd0;
        KD_CAL_PRE[2] <= 32'd0;
        
        KP_CAL_PRE[3] <= 32'd0;
        KD_CAL_PRE[3] <= 32'd0;
        
        KP_CAL_PRE[4] <= 32'd0;
        KD_CAL_PRE[4] <= 32'd0;
        
        KP_CAL_PRE[5] <= 32'd0;
        KD_CAL_PRE[5] <= 32'd0;
        
        KP_CAL_PRE[6] <= 32'd0;
        KD_CAL_PRE[6] <= 32'd0;
        
        KP_CAL_PRE[7] <= 32'd0;
        KD_CAL_PRE[7] <= 32'd0;
        
        KP_CAL_PRE[8] <= 32'd0;
        KD_CAL_PRE[8] <= 32'd0;
        
        KP_CAL_PRE[9] <= 32'd0;
        KD_CAL_PRE[9] <= 32'd0;
        
        KP_CAL_PRE[10] <= 32'd0;
        KD_CAL_PRE[10] <= 32'd0;
        
        KP_CAL_PRE[11] <= 32'd0;
        KD_CAL_PRE[11] <= 32'd0;
        
        KP_CAL_PRE[12] <= 32'd0;
        KD_CAL_PRE[12] <= 32'd0;
        
        KP_CAL_PRE[13] <= 32'd0;
        KD_CAL_PRE[13] <= 32'd0;
        
        KP_CAL_PRE[14] <= 32'd0;
        KD_CAL_PRE[14] <= 32'd0;
        
        KP_CAL_PRE[15] <= 32'd0;
        KD_CAL_PRE[15] <= 32'd0;
        
        KP_CAL_PRE[16] <= 32'd0;
        KD_CAL_PRE[16] <= 32'd0;
        
        KP_CAL_PRE[17] <= 32'd0;
        KD_CAL_PRE[17] <= 32'd0;
        
        KP_CAL_PRE[18] <= 32'd0;
        KD_CAL_PRE[18] <= 32'd0;
        
        KP_CAL_PRE[19] <= 32'd0;
        KD_CAL_PRE[19] <= 32'd0;
        
        KP_CAL_PRE[20] <= 32'd0;
        KD_CAL_PRE[20] <= 32'd0;
        
        KP_CAL_PRE[21] <= 32'd0;
        KD_CAL_PRE[21] <= 32'd0;
        
        KP_CAL_PRE[22] <= 32'd0;
        KD_CAL_PRE[22] <= 32'd0;
        
        KP_CAL_PRE[23] <= 32'd0;
        KD_CAL_PRE[23] <= 32'd0;
        
        KP_CAL_PRE[24] <= 32'd0;
        KD_CAL_PRE[24] <= 32'd0;
        
        KP_CAL_PRE[25] <= 32'd0;
        KD_CAL_PRE[25] <= 32'd0;
        
        KP_CAL_PRE[26] <= 32'd0;
        KD_CAL_PRE[26] <= 32'd0;
        
        KP_CAL_PRE[27] <= 32'd0;
        KD_CAL_PRE[27] <= 32'd0;
        
        KP_CAL_PRE[28] <= 32'd0;
        KD_CAL_PRE[28] <= 32'd0;
        
        KP_CAL_PRE[29] <= 32'd0;
        KD_CAL_PRE[29] <= 32'd0;
        
        KP_CAL_PRE[30] <= 32'd0;
        KD_CAL_PRE[30] <= 32'd0;
        
        KP_CAL_PRE[31] <= 32'd0;
        KD_CAL_PRE[31] <= 32'd0;

        PID_NERS_REG <= 32'd0;
        PID_NERM_REG <= 32'd0;
        PID_NERB_REG <= 32'd0;
	end

	else begin		
		if ( ctl_cnt == 32'd0 ) begin //µÚÒ»²½ ¼ÆËãerror
			ctl_cnt <= ctl_cnt + 32'd1;
	       
            ERROR[0][31:0] <= PID_CUR_REG[31:0] - PID_AIM_REG[31:0];
            ERROR[1][31:0] <= ERROR[0][31:0];
            ERROR[2][31:0] <= ERROR[1][31:0];
            
            PID_NERS_REG <= -PID_ERS_REG;
            PID_NERM_REG <= -PID_ERM_REG;
            PID_NERB_REG <= -PID_ERB_REG;
			
			
		end // if ( ctl_cnt == 32'd0 )end
		else if ( ctl_cnt == 32'd1 ) begin    //¼ÆËã²î·Ö½á¹û£¨32Î»£©
			ctl_cnt <= ctl_cnt + 32'd1;
			
			KD_DIF32_REG [31:0] <=  ERROR[0][31:0] - ERROR[1][31:0];
			
			if (  ERROR[0] < PID_ERS_REG && ERROR[0] > PID_NERS_REG ) begin
			
			     KP_CAL32_REG <= PID_KPS_REG;
			     KD_CAL32_REG <= PID_KDS_REG;
			end
			
			else if ( ERROR[0] < PID_ERM_REG && ERROR[0] > PID_NERM_REG ) begin
                 KP_CAL32_REG <= PID_KPM_REG;
                 KD_CAL32_REG <= PID_KDM_REG;
			end
			
			else begin
                 KP_CAL32_REG <= PID_KPB_REG;
                 KD_CAL32_REG <= PID_KDB_REG;
			end
			
			
		end // else if ( ctl_cnt == 32'd1 )
		else if ( ctl_cnt == 32'd2 ) begin	//first tick of mul? KP*err   KD*diff
			ctl_cnt <= ctl_cnt + 32'd1;
			
		
			KP_CAL_PRE[0] <= KP_CAL32_REG[0] ? ERROR[0][31:0]: 32'd0;
			KD_CAL_PRE[0] <= KD_CAL32_REG[0] ? KD_DIF32_REG[31:0] : 32'd0;
			
			KP_CAL_PRE[1] <= KP_CAL32_REG[1] ? { ERROR[0][30:0],1'b0 } : 32'd0;
            KD_CAL_PRE[1] <= KD_CAL32_REG[1] ? { KD_DIF32_REG[30:0],1'b0 }: 32'd0;
            
            KP_CAL_PRE[2] <= KP_CAL32_REG[2] ? { ERROR[0][29:0],2'b0 } : 32'd0;
            KD_CAL_PRE[2] <= KD_CAL32_REG[2] ? { KD_DIF32_REG[29:0],2'b0 }: 32'd0;
            
            KP_CAL_PRE[3] <= KP_CAL32_REG[3] ? { ERROR[0][28:0],3'b0 } : 32'd0;
            KD_CAL_PRE[3] <= KD_CAL32_REG[3] ? { KD_DIF32_REG[28:0],3'b0 }: 32'd0;
            
            KP_CAL_PRE[4] <= KP_CAL32_REG[4] ? { ERROR[0][27:0],4'b0 } : 32'd0;
            KD_CAL_PRE[4] <= KD_CAL32_REG[4] ? { KD_DIF32_REG[27:0],4'b0 }: 32'd0;
            
            KP_CAL_PRE[5] <= KP_CAL32_REG[5] ? { ERROR[0][26:0],5'b0 } : 32'd0;
            KD_CAL_PRE[5] <= KD_CAL32_REG[5] ? { KD_DIF32_REG[26:0],5'b0 }: 32'd0;
			
			KP_CAL_PRE[6] <= KP_CAL32_REG[6] ? { ERROR[0][25:0],6'b0 } : 32'd0;
            KD_CAL_PRE[6] <= KD_CAL32_REG[6] ? { KD_DIF32_REG[25:0],6'b0 }: 32'd0;
            
           	KP_CAL_PRE[7] <= KP_CAL32_REG[7] ? { ERROR[0][24:0],7'b0 } : 32'd0;
            KD_CAL_PRE[7] <= KD_CAL32_REG[7] ? { KD_DIF32_REG[24:0],7'b0 }: 32'd0;
            			
            KP_CAL_PRE[8] <= KP_CAL32_REG[8] ? { ERROR[0][23:0],8'b0 } : 32'd0;
            KD_CAL_PRE[8] <= KD_CAL32_REG[8] ? { KD_DIF32_REG[23:0],8'b0 }: 32'd0;
            
            KP_CAL_PRE[9] <= KP_CAL32_REG[9] ? { ERROR[0][22:0],9'b0 } : 32'd0;
            KD_CAL_PRE[9] <= KD_CAL32_REG[9] ? { KD_DIF32_REG[22:0],9'b0 }: 32'd0;
            
            KP_CAL_PRE[10] <= KP_CAL32_REG[10] ? { ERROR[0][21:0],10'b0 } : 32'd0;
            KD_CAL_PRE[10] <= KD_CAL32_REG[10] ? { KD_DIF32_REG[21:0],10'b0 }: 32'd0;
            
            KP_CAL_PRE[11] <= KP_CAL32_REG[11] ? { ERROR[0][20:0],11'b0 } : 32'd0;
            KD_CAL_PRE[11] <= KD_CAL32_REG[11] ? { KD_DIF32_REG[20:0],11'b0 }: 32'd0;
            
            KP_CAL_PRE[12] <= KP_CAL32_REG[12] ? { ERROR[0][19:0],12'b0 } : 32'd0;
            KD_CAL_PRE[12] <= KD_CAL32_REG[12] ? { KD_DIF32_REG[19:0],12'b0 }: 32'd0;
            
            KP_CAL_PRE[13] <= KP_CAL32_REG[13] ? { ERROR[0][18:0],13'b0 } : 32'd0;
            KD_CAL_PRE[13] <= KD_CAL32_REG[13] ? { KD_DIF32_REG[18:0],13'b0 }: 32'd0;
            
            KP_CAL_PRE[14] <= KP_CAL32_REG[14] ? { ERROR[0][17:0],14'b0 } : 32'd0;
            KD_CAL_PRE[14] <= KD_CAL32_REG[14] ? { KD_DIF32_REG[17:0],14'b0 }: 32'd0;
            
            KP_CAL_PRE[15] <= KP_CAL32_REG[15] ? { ERROR[0][16:0],15'b0 } : 32'd0;
            KD_CAL_PRE[15] <= KD_CAL32_REG[15] ? { KD_DIF32_REG[16:0],15'b0 }: 32'd0;			
            
            KP_CAL_PRE[16] <= KP_CAL32_REG[16] ? { ERROR[0][15:0],16'b0 } : 32'd0;
            KD_CAL_PRE[16] <= KD_CAL32_REG[16] ? { KD_DIF32_REG[15:0],16'b0 }: 32'd0;
                        
            KP_CAL_PRE[17] <= KP_CAL32_REG[17] ? { ERROR[0][14:0],17'b0 } : 32'd0;
            KD_CAL_PRE[17] <= KD_CAL32_REG[17] ? { KD_DIF32_REG[14:0],17'b0 }: 32'd0;
                        			
            KP_CAL_PRE[18] <= KP_CAL32_REG[18] ? { ERROR[0][13:0],18'b0 } : 32'd0;
            KD_CAL_PRE[18] <= KD_CAL32_REG[18] ? { KD_DIF32_REG[13:0],18'b0 }: 32'd0;
                        			
            KP_CAL_PRE[19] <= KP_CAL32_REG[19] ? { ERROR[0][12:0],19'b0 } : 32'd0;
            KD_CAL_PRE[19] <= KD_CAL32_REG[19] ? { KD_DIF32_REG[12:0],19'b0 }: 32'd0;
                        			
            KP_CAL_PRE[20] <= KP_CAL32_REG[20] ? { ERROR[0][11:0],20'b0 } : 32'd0;
            KD_CAL_PRE[20] <= KD_CAL32_REG[20] ? { KD_DIF32_REG[11:0],20'b0 }: 32'd0;
                        			
            KP_CAL_PRE[21] <= KP_CAL32_REG[21] ? { ERROR[0][10:0],21'b0 } : 32'd0;
            KD_CAL_PRE[21] <= KD_CAL32_REG[21] ? { KD_DIF32_REG[10:0],21'b0 }: 32'd0;
                        			
            KP_CAL_PRE[22] <= KP_CAL32_REG[22] ? { ERROR[0][9:0],22'b0 } : 32'd0;
            KD_CAL_PRE[22] <= KD_CAL32_REG[22] ? { KD_DIF32_REG[9:0],22'b0 }: 32'd0;
                        			
            KP_CAL_PRE[23] <= KP_CAL32_REG[23] ? { ERROR[0][8:0],23'b0 } : 32'd0;
            KD_CAL_PRE[23] <= KD_CAL32_REG[23] ? { KD_DIF32_REG[8:0],23'b0 }: 32'd0;
                        			
            KP_CAL_PRE[24] <= KP_CAL32_REG[24] ? { ERROR[0][7:0],24'b0 } : 32'd0;
            KD_CAL_PRE[24] <= KD_CAL32_REG[24] ? { KD_DIF32_REG[7:0],24'b0 }: 32'd0;
                        			
            KP_CAL_PRE[25] <= KP_CAL32_REG[25] ? { ERROR[0][6:0],25'b0 } : 32'd0;
            KD_CAL_PRE[25] <= KD_CAL32_REG[25] ? { KD_DIF32_REG[6:0],25'b0 }: 32'd0;
                        			
            KP_CAL_PRE[26] <= KP_CAL32_REG[26] ? { ERROR[0][5:0],26'b0 } : 32'd0;
            KD_CAL_PRE[26] <= KD_CAL32_REG[26] ? { KD_DIF32_REG[5:0],26'b0 }: 32'd0;
                        			
            KP_CAL_PRE[27] <= KP_CAL32_REG[27] ? { ERROR[0][4:0],27'b0 } : 32'd0;
            KD_CAL_PRE[27] <= KD_CAL32_REG[27] ? { KD_DIF32_REG[4:0],27'b0 }: 32'd0;
                        			
            KP_CAL_PRE[28] <= KP_CAL32_REG[28] ? { ERROR[0][3:0],28'b0 } : 32'd0;
            KD_CAL_PRE[28] <= KD_CAL32_REG[28] ? { KD_DIF32_REG[3:0],28'b0 }: 32'd0;
                        			
            KP_CAL_PRE[29] <= KP_CAL32_REG[29] ? { ERROR[0][2:0],29'b0 } : 32'd0;
            KD_CAL_PRE[29] <= KD_CAL32_REG[29] ? { KD_DIF32_REG[2:0],29'b0 }: 32'd0;
                        			
            KP_CAL_PRE[30] <= KP_CAL32_REG[30] ? { ERROR[0][1:0],30'b0 } : 32'd0;
            KD_CAL_PRE[30] <= KD_CAL32_REG[30] ? { KD_DIF32_REG[1:0],30'b0 }: 32'd0;
                        			
            KP_CAL_PRE[31] <= KP_CAL32_REG[31] ? { ERROR[0][0],31'b0 } : 32'd0;
            KD_CAL_PRE[31] <= KD_CAL32_REG[31] ? { KD_DIF32_REG[0],31'b0 }: 32'd0;
            		
		end // else if ( ctl_cnt == 32'd2 )
		else if ( ctl_cnt == 32'd3 ) begin		//second tick KP*ERR KD*DIFF
			ctl_cnt <= ctl_cnt + 32'd1;

			KP_CAL_PRE[0] <= KP_CAL_PRE[0] + KP_CAL_PRE[1];
			KD_CAL_PRE[0] <= KD_CAL_PRE[0] + KD_CAL_PRE[1];

			KP_CAL_PRE[2] <= KP_CAL_PRE[2] + KP_CAL_PRE[3];
			KD_CAL_PRE[2] <= KD_CAL_PRE[2] + KD_CAL_PRE[3];

			KP_CAL_PRE[4] <= KP_CAL_PRE[4] + KP_CAL_PRE[5];
			KD_CAL_PRE[4] <= KD_CAL_PRE[4] + KD_CAL_PRE[5];

			KP_CAL_PRE[6] <= KP_CAL_PRE[6] + KP_CAL_PRE[7];
			KD_CAL_PRE[6] <= KD_CAL_PRE[6] + KD_CAL_PRE[7];

			KP_CAL_PRE[8] <= KP_CAL_PRE[8] + KP_CAL_PRE[9];
			KD_CAL_PRE[8] <= KD_CAL_PRE[8] + KD_CAL_PRE[9];

			KP_CAL_PRE[10] <= KP_CAL_PRE[10] + KP_CAL_PRE[11];
			KD_CAL_PRE[10] <= KD_CAL_PRE[10] + KD_CAL_PRE[11];

			KP_CAL_PRE[12] <= KP_CAL_PRE[12] + KP_CAL_PRE[13];
			KD_CAL_PRE[12] <= KD_CAL_PRE[12] + KD_CAL_PRE[13];

			KP_CAL_PRE[14] <= KP_CAL_PRE[14] + KP_CAL_PRE[15];
			KD_CAL_PRE[14] <= KD_CAL_PRE[14] + KD_CAL_PRE[15];

			KP_CAL_PRE[16] <= KP_CAL_PRE[16] + KP_CAL_PRE[17];
			KD_CAL_PRE[16] <= KD_CAL_PRE[16] + KD_CAL_PRE[17];

			KP_CAL_PRE[18] <= KP_CAL_PRE[18] + KP_CAL_PRE[19];
			KD_CAL_PRE[18] <= KD_CAL_PRE[18] + KD_CAL_PRE[19];

			KP_CAL_PRE[20] <= KP_CAL_PRE[20] + KP_CAL_PRE[21];
			KD_CAL_PRE[20] <= KD_CAL_PRE[20] + KD_CAL_PRE[21];

			KP_CAL_PRE[22] <= KP_CAL_PRE[22] + KP_CAL_PRE[23];
			KD_CAL_PRE[22] <= KD_CAL_PRE[22] + KD_CAL_PRE[23];

			KP_CAL_PRE[24] <= KP_CAL_PRE[24] + KP_CAL_PRE[25];
			KD_CAL_PRE[24] <= KD_CAL_PRE[24] + KD_CAL_PRE[25];

			KP_CAL_PRE[26] <= KP_CAL_PRE[26] + KP_CAL_PRE[27];
			KD_CAL_PRE[26] <= KD_CAL_PRE[26] + KD_CAL_PRE[27];

			KP_CAL_PRE[28] <= KP_CAL_PRE[28] + KP_CAL_PRE[29];
			KD_CAL_PRE[28] <= KD_CAL_PRE[28] + KD_CAL_PRE[29];

			KP_CAL_PRE[30] <= KP_CAL_PRE[30] + KP_CAL_PRE[31];
			KD_CAL_PRE[30] <= KD_CAL_PRE[30] + KD_CAL_PRE[31];

		end // else if ( ctl_cnt == 32'd3 )
		else if ( ctl_cnt == 32'd4 ) begin	//tick 3
			ctl_cnt <= ctl_cnt + 32'd1;

			KP_CAL_PRE[0] <= KP_CAL_PRE[0] + KP_CAL_PRE[2];
			KD_CAL_PRE[0] <= KD_CAL_PRE[0] + KD_CAL_PRE[2];

			KP_CAL_PRE[4] <= KP_CAL_PRE[4] + KP_CAL_PRE[6];
			KD_CAL_PRE[4] <= KD_CAL_PRE[4] + KD_CAL_PRE[6];

			KP_CAL_PRE[8] <= KP_CAL_PRE[8] + KP_CAL_PRE[10];
			KD_CAL_PRE[8] <= KD_CAL_PRE[8] + KD_CAL_PRE[10];

			KP_CAL_PRE[12] <= KP_CAL_PRE[12] + KP_CAL_PRE[14];
			KD_CAL_PRE[12] <= KD_CAL_PRE[12] + KD_CAL_PRE[14];

			KP_CAL_PRE[16] <= KP_CAL_PRE[16] + KP_CAL_PRE[18];
			KD_CAL_PRE[16] <= KD_CAL_PRE[16] + KD_CAL_PRE[18];

			KP_CAL_PRE[20] <= KP_CAL_PRE[20] + KP_CAL_PRE[22];
			KD_CAL_PRE[20] <= KD_CAL_PRE[20] + KD_CAL_PRE[22];

			KP_CAL_PRE[24] <= KP_CAL_PRE[24] + KP_CAL_PRE[26];
			KD_CAL_PRE[24] <= KD_CAL_PRE[24] + KD_CAL_PRE[26];

			KP_CAL_PRE[28] <= KP_CAL_PRE[28] + KP_CAL_PRE[30];
			KD_CAL_PRE[28] <= KD_CAL_PRE[28] + KD_CAL_PRE[30];

		end // else if ( ctl_cnt == 32'd4 )
		else if ( ctl_cnt == 32'd5 ) begin
			ctl_cnt <= ctl_cnt + 32'd1;

			KP_CAL_PRE[0] <= KP_CAL_PRE[0] + KP_CAL_PRE[4];
			KD_CAL_PRE[0] <= KD_CAL_PRE[0] + KD_CAL_PRE[4];

			KP_CAL_PRE[8] <= KP_CAL_PRE[8] + KP_CAL_PRE[12];
			KD_CAL_PRE[8] <= KD_CAL_PRE[8] + KD_CAL_PRE[12];

			KP_CAL_PRE[16] <= KP_CAL_PRE[16] + KP_CAL_PRE[20];
			KD_CAL_PRE[16] <= KD_CAL_PRE[16] + KD_CAL_PRE[20];

			KP_CAL_PRE[24] <= KP_CAL_PRE[24] + KP_CAL_PRE[28];
			KD_CAL_PRE[24] <= KD_CAL_PRE[24] + KD_CAL_PRE[28];

		end // else if ( ctl_cnt == 32'd5 )
		else if ( ctl_cnt == 32'd6 ) begin
			ctl_cnt <= ctl_cnt + 32'd1;

			KP_CAL_PRE[0] <= KP_CAL_PRE[0] + KP_CAL_PRE[8];
			KD_CAL_PRE[0] <= KD_CAL_PRE[0] + KD_CAL_PRE[8];

			KP_CAL_PRE[16] <= KP_CAL_PRE[16] + KP_CAL_PRE[24];
			KD_CAL_PRE[16] <= KD_CAL_PRE[16] + KD_CAL_PRE[24];
		end // else if ( ctl_cnt == 32'd6 )
		else if ( ctl_cnt == 32'd7 ) begin
			ctl_cnt <= ctl_cnt + 32'd1;

			KP_CAL_PRE[0] <= KP_CAL_PRE[0] + KP_CAL_PRE[16];
			KD_CAL_PRE[0] <= KD_CAL_PRE[0] + KD_CAL_PRE[16];
		end // else if ( ctl_cnt == 32'd7 )
		else if ( ctl_cnt == 32'd8 ) begin
			ctl_cnt <= ctl_cnt + 32'd1;

			PID_OUT_REG <= KP_CAL_PRE[0] + KD_CAL_PRE[0];
		end // else if ( ctl_cnt == 32'd8 )
		// else if ( ctl_cnt == 32'd9 ) begin
		// 	ctl_cnt <= ctl_cnt + 32'd1;
		// end // else if ( ctl_cnt == 32'd9 )
		// else if ( ctl_cnt == 32'd10 ) begin
		// 	ctl_cnt <= ctl_cnt + 32'd1;
		// end // else if ( ctl_cnt == 32'd10 )
		// else if ( ctl_cnt == 32'd11 ) begin
		// 	ctl_cnt <= ctl_cnt + 32'd1;
		// end // else if ( ctl_cnt == 32'd11 )
		// else if ( ctl_cnt == 32'd12 ) begin
		// 	ctl_cnt <= ctl_cnt + 32'd1;
		// end // else if ( ctl_cnt == 32'd12 )
		else if ( ctl_cnt >= CTL_FREQ_REG )	begin
			ctl_cnt <= 32'd0;
		end // else if ( ctl_cnt >= CTL_FREQ_REG )
		else begin // < CTL_FREQ_REG
			ctl_cnt <= ctl_cnt + 32'd1;
		end


	end
end // always@ ( posedge CLK or negedge RST_n )

endmodule

