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

# asynchronous
set_clock_groups -name async_sys_fb -asynchronous -group sys_clk_pin -group fb_clk_pin

## FB_OE
#set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports i_fb_oen];

## FB_RW
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports i_fb_rw];

## FB_CS
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33} [get_ports i_fb_csn];

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
#set_property -dict {PACKAGE_PIN T8 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH0];    #BANK14 IO35
#set_property -dict {PACKAGE_PIN R8 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH1];    #BANK14 IO33
#set_property -dict {PACKAGE_PIN P10 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH2];    #BANK14 IO20
#set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH3];    #BANK14 IO26

#set_property -dict {PACKAGE_PIN N9 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH0_EN];  #BANK14 IO28
#set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports i_PWM0_CH2_EN];  #BANK14 IO37

##QEI0
#set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports i_QEI0_CH0_PA];    #BANK14 IO10
#set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports i_QEI0_CH0_PB];    #BANK14 IO12





set_property CONFIG_MODE SPIx4 [current_design]





