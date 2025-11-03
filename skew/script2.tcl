
# Global variable
set proj_name "project1"
set proj_dir "./project1"
set part_name "xc7s50csga324-2"
set counter_module "counter_skew"

set counter_n_module "counter_skew_n"

#set bitfile "counter.bit"

#////////////////////////
# 1- simulation
#////////////////////////


file mkdir sim
cd sim
file mkdir work
cd work

# compile design and testbench
exec xvlog ./../../counter_skew.v
exec xvlog ./../../counter_skew_n.v

 
#elaborate
#exec xelab $top_module -L unisims_ver  -debug all
#exec xelab $counter_n_module -L unisims_ver  -debug all

#simulation

#exec  xsim $sim_top_module -R
#
cd ../..

#////////////////////////
# 2- synthesis , place and route
#////////////////////////
#
#-----------------------------------------------------------------------------
#            counter design without buffer
#-----------------------------------------------------------------------------
catch {close_design}

file mkdir synth_place_route_counter
cd  synth_place_route_counter

#load design sources
read_verilog ./../counter_skew.v
#load constraints files
read_xdc ./../timingConstraint.xdc
# synthesis
synth_design -top $counter_module -part $part_name
write_checkpoint -force  synth_counter_checkpoint.dcp
# optimization
opt_design
#placement
place_design
# post-placement optimization
phys_opt_design
#routing
route_design
#post routing optimization
phys_opt_design
write_checkpoint -force final_counter_checkpoint.dcp
#reports
report_utilization -file  utilization.rpt
report_timing_summary -file timing_summary.rpt
report_power -file power_utilization.rpt
report_power_opt -file power_opt.rpt
report_route_status -file route_status.rpt
report_place_status -file place_status.rpt

#-----------------------------------------------------------------------------
#            counter design without buffer
#-----------------------------------------------------------------------------
cd ..
catch {close_design}

file mkdir synth_place_route_counter_new
cd  synth_place_route_counter_new

#load design sources
read_verilog ./../counter_skew_n.v
#load constraints files
read_xdc ./../timingConstraint_n.xdc
# synthesis
synth_design -top $counter_n_module -part $part_name
write_checkpoint -force  synth_counter_n_checkpoint.dcp
# optimization
opt_design
#placement
place_design
# post-placement optimization
phys_opt_design
#routing
route_design
#post routing optimization
phys_opt_design
write_checkpoint -force final_counter_n_checkpoint.dcp
#reports
report_utilization -file  utilization.rpt
report_timing_summary -file timing_summary.rpt
report_power -file power_utilization.rpt
report_power_opt -file power_opt.rpt
report_route_status -file route_status.rpt
report_place_status -file place_status.rpt

# Bistream generation
#write_bitstream -force $bitfile

#////////////////////////
# 3- programming the hw
#////////////////////////

#program device
#open_hw_manager
#connect_hw_server -allow_non_jtag
#open_hw_target
#set_property PROGRAM.FILE {/home/audrey/Documents/Verilog_course/dotProduct2/synth_place_route/reader.bit} [get_hw_devices xc7s50_0]
#current_hw_device [get_hw_devices xc7s50_0]
#refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7s50_0] 0]
#set_property PROBES.FILE {} [get_hw_devices xc7s50_0]
#set_property FULL_PROBES.FILE {} [get_hw_devices xc7s50_0]
#set_property PROGRAM.FILE {/home/audrey/Documents/Verilog_course/dotProduct2/synth_place_route/reader.bit} [get_hw_devices xc7s50_0]
#program_hw_devices [get_hw_devices xc7s50_0]
#refresh_hw_device [lindex [get_hw_devices xc7s50_0] 0]
