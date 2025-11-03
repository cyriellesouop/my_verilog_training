set_property SRC_FILE_INFO {cfile:/home/audrey/Documents/Verilog_course/ripple_adder_constraints/project_1.srcs/constrs_2/imports/new/constraints.xdc rfile:../../../project_1.srcs/constrs_2/imports/new/constraints.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:3 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_1
resize_pblock [get_pblocks pblock_1] -add {SLICE_X38Y76:SLICE_X55Y97}
set_property CONTAIN_ROUTING 1 [get_pblocks pblock_1]
set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_1]
set_property src_info {type:XDC file:1 line:8 export:INPUT save:INPUT read:READ} [current_design]
add_cells_to_pblock pblock_1 [get_cells [list {sum_OBUF[5]_inst_i_2} {sum_OBUF[6]_inst_i_1}]] -clear_locs
