# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BIAS_A_LSB" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BIAS_A_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BIAS_B_LSB" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BIAS_B_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CFG_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LIMITER_LSB" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LIMITER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RX_ADDR_LSB" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RX_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RX_RATE_LSB" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RX_RATE_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RX_RST_LSB" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RX_RST_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TRG_VALUE_LSB" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TRG_VALUE_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.BIAS_A_LSB { PARAM_VALUE.BIAS_A_LSB } {
	# Procedure called to update BIAS_A_LSB when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BIAS_A_LSB { PARAM_VALUE.BIAS_A_LSB } {
	# Procedure called to validate BIAS_A_LSB
	return true
}

proc update_PARAM_VALUE.BIAS_A_WIDTH { PARAM_VALUE.BIAS_A_WIDTH } {
	# Procedure called to update BIAS_A_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BIAS_A_WIDTH { PARAM_VALUE.BIAS_A_WIDTH } {
	# Procedure called to validate BIAS_A_WIDTH
	return true
}

proc update_PARAM_VALUE.BIAS_B_LSB { PARAM_VALUE.BIAS_B_LSB } {
	# Procedure called to update BIAS_B_LSB when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BIAS_B_LSB { PARAM_VALUE.BIAS_B_LSB } {
	# Procedure called to validate BIAS_B_LSB
	return true
}

proc update_PARAM_VALUE.BIAS_B_WIDTH { PARAM_VALUE.BIAS_B_WIDTH } {
	# Procedure called to update BIAS_B_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BIAS_B_WIDTH { PARAM_VALUE.BIAS_B_WIDTH } {
	# Procedure called to validate BIAS_B_WIDTH
	return true
}

proc update_PARAM_VALUE.CFG_DATA_WIDTH { PARAM_VALUE.CFG_DATA_WIDTH } {
	# Procedure called to update CFG_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CFG_DATA_WIDTH { PARAM_VALUE.CFG_DATA_WIDTH } {
	# Procedure called to validate CFG_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.LIMITER_LSB { PARAM_VALUE.LIMITER_LSB } {
	# Procedure called to update LIMITER_LSB when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LIMITER_LSB { PARAM_VALUE.LIMITER_LSB } {
	# Procedure called to validate LIMITER_LSB
	return true
}

proc update_PARAM_VALUE.LIMITER_WIDTH { PARAM_VALUE.LIMITER_WIDTH } {
	# Procedure called to update LIMITER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LIMITER_WIDTH { PARAM_VALUE.LIMITER_WIDTH } {
	# Procedure called to validate LIMITER_WIDTH
	return true
}

proc update_PARAM_VALUE.RX_ADDR_LSB { PARAM_VALUE.RX_ADDR_LSB } {
	# Procedure called to update RX_ADDR_LSB when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_ADDR_LSB { PARAM_VALUE.RX_ADDR_LSB } {
	# Procedure called to validate RX_ADDR_LSB
	return true
}

proc update_PARAM_VALUE.RX_ADDR_WIDTH { PARAM_VALUE.RX_ADDR_WIDTH } {
	# Procedure called to update RX_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_ADDR_WIDTH { PARAM_VALUE.RX_ADDR_WIDTH } {
	# Procedure called to validate RX_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.RX_RATE_LSB { PARAM_VALUE.RX_RATE_LSB } {
	# Procedure called to update RX_RATE_LSB when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_RATE_LSB { PARAM_VALUE.RX_RATE_LSB } {
	# Procedure called to validate RX_RATE_LSB
	return true
}

proc update_PARAM_VALUE.RX_RATE_WIDTH { PARAM_VALUE.RX_RATE_WIDTH } {
	# Procedure called to update RX_RATE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_RATE_WIDTH { PARAM_VALUE.RX_RATE_WIDTH } {
	# Procedure called to validate RX_RATE_WIDTH
	return true
}

proc update_PARAM_VALUE.RX_RST_LSB { PARAM_VALUE.RX_RST_LSB } {
	# Procedure called to update RX_RST_LSB when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_RST_LSB { PARAM_VALUE.RX_RST_LSB } {
	# Procedure called to validate RX_RST_LSB
	return true
}

proc update_PARAM_VALUE.RX_RST_WIDTH { PARAM_VALUE.RX_RST_WIDTH } {
	# Procedure called to update RX_RST_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_RST_WIDTH { PARAM_VALUE.RX_RST_WIDTH } {
	# Procedure called to validate RX_RST_WIDTH
	return true
}

proc update_PARAM_VALUE.TRG_VALUE_LSB { PARAM_VALUE.TRG_VALUE_LSB } {
	# Procedure called to update TRG_VALUE_LSB when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRG_VALUE_LSB { PARAM_VALUE.TRG_VALUE_LSB } {
	# Procedure called to validate TRG_VALUE_LSB
	return true
}

proc update_PARAM_VALUE.TRG_VALUE_WIDTH { PARAM_VALUE.TRG_VALUE_WIDTH } {
	# Procedure called to update TRG_VALUE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRG_VALUE_WIDTH { PARAM_VALUE.TRG_VALUE_WIDTH } {
	# Procedure called to validate TRG_VALUE_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.CFG_DATA_WIDTH { MODELPARAM_VALUE.CFG_DATA_WIDTH PARAM_VALUE.CFG_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CFG_DATA_WIDTH}] ${MODELPARAM_VALUE.CFG_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.RX_RST_LSB { MODELPARAM_VALUE.RX_RST_LSB PARAM_VALUE.RX_RST_LSB } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_RST_LSB}] ${MODELPARAM_VALUE.RX_RST_LSB}
}

proc update_MODELPARAM_VALUE.RX_RST_WIDTH { MODELPARAM_VALUE.RX_RST_WIDTH PARAM_VALUE.RX_RST_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_RST_WIDTH}] ${MODELPARAM_VALUE.RX_RST_WIDTH}
}

proc update_MODELPARAM_VALUE.RX_RATE_LSB { MODELPARAM_VALUE.RX_RATE_LSB PARAM_VALUE.RX_RATE_LSB } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_RATE_LSB}] ${MODELPARAM_VALUE.RX_RATE_LSB}
}

proc update_MODELPARAM_VALUE.RX_RATE_WIDTH { MODELPARAM_VALUE.RX_RATE_WIDTH PARAM_VALUE.RX_RATE_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_RATE_WIDTH}] ${MODELPARAM_VALUE.RX_RATE_WIDTH}
}

proc update_MODELPARAM_VALUE.RX_ADDR_LSB { MODELPARAM_VALUE.RX_ADDR_LSB PARAM_VALUE.RX_ADDR_LSB } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_ADDR_LSB}] ${MODELPARAM_VALUE.RX_ADDR_LSB}
}

proc update_MODELPARAM_VALUE.RX_ADDR_WIDTH { MODELPARAM_VALUE.RX_ADDR_WIDTH PARAM_VALUE.RX_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_ADDR_WIDTH}] ${MODELPARAM_VALUE.RX_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.TRG_VALUE_LSB { MODELPARAM_VALUE.TRG_VALUE_LSB PARAM_VALUE.TRG_VALUE_LSB } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRG_VALUE_LSB}] ${MODELPARAM_VALUE.TRG_VALUE_LSB}
}

proc update_MODELPARAM_VALUE.TRG_VALUE_WIDTH { MODELPARAM_VALUE.TRG_VALUE_WIDTH PARAM_VALUE.TRG_VALUE_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRG_VALUE_WIDTH}] ${MODELPARAM_VALUE.TRG_VALUE_WIDTH}
}

proc update_MODELPARAM_VALUE.LIMITER_LSB { MODELPARAM_VALUE.LIMITER_LSB PARAM_VALUE.LIMITER_LSB } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LIMITER_LSB}] ${MODELPARAM_VALUE.LIMITER_LSB}
}

proc update_MODELPARAM_VALUE.LIMITER_WIDTH { MODELPARAM_VALUE.LIMITER_WIDTH PARAM_VALUE.LIMITER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LIMITER_WIDTH}] ${MODELPARAM_VALUE.LIMITER_WIDTH}
}

proc update_MODELPARAM_VALUE.BIAS_A_LSB { MODELPARAM_VALUE.BIAS_A_LSB PARAM_VALUE.BIAS_A_LSB } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BIAS_A_LSB}] ${MODELPARAM_VALUE.BIAS_A_LSB}
}

proc update_MODELPARAM_VALUE.BIAS_A_WIDTH { MODELPARAM_VALUE.BIAS_A_WIDTH PARAM_VALUE.BIAS_A_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BIAS_A_WIDTH}] ${MODELPARAM_VALUE.BIAS_A_WIDTH}
}

proc update_MODELPARAM_VALUE.BIAS_B_LSB { MODELPARAM_VALUE.BIAS_B_LSB PARAM_VALUE.BIAS_B_LSB } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BIAS_B_LSB}] ${MODELPARAM_VALUE.BIAS_B_LSB}
}

proc update_MODELPARAM_VALUE.BIAS_B_WIDTH { MODELPARAM_VALUE.BIAS_B_WIDTH PARAM_VALUE.BIAS_B_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BIAS_B_WIDTH}] ${MODELPARAM_VALUE.BIAS_B_WIDTH}
}

