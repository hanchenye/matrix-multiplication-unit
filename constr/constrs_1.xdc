###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
create_clock -period 10.000 -name PCIE_CLK [get_ports PCIE_CLK_p]
set_false_path -from [get_ports PCIE_RSTN_t]

###############################################################################
# User Physical Constraints
###############################################################################

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.BPI_SYNC_MODE Type1 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-1 [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pulldown [current_design]
set_property CONFIG_MODE BPI16 [current_design]

set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CFGBVS GND [current_design]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets design_1_i/mig_subsystem/clk_wiz_0/inst/clk_in1_design_1_clk_wiz_0_0]

###############################################################################
# Pinout and Related I/O Constraints
###############################################################################

set_property PACKAGE_PIN U7 [get_ports PCIE_CLK_n]

set_property IOSTANDARD LVDS [get_ports SYS_CLK_clk_n]
set_property PACKAGE_PIN AD11 [get_ports SYS_CLK_clk_n]
set_property PACKAGE_PIN AD12 [get_ports SYS_CLK_clk_p]
set_property IOSTANDARD LVDS [get_ports SYS_CLK_clk_p]

set_property PACKAGE_PIN G25 [get_ports PCIE_RSTN_t]
set_property IOSTANDARD LVCMOS33 [get_ports PCIE_RSTN_t]
set_property PULLUP true [get_ports PCIE_RSTN_t]

set_property PACKAGE_PIN AK10 [get_ports {DDR3_addr[14]}]

###############################################################################
# LED Constraints
###############################################################################

#set_property PACKAGE_PIN B23 [get_ports {LED0[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED0[0]}]
#set_property PACKAGE_PIN A23 [get_ports {LED0[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED0[1]}]
#set_property PACKAGE_PIN E23 [get_ports {LED0[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED0[2]}]
#set_property PACKAGE_PIN D23 [get_ports {LED0[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED0[3]}]
#set_property PACKAGE_PIN F25 [get_ports {LED1[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED1[0]}]
#set_property PACKAGE_PIN E25 [get_ports {LED1[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED1[1]}]
#set_property PACKAGE_PIN E24 [get_ports {LED1[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED1[2]}]
#set_property PACKAGE_PIN D24 [get_ports {LED1[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED1[3]}]

#set_property IOSTANDARD SSTL15 [get_ports {DDR3_addr[14]}]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk]
