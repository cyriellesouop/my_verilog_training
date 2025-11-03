
create_clock -name clk -period 3.67 [get_ports clk]
create_generated_clock -name clk_delayed -source [get_ports clk] -divided_by 1 [get_pins BUFGCE_inst/0]

