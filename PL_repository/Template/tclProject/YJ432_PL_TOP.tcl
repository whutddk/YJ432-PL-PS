# @Author: Ruige_Lee
# @Date:   2019-03-04 20:42:08
# @Last Modified by:   Ruige_Lee
# @Last Modified time: 2019-03-04 21:19:12



# define the where output file place

set outputDir ./


# import verilog source file 
read_verilog [ glob ../vhdl/*.v ]                				

# read xdc constrs file
read_xdc [ glob ../constrs/YJ432.xdc ]  

# synthesis
synth_design -top YJ432_PL_TOP		\
			-part xc7a35tftg256-1	\
			-fanout_limit 10000	\
			-shreg_min_size 3	\
			-flatten_hierarchy rebuilt

# implementation
opt_design  											
place_design
route_design


# save checkpint													
write_checkpoint -force $outputDir/post_route.dcp 				
report_route_status -file $outputDir/post_route_status.rpt		
report_timing_summary -file $outputDir/post_route_timing_summary.rpt 
report_power -file $outputDir/post_route_power.rpt			
report_drc -file $outputDir/post_imp_drc.rpt        					

# create_bitstream
write_bitstream -force ./YJ432_PL_TOP.bit 	\
				-bin_file
  
##############################################################################
##############################################################################
##############################################################################

