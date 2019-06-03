

set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS33} [get_ports i_sysclk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports i_sysclk]


## LEDs
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports LED_B]
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports LED_G]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports LED_R]


##PL_BZ
set_property -dict {PACKAGE_PIN M12 IOSTANDARD LVCMOS33} [get_ports BZ]



create_pblock pblock_i_cfg1
add_cells_to_pblock [get_pblocks pblock_i_cfg1] [get_cells -quiet [list i_cfg1]]
resize_pblock [get_pblocks pblock_i_cfg1] -add {SLICE_X0Y0:SLICE_X15Y24}
resize_pblock [get_pblocks pblock_i_cfg1] -add {DSP48_X0Y0:DSP48_X0Y9}
resize_pblock [get_pblocks pblock_i_cfg1] -add {RAMB18_X0Y0:RAMB18_X0Y9}
resize_pblock [get_pblocks pblock_i_cfg1] -add {RAMB36_X0Y0:RAMB36_X0Y4}
