derive_pll_clocks

#rename_clock -name {htrcl_ref_clk}  -source [get_pins u_clk/u_pll0/pll_inst.refclk] -master_clock u_clk/u_pll0/pll_inst.refclk [get_pins {u_clk/u_pll0/pll_inst.clkc[0]}]
rename_clock -name {phy_clk}   -source [get_pins  {u_clk/u_pll0/pll_inst.refclk}] -master_clock {u_clk/u_pll0/pll_inst.refclk} [get_pins {u_clk/u_pll0/pll_inst.clkc[1]}]
rename_clock -name {ddr_clk}   -source [get_pins  {u_clk/u_pll0/pll_inst.refclk}] -master_clock {u_clk/u_pll0/pll_inst.refclk} [get_pins {u_clk/u_pll0/pll_inst.clkc[2]}]
rename_clock -name {mcu_clk}   -source [get_pins  {u_clk/u_pll0/pll_inst.refclk}] -master_clock {u_clk/u_pll0/pll_inst.refclk} [get_pins {u_clk/u_pll0/pll_inst.clkc[3]}]
rename_clock -name {hctrl_clk} -source [get_pins {u_clk/u_pll0/pll_inst.clkc[0]}] -master_clock {u_clk/u_pll0/pll_inst.clkc[0]} [get_pins {u_clk/u_pll1/pll_inst.clkc[0]}]
#rename_clock -name {user_clk}  -source [get_pins {u_clk/u_pll0/pll_inst.clkc[0]}] -master_clock {u_clk/u_pll0/pll_inst.clkc[0]} [get_pins {u_clk/u_pll1/pll_inst.clkc[1]}]

set_clock_uncertainty -setup 0.05  [get_clocks hctrl_clk]
set_clock_uncertainty -hold  0.05  [get_clocks hctrl_clk]


#set_false_path -from [get_clocks user_clk ] -to [get_clocks hctrl_clk]
set_false_path -from [get_clocks hctrl_clk] -to [get_clocks mcu_clk  ]
set_false_path -from [get_clocks mcu_clk  ] -to [get_clocks hctrl_clk]

set_false_path -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_phy_loopback_en[*]}]

set_multicycle_path -setup -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.delay_osc_chain_en}]     -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_delay_osc_en}] 2
set_multicycle_path -setup -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.delay_osc_div[*]}]       -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_delay_osc_div[*]}] 2
set_multicycle_path -setup -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.delay_osc_wrlvl_sel[*]}] -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_delay_osc_wrlvl_sel[*]}] 2
set_multicycle_path -setup -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.delay_osc_wdata_sel[*]}] -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_delay_osc_wdq_sel[*]}] 2
set_multicycle_path -setup -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.delay_testmode_en}]      -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_delay_testmode_en}] 2
set_multicycle_path -setup -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.loopback_clk_sel[*]}]    -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_loopback_clk_sel[*]}] 2
set_multicycle_path -setup -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.loopback_clknum_sel[*]}] -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_loopback_clknum_sel[*]}] 2
set_multicycle_path -setup -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.loopback_mode}]          -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_loopback_mode}] 2
set_multicycle_path -setup -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.dqs_pupd_en}]            -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_dqs_pupd_en}] 2

set_multicycle_path -hold -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.delay_osc_chain_en}]     -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_delay_osc_en}] 1
set_multicycle_path -hold -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.delay_osc_div[*]}]       -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_delay_osc_div[*]}] 1
set_multicycle_path -hold -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.delay_osc_wrlvl_sel[*]}] -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_delay_osc_wrlvl_sel[*]}] 1
set_multicycle_path -hold -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.delay_osc_wdata_sel[*]}] -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_delay_osc_wdq_sel[*]}] 1
set_multicycle_path -hold -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.delay_testmode_en}]      -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_delay_testmode_en}] 1
set_multicycle_path -hold -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.loopback_clk_sel[*]}]    -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_loopback_clk_sel[*]}] 1
set_multicycle_path -hold -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.loopback_clknum_sel[*]}] -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_loopback_clknum_sel[*]}] 1
set_multicycle_path -hold -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.loopback_mode}]          -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_loopback_mode}] 1
set_multicycle_path -hold -end -from [get_pins {u_ddrphy_standard/u_hard_controller_*.dqs_pupd_en}]            -to [get_pins {u_ddrphy_standard/u_ddrphy/ddr_phy_4lanes_*$ph1_ddr_4lanes.*_dqs_pupd_en}] 1
