`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/22 19:34:39
// Design Name: 
// Module Name: YJ431_PLTOP
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


module YJ431_PLTOP(
    i_sysclk,
    i_fb_clk,

    i_fb_oen,
    i_fb_rw,
    i_fb_csn,
    i_fb_ale,
    i_fb_ad,

    i_BZ_IO,
    i_LEDR_IO,
    i_LEDG_IO,
    i_LEDB_IO,  

    i_PWM0_CH0,
    i_PWM0_CH1,
    i_PWM0_CH2,
    i_PWM0_CH3,
    i_PWM0_CH0_EN,
    i_PWM0_CH2_EN,
    
    i_QEI0_CH0_PA,
    i_QEI0_CH0_PB
    
);
    
    input i_sysclk;
    input i_fb_clk;

    input i_fb_oen;
    input i_fb_rw;
    input i_fb_csn;
    input i_fb_ale;
    inout [31:0] i_fb_ad;
 
    output i_BZ_IO;
    output i_LEDR_IO;
    output i_LEDG_IO;
    output i_LEDB_IO;   
   
    output i_PWM0_CH0;
    output i_PWM0_CH1;
    output i_PWM0_CH2;
    output i_PWM0_CH3;
    output i_PWM0_CH0_EN;
    output i_PWM0_CH2_EN;
    
    input i_QEI0_CH0_PA;
    input i_QEI0_CH0_PB;

assign i_PWM0_CH0_EN = 1'b1;
assign i_PWM0_CH2_EN = 1'b0;
     
wire [31:0] i_bus_addr;
wire [31:0] i_bus_data;
wire i_bus_read;
wire i_bus_write;
    
    
ip_flexbus i_flexbus(
    .FB_CLK(i_fb_clk),
    .RST_n(1'b1),
    .FB_OE(i_fb_oen),
    .FB_RW(i_fb_rw),
    .FB_CS(i_fb_csn),
    .FB_ALE(i_fb_ale),
    .FB_AD(i_fb_ad),
    
    
    .ip_ADDR(i_bus_addr),
    .ip_DATA(i_bus_data),     
    .ip_Read( i_bus_read ),
    .ip_Write( i_bus_write )
);

wire [31:0] LED_FREQ_Cnt_wire;
wire [31:0] BZ_Puty_wire;
wire [31:0] LEDR_Puty_wire;
wire [31:0] LEDG_Puty_wire;
wire [31:0] LEDB_Puty_wire;


FB_BZLEDREG i_bzledreg(
	.RST_n(1'b1),
	.BUS_ADDR(i_bus_addr),
	.BUS_DATA(i_bus_data),
	.BUS_CS(i_fb_csn),

	.BUS_read(i_bus_read),
	.BUS_write(i_bus_write),

	.BZLED_BASE(10'h180),//0x6000,0000

//Register
	.FREQ_Cnt_Reg(LED_FREQ_Cnt_wire),	//作为计数目标，自己外部计算
	.BZ_Puty_Reg(BZ_Puty_wire),
	.LEDR_Puty_Reg(LEDR_Puty_wire),
	.LEDG_Puty_Reg(LEDG_Puty_wire),
	.LEDB_Puty_Reg(LEDB_Puty_wire)
    );


BZLED i_bzled(
	.RST_n(1'b1),
	.CLK(i_sysclk),
		
	.FREQ_Cnt_Set(LED_FREQ_Cnt_wire),	//作为计数目标，自己外部计算
	.BZ_Puty_Set(BZ_Puty_wire),
	.LEDR_Puty_Set(LEDR_Puty_wire),
	.LEDG_Puty_Set(LEDG_Puty_wire),
	.LEDB_Puty_Set(LEDB_Puty_wire),

	.BZ(i_BZ_IO),
	.LED_R(i_LEDR_IO),
	.LED_G(i_LEDG_IO),
	.LED_B(i_LEDB_IO)
	);

wire [31:0] PWM0_FREQ_Cnt_wire;	
wire [31:0] CH0_duty_wire;
wire [31:0] CH1_duty_wire;
wire [31:0] CH2_duty_wire;
wire [31:0] CH3_duty_wire;
wire [31:0] CH4_duty_wire;
wire [31:0] CH5_duty_wire;
wire [31:0] CH6_duty_wire;
wire [31:0] CH7_duty_wire;


FB_PWMREG i_pwm0reg(
    .RST_n(1'b1),
	.BUS_ADDR(i_bus_addr),
	.BUS_DATA(i_bus_data),
	.BUS_CS(i_fb_csn),
	.BUS_read(i_bus_read),
	.BUS_write(i_bus_write),

	.PWM_BASE(10'h182),

//Register
	.FREQ_Cnt_Reg(PWM0_FREQ_Cnt_wire),	//作为计数目标，自己外部计算
    .CH0_duty_Reg(),
	.CH1_duty_Reg(),
	.CH2_duty_Reg(CH2_duty_wire),
	.CH3_duty_Reg(CH3_duty_wire),
	.CH4_duty_Reg(CH4_duty_wire),
    .CH5_duty_Reg(CH5_duty_wire),
    .CH6_duty_Reg(CH6_duty_wire),
    .CH7_duty_Reg(CH7_duty_wire)
    );
   
PWM i_pwm0(
    
        .CLK(i_sysclk),
        .RST_n(1'b1),
    
    //Register
        .FREQ_Cnt_Set(PWM0_FREQ_Cnt_wire),    //作为计数目标，自己外部计算
        .CH0_duty_Set(CH0_duty_wire),
        .CH1_duty_Set(CH1_duty_wire),
        .CH2_duty_Set(CH2_duty_wire),
        .CH3_duty_Set(CH3_duty_wire),
        .CH4_duty_Set(CH4_duty_wire),
        .CH5_duty_Set(CH5_duty_wire),
        .CH6_duty_Set(CH6_duty_wire),
        .CH7_duty_Set(CH7_duty_wire),
    
    
    //OUTPUT
        .PWM_CH0(i_PWM0_CH0),
        .PWM_CH1(i_PWM0_CH1),
        .PWM_CH2(i_PWM0_CH2),
        .PWM_CH3(i_PWM0_CH3),
        .PWM_CH4(),
        .PWM_CH5(),
        .PWM_CH6(),
        .PWM_CH7()
    
        );
 
wire [31:0] QEI_CLEAR_wire;
wire [31:0] QEI_CH0_wire;
//wire [31:0] QEI_CH1_wire;
//wire [31:0] QEI_CH2_wire;
//wire [31:0] QEI_CH3_wire;
   
 FB_QEIREG i_qei0reg(
    .RST_n(1'b1),
    .BUS_ADDR(i_bus_addr),
    .BUS_DATA(i_bus_data),
    .BUS_CS(i_fb_csn),
    
    .BUS_read(i_bus_read),
    .BUS_write(i_bus_write),
    
    .QEI_BASE(10'h186),
    
    //Register
    .QEI_CLEAR_Reg(QEI_CLEAR_wire),    //是否清零?
    .QEI_CH0_Read(QEI_CH0_wire),    //只读寄存器
    .QEI_CH1_Read(32'hfffffffb),
    .QEI_CH2_Read(32'hfffffffc),
    .QEI_CH3_Read(32'hfffffffd)

            );  
 
 QEI i_qei0(
    .CLK(i_sysclk),
    .RST_n(1'b1),
    
    //Register
    .QEI_CLEAR_Set(QEI_CLEAR_wire),    //是否清零?
    .QEI_CH0_Read(QEI_CH0_wire),    //只读寄存器
    .QEI_CH1_Read(),
    .QEI_CH2_Read(),
    .QEI_CH3_Read(),
        
    .CH0_PHASEA(i_QEI0_CH0_PA),
    .CH0_PHASEB(i_QEI0_CH0_PB),  
    .CH1_PHASEA(1'b0),
    .CH1_PHASEB(1'b0),
    
    .CH2_PHASEA(1'b0),
    .CH2_PHASEB(1'b0),
    .CH3_PHASEA(1'b0),
    .CH3_PHASEB(1'b0)
);  
 
wire [31:0] CTL0_FREQ_wire;
wire [31:0] PID0_AIM_wire;
wire [31:0] PID0_CUR_wire;
wire [31:0] PID0_ERS_wire;
wire [31:0] PID0_KPS_wire;
wire [31:0] PID0_KDS_wire;
wire [31:0] PID0_ERM_wire;
wire [31:0] PID0_KPM_wire;
wire [31:0] PID0_KDM_wire;
wire [31:0] PID0_ERB_wire;
wire [31:0] PID0_KPB_wire;
wire [31:0] PID0_KDB_wire;
wire signed [31:0] PID0_OUT_wire;
     
FB_po3PIDREG i_po3PIDreg0(
	.RST_n(1'b1),
	.BUS_ADDR(i_bus_addr),
	.BUS_DATA(i_bus_data),
	.BUS_CS(i_fb_csn),
	.BUS_read(i_bus_read),
	.BUS_write(i_bus_write),
	.po3PID_BASE(10'h18d),
//Register
	.CTL_FREQ_REG(CTL0_FREQ_wire),
	.PID_AIM_REG(PID0_AIM_wire),
	.PID_CUR_REG(PID0_CUR_wire),
	.PID_ERS_REG(PID0_ERS_wire),
	.PID_KPS_REG(PID0_KPS_wire),
	.PID_KDS_REG(PID0_KDS_wire),
	.PID_ERM_REG(PID0_ERM_wire),
	.PID_KPM_REG(PID0_KPM_wire),
	.PID_KDM_REG(PID0_KDM_wire),
	.PID_ERB_REG(PID0_ERB_wire),
	.PID_KPB_REG(PID0_KPB_wire),
	.PID_KDB_REG(PID0_KDB_wire),
	.PID_OUT_REG(PID0_OUT_wire)
);
     
po3PID i_po3PID0(
    .CLK(i_sysclk),
    .RST_n(1'b1),
    //Register
    .CTL_FREQ_Set(CTL0_FREQ_wire),
    .PID_AIM_Set(PID0_AIM_wire),
    .PID_CUR_Set(PID0_CUR_wire),
    .PID_ERS_Set(PID0_ERS_wire),
    .PID_KPS_Set(PID0_KPS_wire),
    .PID_KDS_Set(PID0_KDS_wire),
    .PID_ERM_Set(PID0_ERM_wire),
    .PID_KPM_Set(PID0_KPM_wire),
    .PID_KDM_Set(PID0_KDM_wire),
    .PID_ERB_Set(PID0_ERB_wire),
    .PID_KPB_Set(PID0_KPB_wire),
    .PID_KDB_Set(PID0_KDB_wire),
    .PID_OUT_REG(PID0_OUT_wire)
); 
     
 
wire [31:0] CTL1_FREQ_wire;   
wire [31:0] PID1_AIM_wire;
wire [31:0] PID1_CUR_wire;
wire [31:0] PID1_ERS_wire;
wire [31:0] PID1_KPS_wire;
wire [31:0] PID1_KDS_wire;
wire [31:0] PID1_ERM_wire;
wire [31:0] PID1_KPM_wire;
wire [31:0] PID1_KDM_wire;
wire [31:0] PID1_ERB_wire;
wire [31:0] PID1_KPB_wire;
wire [31:0] PID1_KDB_wire;
wire signed [31:0] PID1_OUT_wire;
             
FB_po3PIDREG i_po3PIDreg1(
    .RST_n(1'b1),
    .BUS_ADDR(i_bus_addr),
    .BUS_DATA(i_bus_data),
    .BUS_CS(i_fb_csn),
    .BUS_read(i_bus_read),
    .BUS_write(i_bus_write),
    .po3PID_BASE(10'h18E),
    //Register
    .CTL_FREQ_REG(CTL1_FREQ_wire),
    .PID_AIM_REG(PID1_AIM_wire),
    .PID_CUR_REG(),
    .PID_ERS_REG(PID1_ERS_wire),
    .PID_KPS_REG(PID1_KPS_wire),
    .PID_KDS_REG(PID1_KDS_wire),
    .PID_ERM_REG(PID1_ERM_wire),
    .PID_KPM_REG(PID1_KPM_wire),
    .PID_KDM_REG(PID1_KDM_wire),
    .PID_ERB_REG(PID1_ERB_wire),
    .PID_KPB_REG(PID1_KPB_wire),
    .PID_KDB_REG(PID1_KDB_wire),
    .PID_OUT_REG(PID1_OUT_wire)
);
             
po3PID i_po3PID1(
    .CLK(i_sysclk),
    .RST_n(1'b1),  
    //Register
    .CTL_FREQ_Set(CTL1_FREQ_wire),
    .PID_AIM_Set(PID1_AIM_wire),
    .PID_CUR_Set(QEI_CH0_wire), 
    .PID_ERS_Set(PID1_ERS_wire),
    .PID_KPS_Set(PID1_KPS_wire),
    .PID_KDS_Set(PID1_KDS_wire),
    .PID_ERM_Set(PID1_ERM_wire),
    .PID_KPM_Set(PID1_KPM_wire),
    .PID_KDM_Set(PID1_KDM_wire), 
    .PID_ERB_Set(PID1_ERB_wire),
    .PID_KPB_Set(PID1_KPB_wire),
    .PID_KDB_Set(PID1_KDB_wire),
    .PID_OUT_REG(PID1_OUT_wire)
);  

reg signed [31:0] PWM_OUT0;
reg signed [31:0] PWM_OUT1;

reg signed [31:0] motto_result;
reg signed [31:0] pend_result;

reg signed [31:0] CH0_duty_reg;
reg signed [31:0] CH1_duty_reg;

assign CH0_duty_wire = CH0_duty_reg;
assign CH1_duty_wire = CH1_duty_reg;

always @(negedge i_sysclk)
begin
    
    motto_result <= ( PID0_OUT_wire  - PID1_OUT_wire);
    
    if ( motto_result >= 32'd0 &&  motto_result <= 32'd327680000 )
    begin
        CH0_duty_reg <= ( motto_result >> 15 );
        CH1_duty_reg <= 1;
    end
    else if (  motto_result >= -327680000  )
    begin
        CH0_duty_reg <= 1;
        CH1_duty_reg <= ( (-motto_result) >> 15 ) ;
    end
    else if ( motto_result >= 0 )
    begin
        CH0_duty_reg <= 9999;
        CH1_duty_reg <= 1;
    end
    else if ( motto_result < 0  )
    begin
        CH0_duty_reg <= 1;
        CH1_duty_reg <= 9999;   
    end
    else 
    begin
        CH0_duty_reg <= 1;
        CH1_duty_reg <= 1;
    end
end

endmodule



