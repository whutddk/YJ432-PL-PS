//////////////////////////////////////////////////////////////////////////////////
// Company:  WUT 
// Engineer: WUT RUIGE LEE
// Create Date: 2018/06/21 17:44:39
// Last Modified by:   WUT_Ruige_Lee
// Last Modified time: 2019-01-12 16:20:11
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: FB_3poPID
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


//¼Ä´æÆ÷¶ÁÐ´
//Íâ²¿¶Á³ö
always@( negedge BUS_CS or negedge RST_n )
    if ( !RST_n ) begin
        BUS_DATA_REG <= 32'b0;
    end // if ( !RST_n )
    
    else begin
        if ( ADD_COMF ) begin       //ÖÙ²ÃÍ¨¹ý
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
//						BUS_DATA_REG[31:0] <= PID_KIS_REG[31:0];
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
//						BUS_DATA_REG[31:0] <= PID_KIM_REG[31:0];
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
//						BUS_DATA_REG[31:0] <= PID_KIB_REG[31:0];
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
//	PID_KIS_Set,
	PID_KDS_Set,

	PID_ERM_Set,
	PID_KPM_Set,
//	PID_KIM_Set,
	PID_KDM_Set,

	PID_ERB_Set,
	PID_KPB_Set,
//	PID_KIB_Set,
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
//input [31:0] PID_KIS_Set;
input [31:0] PID_KDS_Set;

input [31:0] PID_ERM_Set;
input [31:0] PID_KPM_Set;
//input [31:0] PID_KIM_Set;
input [31:0] PID_KDM_Set;

input [31:0] PID_ERB_Set;
input [31:0] PID_KPB_Set;
//input [31:0] PID_KIB_Set;
input [31:0] PID_KDB_Set;

output reg [31:0] PID_OUT_REG;


//add a tick to protect
reg [31:0] CTL_FREQ_REG = 32'd1000000000;
reg signed [31:0] PID_AIM_REG = 32'd0;
reg signed [31:0] PID_CUR_REG = 32'd0;
reg signed [31:0] PID_ERS_REG = 32'd0;
reg signed [31:0] PID_KPS_REG = 32'd0;
//reg signed [31:0] PID_KIS_REG = 32'd0;
reg signed [31:0] PID_KDS_REG = 32'd0;
reg signed [31:0] PID_ERM_REG = 32'd0;
reg signed [31:0] PID_KPM_REG = 32'd0;
//reg signed [31:0] PID_KIM_REG = 32'd0;
reg signed [31:0] PID_KDM_REG = 32'd0;
reg signed [31:0] PID_ERB_REG = 32'd0;
reg signed [31:0] PID_KPB_REG = 32'd0;
//reg signed [31:0] PID_KIB_REG = 32'd0;
reg signed [31:0] PID_KDB_REG = 32'd0;

//add a negedge eage tick to protect
always @(negedge CLK or negedge RST_n)begin
	if ( !RST_n )begin
		CTL_FREQ_REG <= 32'd1000000000;
		PID_AIM_REG <= 32'd0;
		PID_CUR_REG <= 32'd0;
		PID_ERS_REG <= 32'd0;
		PID_KPS_REG <= 32'd0; 
//		PID_KIS_REG <= 32'd0;
		PID_KDS_REG <= 32'd0;
		PID_ERM_REG <= 32'd0;
		PID_KPM_REG <= 32'd0;
//		PID_KIM_REG <= 32'd0;
		PID_KDM_REG <= 32'd0;
		PID_ERB_REG <= 32'd0;
		PID_KPB_REG <= 32'd0;
//		PID_KIB_REG <= 32'd0;
		PID_KDB_REG <= 32'd0;
	end // if ( !RST_n )
	else begin
		CTL_FREQ_REG <= CTL_FREQ_Set;
		
		PID_AIM_REG <= PID_AIM_Set;
		PID_CUR_REG <= PID_CUR_Set;
		
		PID_ERS_REG <= PID_ERS_Set;
		PID_KPS_REG <= PID_KPS_Set; 
//		PID_KIS_REG <= PID_KIS_Set;
		PID_KDS_REG <= PID_KDS_Set;
		
		PID_ERM_REG <= PID_ERM_Set;
		PID_KPM_REG <= PID_KPM_Set;
//		PID_KIM_REG <= PID_KIM_Set;
		PID_KDM_REG <= PID_KDM_Set;
		
		PID_ERB_REG <= PID_ERB_Set;
		PID_KPB_REG <= PID_KPB_Set;
//		PID_KIB_REG <= PID_KIB_Set;
		PID_KDB_REG <= PID_KDB_Set;
	end 
end // always @(negedge CLK or negedge RST_n)

//Control Frequence

reg [31:0] ctl_cnt = 32'd0;
reg signed [31:0] ERROR[2:0];

reg signed [31:0] KP_CAL32_REG = 32'd0;     //PÂµÃ„32ÃŽÂ»Ã‘Â¡Â¶Â¨
reg signed [31:0] KD_CAL32_REG = 32'd0;         //DÂµÃ„32ÃŽÂ»Ã‘Â¡Â¶Â¨
reg signed [31:0] KD_DIF32_REG = 32'd0;         //Â²Ã®Â·Ã–Â½Ã¡Â¹Ã»
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

        PID_NERS_REG <= 32'd0;
        PID_NERM_REG <= 32'd0;
        PID_NERB_REG <= 32'd0;
	end

	else begin		
		if ( ctl_cnt == 32'd0 ) begin //first tick 1£º calculate error and calculate the negetive of error border
			ctl_cnt <= ctl_cnt + 32'd1;
	       
            ERROR[0][31:0] <= PID_CUR_REG[31:0] - PID_AIM_REG[31:0];
            ERROR[1][31:0] <= ERROR[0][31:0];
            ERROR[2][31:0] <= ERROR[1][31:0];
            
            PID_NERS_REG <= -PID_ERS_REG;
            PID_NERM_REG <= -PID_ERM_REG;
            PID_NERB_REG <= -PID_ERB_REG;
					
		end // if ( ctl_cnt == 32'd0 )end
		else if ( ctl_cnt == 32'd1 ) begin    //second tick 3 : calculate different of error and decide which parameter to use
			ctl_cnt <= ctl_cnt + 32'd1;
			
			KD_DIF32_REG [31:0] <=  ERROR[0][31:0] - ERROR[1][31:0];

			if (  ERROR[0] > PID_ERB_REG || ERROR[0] < PID_NERB_REG ) begin
			
			     KP_CAL32_REG <= PID_KPB_REG;
			     KD_CAL32_REG <= PID_KDB_REG;
			end

			else if ( ERROR[0] > PID_ERM_REG || ERROR[0] < PID_NERM_REG ) begin
                 KP_CAL32_REG <= PID_KPM_REG;
                 KD_CAL32_REG <= PID_KDM_REG;
			end

			else if ( ERROR[0] > PID_ERS_REG || ERROR[0] < PID_NERS_REG )begin
                 KP_CAL32_REG <= PID_KPS_REG;
                 KD_CAL32_REG <= PID_KDS_REG;
			end
			else begin
                KP_CAL32_REG <= 32'b0;
                KD_CAL32_REG <= 32'b0;
			end

		end // else if ( ctl_cnt == 32'd1 )
		else if ( ctl_cnt == 32'd2 ) begin	// third tick 5: mul? KP*err + KD*diff
			ctl_cnt <= ctl_cnt + 32'd1;

			PID_OUT_REG <= KP_CAL32_REG * ERROR[0] + KD_CAL32_REG * KD_DIF32_REG;

		end // else if ( ctl_cnt == 32'd2 )

		else if ( ctl_cnt >= CTL_FREQ_REG )	begin
			ctl_cnt <= 32'd0;
		end // else if ( ctl_cnt >= CTL_FREQ_REG )	
		else begin // < CTL_FREQ_REG
			ctl_cnt <= ctl_cnt + 32'd1;
		end

	end
end // always@ ( posedge CLK or negedge RST_n )

endmodule

