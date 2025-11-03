#create_pblock pblock_1
#add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list {sum_OBUF[5]_inst_i_2} {sum_OBUF[6]_inst_i_1}]]
#resize_pblock [get_pblocks pblock_1] -add {SLICE_X40Y75:SLICE_X57Y96}
