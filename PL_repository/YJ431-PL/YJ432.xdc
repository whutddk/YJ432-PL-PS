## This file is a general .xdc for the CmodA7 rev. B

## To use it in a project:

## - uncomment the lines corresponding to used pins

## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project



# Clock signal 100 MHz

set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS33} [get_ports i_sysclk];
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports i_sysclk];

# Flexbus
## -CLK_OUT 40MHz
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS33} [get_ports i_fb_clk];
create_clock -period 33.333 -name fb_clk_pin -waveform {0.000 16.666} -add [get_ports i_fb_clk];

## FB_OE
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports i_fb_oen];
=======
#set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports i_fb_oen]
>>>>>>> f96ff61... 开始布线测试:TJ432.xdc

## FB_RW
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports i_fb_rw];

## FB_CS
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33} [get_ports i_fb_csn];
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_fb_csn_IBUF];
## FB_ALE
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports i_fb_ale];

## FB_AD[31:0]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[0]}];
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[1]}];
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[2]}];
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[3]}];
set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[4]}];
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[5]}];
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[6]}];
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[7]}];
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[8]}];
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[9]}];
set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[10]}];
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[11]}];
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[12]}];
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[13]}];
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[14]}];
set_property -dict {PACKAGE_PIN B9 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[15]}];
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[16]}];
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[17]}];
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[18]}];
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[19]}];
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[20]}];
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[21]}];
set_property -dict {PACKAGE_PIN C8 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[22]}];
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[23]}];
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[24]}];
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[25]}];
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[26]}];
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[27]}];
set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[28]}];
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[29]}];
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[30]}];
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[31]}];


## LEDs
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports i_LEDB_IO];
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports i_LEDG_IO];
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports i_LEDR_IO];


##PL_BZ
set_property -dict {PACKAGE_PIN M12 IOSTANDARD LVCMOS33} [get_ports i_BZ_IO];

##PWM0
set_property -dict {PACKAGE_PIN T8 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH0];    #BANK14 IO35
set_property -dict {PACKAGE_PIN R8 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH1];    #BANK14 IO33
set_property -dict {PACKAGE_PIN P10 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH2];    #BANK14 IO20
set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH3];    #BANK14 IO26

set_property -dict {PACKAGE_PIN N9 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH0_EN];  #BANK14 IO28
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH2_EN];  #BANK14 IO37

##QEI0
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports i_QEI0_CH0_PA];    #BANK14 IO10
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports i_QEI0_CH0_PB];    #BANK14 IO12

# Buttons

#set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { btn0 }]; #IO_L19N_T3_VREF_16 Sch=btn[0]

#set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; #IO_L19P_T3_16 Sch=btn[1]

# PMOD1
set_property -dict {PACKAGE_PIN P6 IOSTANDARD LVCMOS33} [get_ports i_I2SMCLK]
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports i_I2SLRCK]
set_property -dict {PACKAGE_PIN R5 IOSTANDARD LVCMOS33} [get_ports i_I2SBSCK]
set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS33} [get_ports i_I2STXD]

#set_property -dict {PACKAGE_PIN P8 IOSTANDARD LVCMOS33} [get_ports PMOD1_7];    #BANK14
#set_property -dict {PACKAGE_PIN T7 IOSTANDARD LVCMOS33} [get_ports PMOD1_8];    #BANK14
#set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS33} [get_ports PMOD1_9];    #BANK14
#set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS33} [get_ports PMOD1_10];    #BANK14

# PMOD2
#set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports PMOD2_1];    #BANK34
#set_property -dict {PACKAGE_PIN R3 IOSTANDARD LVCMOS33} [get_ports PMOD2_2];    #BANK34
#set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports PMOD2_3];    #BANK34
#set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports PMOD2_4];    #BANK34

#set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS33} [get_ports PMOD2_7];    #BANK34
#set_property -dict {PACKAGE_PIN M5 IOSTANDARD LVCMOS33} [get_ports PMOD2_8];    #BANK34
#set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports PMOD2_9];    #BANK34
#set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS33} [get_ports PMOD2_10];    #BANK34

## PMOD3
#set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports PMOD3_1];    #BANK34
#set_property -dict {PACKAGE_PIN N1 IOSTANDARD LVCMOS33} [get_ports PMOD3_2];    #BANK34
#set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports PMOD3_3];    #BANK34
#set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVCMOS33} [get_ports PMOD3_4];    #BANK34

#set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports PMOD3_7];    #BANK34
#set_property -dict {PACKAGE_PIN P4 IOSTANDARD LVCMOS33} [get_ports PMOD3_8];    #BANK34
#set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports PMOD3_9];    #BANK34
#set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports PMOD3_10];    #BANK34

# Analog XADC Pins

# Only declare these if you want to use pins 15 and 16 as single ended analog inputs. pin 15 -> vaux4, pin16 -> vaux12

#set_property -dict { PACKAGE_PIN G2    IOSTANDARD LVCMOS33 } [get_ports { xa_n[0] }]; #IO_L1N_T0_AD4N_35 Sch=ain_n[15]

#set_property -dict { PACKAGE_PIN G3    IOSTANDARD LVCMOS33 } [get_ports { xa_p[0] }]; #IO_L1P_T0_AD4P_35 Sch=ain_p[15]

#set_property -dict { PACKAGE_PIN J2    IOSTANDARD LVCMOS33 } [get_ports { xa_n[1] }]; #IO_L2N_T0_AD12N_35 Sch=ain_n[16]

#set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports { xa_p[1] }]; #IO_L2P_T0_AD12P_35 Sch=ain_p[16]



## Cellular RAM

#set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[0]  }]; #IO_L11P_T1_SRCC_14 Sch=sram- a[0]

#set_property -dict { PACKAGE_PIN M19   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[1]  }]; #IO_L11N_T1_SRCC_14 Sch=sram- a[1]

#set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[2]  }]; #IO_L12N_T1_MRCC_14 Sch=sram- a[2]

#set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[3]  }]; #IO_L13P_T2_MRCC_14 Sch=sram- a[3]

#set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[4]  }]; #IO_L13N_T2_MRCC_14 Sch=sram- a[4]

#set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[5]  }]; #IO_L14P_T2_SRCC_14 Sch=sram- a[5]

#set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[6]  }]; #IO_L14N_T2_SRCC_14 Sch=sram- a[6]

#set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[7]  }]; #IO_L16N_T2_A15_D31_14 Sch=sram- a[7]

#set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[8]  }]; #IO_L15P_T2_DQS_RDWR_B_14 Sch=sram- a[8]

#set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[9]  }]; #IO_L15N_T2_DQS_DOUT_CSO_B_14 Sch=sram- a[9]

#set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[10] }]; #IO_L16P_T2_CSI_B_14 Sch=sram- a[10]

#set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[11] }]; #IO_L17P_T2_A14_D30_14 Sch=sram- a[11]

#set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[12] }]; #IO_L17N_T2_A13_D29_14 Sch=sram- a[12]

#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[13] }]; #IO_L18P_T2_A12_D28_14 Sch=sram- a[13]

#set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[14] }]; #IO_L18N_T2_A11_D27_14 Sch=sram- a[14]

#set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[15] }]; #IO_L19P_T3_A10_D26_14 Sch=sram- a[15]

#set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[16] }]; #IO_L20P_T3_A08_D24_14 Sch=sram- a[16]

#set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[17] }]; #IO_L20N_T3_A07_D23_14 Sch=sram- a[17]

#set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { MemAdr[18] }]; #IO_L21P_T3_DQS_14 Sch=sram- a[18]

#set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports { MemDB[0]   }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=sram-dq[0]

#set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { MemDB[1]   }]; #IO_L22P_T3_A05_D21_14 Sch=sram-dq[1]

#set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { MemDB[2]   }]; #IO_L22N_T3_A04_D20_14 Sch=sram-dq[2]

#set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports { MemDB[3]   }]; #IO_L23P_T3_A03_D19_14 Sch=sram-dq[3]

#set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { MemDB[4]   }]; #IO_L23N_T3_A02_D18_14 Sch=sram-dq[4]

#set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { MemDB[5]   }]; #IO_L24P_T3_A01_D17_14 Sch=sram-dq[5]

#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { MemDB[6]   }]; #IO_L24N_T3_A00_D16_14 Sch=sram-dq[6]

#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { MemDB[7]   }]; #IO_25_14 Sch=sram-dq[7]

#set_property -dict { PACKAGE_PIN P19   IOSTANDARD LVCMOS33 } [get_ports { RamOEn     }]; #IO_L10P_T1_D14_14 Sch=sram-oe

#set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { RamWEn     }]; #IO_L10N_T1_D15_14 Sch=sram-we

#set_property -dict { PACKAGE_PIN N19   IOSTANDARD LVCMOS33 } [get_ports { RamCEn     }]; #IO_L9N_T1_DQS_D13_14 Sch=sram-ce


set_property CONFIG_MODE SPIx4 [current_design]





<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
=======


set_property SLEW FAST [get_ports {i_fb_ad[31]}]
set_property SLEW FAST [get_ports {i_fb_ad[30]}]
set_property SLEW FAST [get_ports {i_fb_ad[29]}]
set_property SLEW FAST [get_ports {i_fb_ad[28]}]
set_property SLEW FAST [get_ports {i_fb_ad[27]}]
set_property SLEW FAST [get_ports {i_fb_ad[26]}]
set_property SLEW FAST [get_ports {i_fb_ad[25]}]
set_property SLEW FAST [get_ports {i_fb_ad[24]}]
set_property SLEW FAST [get_ports {i_fb_ad[23]}]
set_property SLEW FAST [get_ports {i_fb_ad[22]}]
set_property SLEW FAST [get_ports {i_fb_ad[21]}]
set_property SLEW FAST [get_ports {i_fb_ad[20]}]
set_property SLEW FAST [get_ports {i_fb_ad[19]}]
set_property SLEW FAST [get_ports {i_fb_ad[18]}]
set_property SLEW FAST [get_ports {i_fb_ad[17]}]
set_property SLEW FAST [get_ports {i_fb_ad[16]}]
set_property SLEW FAST [get_ports {i_fb_ad[15]}]
set_property SLEW FAST [get_ports {i_fb_ad[14]}]
set_property SLEW FAST [get_ports {i_fb_ad[13]}]
set_property SLEW FAST [get_ports {i_fb_ad[12]}]
set_property SLEW FAST [get_ports {i_fb_ad[11]}]
set_property SLEW FAST [get_ports {i_fb_ad[10]}]
set_property SLEW FAST [get_ports {i_fb_ad[9]}]
set_property SLEW FAST [get_ports {i_fb_ad[8]}]
set_property SLEW FAST [get_ports {i_fb_ad[7]}]
set_property SLEW FAST [get_ports {i_fb_ad[6]}]
set_property SLEW FAST [get_ports {i_fb_ad[5]}]
set_property SLEW FAST [get_ports {i_fb_ad[4]}]
set_property SLEW FAST [get_ports {i_fb_ad[3]}]
set_property SLEW FAST [get_ports {i_fb_ad[2]}]
set_property SLEW FAST [get_ports {i_fb_ad[1]}]
set_property SLEW FAST [get_ports {i_fb_ad[0]}]


set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
>>>>>>> 45c08ed... 芯片配置电压:TJ432.xdc
=======

<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
=======
>>>>>>> b871821... 重新排版，fifo_cnt提早跳变，找不到原因:TJ432.xdc

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
=======
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_0]
>>>>>>> b871821... 重新排版，fifo_cnt提早跳变，找不到原因:TJ432.xdc
=======
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
>>>>>>> dee9854... 这一步状态机正常，但这是else的问题还是dont touch的问题？:TJ432.xdc
=======
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
>>>>>>> 45c7484... RAM地址滞后poly_cnt一拍:TJ432.xdc
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list i_fb_clk_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {i_mp3/i_ROM/Rom_dataB_wire[0]} {i_mp3/i_ROM/Rom_dataB_wire[1]} {i_mp3/i_ROM/Rom_dataB_wire[2]} {i_mp3/i_ROM/Rom_dataB_wire[3]} {i_mp3/i_ROM/Rom_dataB_wire[4]} {i_mp3/i_ROM/Rom_dataB_wire[5]} {i_mp3/i_ROM/Rom_dataB_wire[6]} {i_mp3/i_ROM/Rom_dataB_wire[7]} {i_mp3/i_ROM/Rom_dataB_wire[8]} {i_mp3/i_ROM/Rom_dataB_wire[9]} {i_mp3/i_ROM/Rom_dataB_wire[10]} {i_mp3/i_ROM/Rom_dataB_wire[11]} {i_mp3/i_ROM/Rom_dataB_wire[12]} {i_mp3/i_ROM/Rom_dataB_wire[13]} {i_mp3/i_ROM/Rom_dataB_wire[14]} {i_mp3/i_ROM/Rom_dataB_wire[15]} {i_mp3/i_ROM/Rom_dataB_wire[16]} {i_mp3/i_ROM/Rom_dataB_wire[17]} {i_mp3/i_ROM/Rom_dataB_wire[18]} {i_mp3/i_ROM/Rom_dataB_wire[19]} {i_mp3/i_ROM/Rom_dataB_wire[20]} {i_mp3/i_ROM/Rom_dataB_wire[21]} {i_mp3/i_ROM/Rom_dataB_wire[22]} {i_mp3/i_ROM/Rom_dataB_wire[23]} {i_mp3/i_ROM/Rom_dataB_wire[24]} {i_mp3/i_ROM/Rom_dataB_wire[25]} {i_mp3/i_ROM/Rom_dataB_wire[26]} {i_mp3/i_ROM/Rom_dataB_wire[27]} {i_mp3/i_ROM/Rom_dataB_wire[28]} {i_mp3/i_ROM/Rom_dataB_wire[29]} {i_mp3/i_ROM/Rom_dataB_wire[30]} {i_mp3/i_ROM/Rom_dataB_wire[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 9 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {i_mp3/Rom_addrA_wire[0]} {i_mp3/Rom_addrA_wire[1]} {i_mp3/Rom_addrA_wire[2]} {i_mp3/Rom_addrA_wire[3]} {i_mp3/Rom_addrA_wire[4]} {i_mp3/Rom_addrA_wire[5]} {i_mp3/Rom_addrA_wire[6]} {i_mp3/Rom_addrA_wire[7]} {i_mp3/Rom_addrA_wire[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {i_mp3/Rom_dataA_wire[0]} {i_mp3/Rom_dataA_wire[1]} {i_mp3/Rom_dataA_wire[2]} {i_mp3/Rom_dataA_wire[3]} {i_mp3/Rom_dataA_wire[4]} {i_mp3/Rom_dataA_wire[5]} {i_mp3/Rom_dataA_wire[6]} {i_mp3/Rom_dataA_wire[7]} {i_mp3/Rom_dataA_wire[8]} {i_mp3/Rom_dataA_wire[9]} {i_mp3/Rom_dataA_wire[10]} {i_mp3/Rom_dataA_wire[11]} {i_mp3/Rom_dataA_wire[12]} {i_mp3/Rom_dataA_wire[13]} {i_mp3/Rom_dataA_wire[14]} {i_mp3/Rom_dataA_wire[15]} {i_mp3/Rom_dataA_wire[16]} {i_mp3/Rom_dataA_wire[17]} {i_mp3/Rom_dataA_wire[18]} {i_mp3/Rom_dataA_wire[19]} {i_mp3/Rom_dataA_wire[20]} {i_mp3/Rom_dataA_wire[21]} {i_mp3/Rom_dataA_wire[22]} {i_mp3/Rom_dataA_wire[23]} {i_mp3/Rom_dataA_wire[24]} {i_mp3/Rom_dataA_wire[25]} {i_mp3/Rom_dataA_wire[26]} {i_mp3/Rom_dataA_wire[27]} {i_mp3/Rom_dataA_wire[28]} {i_mp3/Rom_dataA_wire[29]} {i_mp3/Rom_dataA_wire[30]} {i_mp3/Rom_dataA_wire[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 9 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {i_mp3/Rom_addrB_wire[0]} {i_mp3/Rom_addrB_wire[1]} {i_mp3/Rom_addrB_wire[2]} {i_mp3/Rom_addrB_wire[3]} {i_mp3/Rom_addrB_wire[4]} {i_mp3/Rom_addrB_wire[5]} {i_mp3/Rom_addrB_wire[6]} {i_mp3/Rom_addrB_wire[7]} {i_mp3/Rom_addrB_wire[8]}]]
=======
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {i_mp3/i_polyhpase/MC2S_cnt[1]} {i_mp3/i_polyhpase/MC2S_cnt[2]} {i_mp3/i_polyhpase/MC2S_cnt[3]}]]
=======
set_property port_width 9 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {i_flexbus/MC2S_sub_cnt_reg[8]_0[0]} {i_flexbus/MC2S_sub_cnt_reg[8]_0[1]} {i_flexbus/MC2S_sub_cnt_reg[8]_0[2]} {i_flexbus/MC2S_sub_cnt_reg[8]_0[3]} {i_flexbus/MC2S_sub_cnt_reg[8]_0[4]} {i_flexbus/MC2S_sub_cnt_reg[8]_0[5]} {i_flexbus/MC2S_sub_cnt_reg[8]_0[6]} {i_flexbus/MC2S_sub_cnt_reg[8]_0[7]} {i_flexbus/MC2S_sub_cnt_reg[8]_0[8]}]]
>>>>>>> dee9854... 这一步状态机正常，但这是else的问题还是dont touch的问题？:TJ432.xdc
=======
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {i_mp3/i_polyhpase/MC2S_cnt[0]} {i_mp3/i_polyhpase/MC2S_cnt[1]} {i_mp3/i_polyhpase/MC2S_cnt[2]} {i_mp3/i_polyhpase/MC2S_cnt[3]}]]
>>>>>>> 45c7484... RAM地址滞后poly_cnt一拍:TJ432.xdc
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 9 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {i_mp3/i_polyhpase/MC2S_sub_cnt[0]} {i_mp3/i_polyhpase/MC2S_sub_cnt[1]} {i_mp3/i_polyhpase/MC2S_sub_cnt[2]} {i_mp3/i_polyhpase/MC2S_sub_cnt[3]} {i_mp3/i_polyhpase/MC2S_sub_cnt[4]} {i_mp3/i_polyhpase/MC2S_sub_cnt[5]} {i_mp3/i_polyhpase/MC2S_sub_cnt[6]} {i_mp3/i_polyhpase/MC2S_sub_cnt[7]} {i_mp3/i_polyhpase/MC2S_sub_cnt[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 9 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {i_mp3/i_polyhpase/poly_cnt[0]} {i_mp3/i_polyhpase/poly_cnt[1]} {i_mp3/i_polyhpase/poly_cnt[2]} {i_mp3/i_polyhpase/poly_cnt[3]} {i_mp3/i_polyhpase/poly_cnt[4]} {i_mp3/i_polyhpase/poly_cnt[5]} {i_mp3/i_polyhpase/poly_cnt[6]} {i_mp3/i_polyhpase/poly_cnt[7]} {i_mp3/i_polyhpase/poly_cnt[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 3 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {subband_state_Wire[0]} {subband_state_Wire[1]} {subband_state_Wire[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 12 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {RAM_ADDR_B_Wire[0]} {RAM_ADDR_B_Wire[1]} {RAM_ADDR_B_Wire[2]} {RAM_ADDR_B_Wire[3]} {RAM_ADDR_B_Wire[4]} {RAM_ADDR_B_Wire[5]} {RAM_ADDR_B_Wire[6]} {RAM_ADDR_B_Wire[7]} {RAM_ADDR_B_Wire[8]} {RAM_ADDR_B_Wire[9]} {RAM_ADDR_B_Wire[10]} {RAM_ADDR_B_Wire[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
set_property port_width 5 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {i_polyhpase/MC2S_sub_cnt[0]} {i_polyhpase/MC2S_sub_cnt[1]} {i_polyhpase/MC2S_sub_cnt[2]} {i_polyhpase/MC2S_sub_cnt[3]} {i_polyhpase/MC2S_sub_cnt[4]}]]
>>>>>>> b871821... 重新排版，fifo_cnt提早跳变，找不到原因:TJ432.xdc
=======
set_property port_width 3 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {subband_state_Wire[0]} {subband_state_Wire[1]} {subband_state_Wire[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list i_mp3/i_polyhpase/fifo_enable_i_1_n_0]]
>>>>>>> dee9854... 这一步状态机正常，但这是else的问题还是dont touch的问题？:TJ432.xdc
=======
set_property port_width 12 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {FB_RAM_ADDR_Wire[0]} {FB_RAM_ADDR_Wire[1]} {FB_RAM_ADDR_Wire[2]} {FB_RAM_ADDR_Wire[3]} {FB_RAM_ADDR_Wire[4]} {FB_RAM_ADDR_Wire[5]} {FB_RAM_ADDR_Wire[6]} {FB_RAM_ADDR_Wire[7]} {FB_RAM_ADDR_Wire[8]} {FB_RAM_ADDR_Wire[9]} {FB_RAM_ADDR_Wire[10]} {FB_RAM_ADDR_Wire[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 12 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {vbuf_offset_Wire[0]} {vbuf_offset_Wire[1]} {vbuf_offset_Wire[2]} {vbuf_offset_Wire[3]} {vbuf_offset_Wire[4]} {vbuf_offset_Wire[5]} {vbuf_offset_Wire[6]} {vbuf_offset_Wire[7]} {vbuf_offset_Wire[8]} {vbuf_offset_Wire[9]} {vbuf_offset_Wire[10]} {vbuf_offset_Wire[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {RAM_DATA_OUTB_Wire[0]} {RAM_DATA_OUTB_Wire[1]} {RAM_DATA_OUTB_Wire[2]} {RAM_DATA_OUTB_Wire[3]} {RAM_DATA_OUTB_Wire[4]} {RAM_DATA_OUTB_Wire[5]} {RAM_DATA_OUTB_Wire[6]} {RAM_DATA_OUTB_Wire[7]} {RAM_DATA_OUTB_Wire[8]} {RAM_DATA_OUTB_Wire[9]} {RAM_DATA_OUTB_Wire[10]} {RAM_DATA_OUTB_Wire[11]} {RAM_DATA_OUTB_Wire[12]} {RAM_DATA_OUTB_Wire[13]} {RAM_DATA_OUTB_Wire[14]} {RAM_DATA_OUTB_Wire[15]} {RAM_DATA_OUTB_Wire[16]} {RAM_DATA_OUTB_Wire[17]} {RAM_DATA_OUTB_Wire[18]} {RAM_DATA_OUTB_Wire[19]} {RAM_DATA_OUTB_Wire[20]} {RAM_DATA_OUTB_Wire[21]} {RAM_DATA_OUTB_Wire[22]} {RAM_DATA_OUTB_Wire[23]} {RAM_DATA_OUTB_Wire[24]} {RAM_DATA_OUTB_Wire[25]} {RAM_DATA_OUTB_Wire[26]} {RAM_DATA_OUTB_Wire[27]} {RAM_DATA_OUTB_Wire[28]} {RAM_DATA_OUTB_Wire[29]} {RAM_DATA_OUTB_Wire[30]} {RAM_DATA_OUTB_Wire[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {RAM_DATA_OUTA_Wire[0]} {RAM_DATA_OUTA_Wire[1]} {RAM_DATA_OUTA_Wire[2]} {RAM_DATA_OUTA_Wire[3]} {RAM_DATA_OUTA_Wire[4]} {RAM_DATA_OUTA_Wire[5]} {RAM_DATA_OUTA_Wire[6]} {RAM_DATA_OUTA_Wire[7]} {RAM_DATA_OUTA_Wire[8]} {RAM_DATA_OUTA_Wire[9]} {RAM_DATA_OUTA_Wire[10]} {RAM_DATA_OUTA_Wire[11]} {RAM_DATA_OUTA_Wire[12]} {RAM_DATA_OUTA_Wire[13]} {RAM_DATA_OUTA_Wire[14]} {RAM_DATA_OUTA_Wire[15]} {RAM_DATA_OUTA_Wire[16]} {RAM_DATA_OUTA_Wire[17]} {RAM_DATA_OUTA_Wire[18]} {RAM_DATA_OUTA_Wire[19]} {RAM_DATA_OUTA_Wire[20]} {RAM_DATA_OUTA_Wire[21]} {RAM_DATA_OUTA_Wire[22]} {RAM_DATA_OUTA_Wire[23]} {RAM_DATA_OUTA_Wire[24]} {RAM_DATA_OUTA_Wire[25]} {RAM_DATA_OUTA_Wire[26]} {RAM_DATA_OUTA_Wire[27]} {RAM_DATA_OUTA_Wire[28]} {RAM_DATA_OUTA_Wire[29]} {RAM_DATA_OUTA_Wire[30]} {RAM_DATA_OUTA_Wire[31]}]]
>>>>>>> 45c7484... RAM地址滞后poly_cnt一拍:TJ432.xdc
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets i_fb_clk_IBUF_BUFG]
<<<<<<< HEAD:PL_repository/YJ431-PL/YJ432.xdc
>>>>>>> 6de3416... 又学了一手，不是吗:TJ432.xdc
=======
>>>>>>> 8d733c6... 状态机有可能溢出了:TJ432.xdc
=======
>>>>>>> b871821... 重新排版，fifo_cnt提早跳变，找不到原因:TJ432.xdc
