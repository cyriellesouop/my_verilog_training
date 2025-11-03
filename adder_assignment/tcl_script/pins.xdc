set_property PACKAGE_PIN G6 [get_ports {anode_disp0[0]}]
set_property PACKAGE_PIN H6 [get_ports {anode_disp0[1]}]
set_property PACKAGE_PIN C3 [get_ports {anode_disp0[2]}]
set_property PACKAGE_PIN B3 [get_ports {anode_disp0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_disp0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_disp0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_disp0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_disp0[0]}]
set_property PACKAGE_PIN E6 [get_ports {cathode_disp0[0]}]
set_property PACKAGE_PIN B4 [get_ports {cathode_disp0[1]}]
set_property PACKAGE_PIN D5 [get_ports {cathode_disp0[2]}]
set_property PACKAGE_PIN C5 [get_ports {cathode_disp0[3]}]
set_property PACKAGE_PIN D7 [get_ports {cathode_disp0[4]}]
set_property PACKAGE_PIN D6 [get_ports {cathode_disp0[5]}]
set_property PACKAGE_PIN C4 [get_ports {cathode_disp0[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathode_disp0[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathode_disp0[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathode_disp0[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathode_disp0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathode_disp0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathode_disp0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathode_disp0[0]}]
set_property PACKAGE_PIN E1 [get_ports {opa[2]}]
set_property PACKAGE_PIN E2 [get_ports {opa[1]}]
set_property PACKAGE_PIN F1 [get_ports {opa[0]}]
set_property PACKAGE_PIN C2 [get_ports {opb[2]}]
set_property PACKAGE_PIN D1 [get_ports {opb[1]}]
set_property PACKAGE_PIN D2 [get_ports {opb[0]}]
set_property PACKAGE_PIN A8 [get_ports rstn]
set_property PACKAGE_PIN N15 [get_ports clk]
set_property PACKAGE_PIN C13 [get_ports cout]
set_property IOSTANDARD LVCMOS33 [get_ports {opa[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {opa[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {opa[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {opb[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {opb[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {opb[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports cout]
set_property IOSTANDARD LVCMOS33 [get_ports rstn]


create_pblock pblock_1
resize_pblock [get_pblocks pblock_1] -add {SLICE_X0Y58:SLICE_X35Y92}
set_property IS_SOFT FALSE [get_pblocks pblock_1]


create_pblock pblock_2
resize_pblock [get_pblocks pblock_2] -add {SLICE_X0Y11:SLICE_X31Y42}
set_property IS_SOFT FALSE [get_pblocks pblock_2]


create_pblock pblock_3
resize_pblock [get_pblocks pblock_3] -add {SLICE_X38Y14:SLICE_X65Y42}
set_property IS_SOFT FALSE [get_pblocks pblock_3]



