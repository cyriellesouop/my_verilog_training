
# Global variable
set proj_name "project2"
set proj_dir "./project2"
set part_name "xc7s50csga324-2"
set top_module "display"
set sim_top_module "testbench"
set bitfile "adder.bit"

#////////////////////////
# 1- simulation
#////////////////////////


file mkdir sim
cd sim
file mkdir work
cd work

# compile design and testbench
exec xvlog ./../../display.v
exec xvlog ./../../top.v
exec xvlog ./../../adder.v
exec xvlog ./../../full_adder.v
exec xvlog ./../../half_adder.v
exec xvlog ./../../segconv.v
exec xvlog ./../../segctrl.v
exec xvlog ./../../testbench.v

#elaborate
exec xelab $sim_top_module -debug all

#simulation
exec  xsim $sim_top_module -R

cd ../..

#////////////////////////
# 2- synthesis , place and route
#////////////////////////
catch {close_design}

file mkdir synth_place_route
cd  synth_place_route

#load design sources
read_verilog {./../top.v ./../adder.v ./../full_adder.v ./../half_adder.v ./../segconv.v ./../segctrl.v ./../display.v}

#load constraints files
read_xdc ./../pins.xdc

# synthesis
synth_design -top $top_module -part $part_name -flatten_hierarchy rebuilt  

# optimization
opt_design -directive Default 

#placement
place_design -no_timing_driven

# post-placement optimization
phys_opt_design -directive AggressiveFanoutOpt
#routing
route_design -ultrathreads


#post routing optimization
phys_opt_design -directive AggressiveFanoutOpt

#reports
report_utilization -file  utilization.rpt
report_timing_summary -file timing_summary.rpt

# Bistream generation
write_bitstream -force $bitfile

#////////////////////////
# 3- programming the hw
#////////////////////////


#program device
open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
set_property PROGRAM.FILE {/home/audrey/Documents/Verilog_course/adder_assignment/tcl_script/synth_place_route/adder.bit} [get_hw_devices xc7s50_0]
current_hw_device [get_hw_devices xc7s50_0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7s50_0] 0]
set_property PROBES.FILE {} [get_hw_devices xc7s50_0]
set_property FULL_PROBES.FILE {} [get_hw_devices xc7s50_0]
set_property PROGRAM.FILE {/home/audrey/Documents/Verilog_course/adder_assignment/tcl_script/synth_place_route/adder.bit} [get_hw_devices xc7s50_0]
program_hw_devices [get_hw_devices xc7s50_0]
refresh_hw_device [lindex [get_hw_devices xc7s50_0] 0]
