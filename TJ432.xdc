## This file is a general .xdc for the CmodA7 rev. B

## To use it in a project:

## - uncomment the lines corresponding to used pins

## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project



# Clock signal 100 MHz

set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS33} [get_ports i_sysclk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports i_sysclk]

#create_generated_clock -name sys_clk_div2 -source [get_ports clkin] -edges {2 4 6 };

# Flexbus
## -CLK_OUT 30MHz
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS33} [get_ports i_fb_clk]
create_clock -period 25.000 -name fb_clk_pin -waveform {0.000 12.500} -add [get_ports i_fb_clk]

# asynchronous
set_clock_groups -name async_sys_fb -asynchronous -group sys_clk_pin -group fb_clk_pin

## FB_OE
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports i_fb_oen]

## FB_RW
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports i_fb_rw]

## FB_CS
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33} [get_ports i_fb_csn]

## FB_ALE
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports i_fb_ale]

## FB_AD[31:0]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[0]}]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[1]}]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[2]}]
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[3]}]
set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[4]}]
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[5]}]
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[6]}]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[7]}]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[8]}]
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[9]}]
set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[10]}]
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[11]}]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[12]}]
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[13]}]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[14]}]
set_property -dict {PACKAGE_PIN B9 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[15]}]
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[16]}]
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[17]}]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[18]}]
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[19]}]
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[20]}]
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[21]}]
set_property -dict {PACKAGE_PIN C8 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[22]}]
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[23]}]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[24]}]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[25]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[26]}]
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[27]}]
set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[28]}]
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[29]}]
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[30]}]
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS33} [get_ports {i_fb_ad[31]}]


## LEDs
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports i_LEDB_IO]
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports i_LEDG_IO]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports i_LEDR_IO]


##PL_BZ
set_property -dict {PACKAGE_PIN M12 IOSTANDARD LVCMOS33} [get_ports i_BZ_IO]

##PWM0
#set_property -dict {PACKAGE_PIN T8 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH0];    #BANK14 IO35
#set_property -dict {PACKAGE_PIN R8 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH1];    #BANK14 IO33
#set_property -dict {PACKAGE_PIN P10 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH2];    #BANK14 IO20
#set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH3];    #BANK14 IO26

#set_property -dict {PACKAGE_PIN N9 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH0_EN];  #BANK14 IO28
#set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH2_EN];  #BANK14 IO37

##QEI0
#set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports i_QEI0_CH0_PA];    #BANK14 IO10
#set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports i_QEI0_CH0_PB];    #BANK14 IO12

# Buttons

#set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { btn0 }]; #IO_L19N_T3_VREF_16 Sch=btn[0]

#set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; #IO_L19P_T3_16 Sch=btn[1]

# PMOD1 
#set_property -dict {PACKAGE_PIN P6 IOSTANDARD LVCMOS33} [get_ports PMOD1_1];    #BANK14 
#set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports PMOD1_2];    #BANK14 
#set_property -dict {PACKAGE_PIN R5 IOSTANDARD LVCMOS33} [get_ports PMOD1_3];    #BANK14 
#set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS33} [get_ports PMOD1_4];    #BANK14

set_property -dict {PACKAGE_PIN P8 IOSTANDARD LVCMOS33} [get_ports i_I2SMCLK];    #BANK14
set_property -dict {PACKAGE_PIN T7 IOSTANDARD LVCMOS33} [get_ports i_I2SLRCK];    #BANK14
set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS33} [get_ports i_I2SBSCK];    #BANK14
set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS33} [get_ports i_I2STXD];    #BANK14

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
