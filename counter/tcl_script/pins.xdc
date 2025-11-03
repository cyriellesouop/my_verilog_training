set_property PACKAGE_PIN c13 [get_ports {count[0]}]
set_property PACKAGE_PIN c14 [get_ports {count[1]}]
set_property PACKAGE_PIN D14 [get_ports {count[2]}]
set_property PACKAGE_PIN D15 [get_ports {count[3]}]
set_property PACKAGE_PIN A8 [get_ports rstn]
set_property PACKAGE_PIN B7 [get_ports direction]
set_property PACKAGE_PIN N15 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports {count[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {count[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {count[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {count[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports direction]
set_property IOSTANDARD LVCMOS33 [get_ports rstn]


create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list clk_tmp_i_1 {counter[2]_i_1} {counter[3]_i_1} {counter[3]_i_2}]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X0Y62:SLICE_X35Y90}
set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_1]
set_property IS_SOFT FALSE [get_pblocks pblock_1]



