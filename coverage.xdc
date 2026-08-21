create_clock -period 10.0 -name clk [get_ports clk]
set_property PACKAGE_PIN <your_pin> [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [all_ports]
set_property CFGBVS VCCO [current_design]
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
# Add other I/O pins as needed