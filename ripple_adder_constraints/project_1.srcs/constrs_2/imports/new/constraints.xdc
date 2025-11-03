startgroup

create_pblock pblock_1
resize_pblock pblock_1 -add SLICE_X38Y76:SLICE_X55Y97

#add_cells_to_pblock pblock_1 [get_cells {sum_OBUF[6]_inst_i_1}]
#add_cells_to_pblock pblock_1 [get_cells {sum_OBUF[5]_inst_i_2}]
add_cells_to_pblock pblock_1 [get_cells [list {sum_OBUF[5]_inst_i_2} {sum_OBUF[6]_inst_i_1}]] -clear_locs
set_property EXCLUDE_PLACEMENT true [get_pblocks pblock_1]
set_property CONTAIN_ROUTING true [get_pblocks pblock_1]

endgroup