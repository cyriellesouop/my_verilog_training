
# Global variable
set proj_name "project1"
set proj_dir "./project1"
set part_name "xc7s50csga324-2"
set top_module "top"
set sim_top_module "testbench"
set bitfile "dot.bit"

#////////////////////////
# 1- simulation
#////////////////////////


file mkdir sim
cd sim
file mkdir work
cd work

# compile design and testbench
exec xvlog ./../../memory_reader.v
exec xvlog ./../../memory.v
exec xvlog ./../../memory_writer.v
exec xvlog ./../../multiplier.v
exec xvlog ./../../tb_memory.v
exec xvlog ./../../tb_reader.v
exec xvlog ./../../tb_writer.v
exec xvlog ./../../tb_multiplier.v
exec xvlog ./../../testbench.v
exec xvlog ./../../top.v



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
read_verilog ./../memory_reader.v
read_verilog ./../memory.v
read_verilog ./../memory_writer.v
read_verilog ./../multiplier.v
read_verilog  ./../top.v

#load constraints files
#read_xdc ./../pins.xdc
read_xdc ./../timingConstraint.xdc

# synthesis
synth_design -top $top_module -part $part_name

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

#reports
report_utilization -file  utilization.rpt
report_timing_summary -file timing_summary.rpt

# Bistream generation
write_bitstream -force $bitfile

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
