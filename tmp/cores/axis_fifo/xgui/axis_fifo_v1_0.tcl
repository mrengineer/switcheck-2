# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ALWAYS_READY" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ALWAYS_VALID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "M_AXIS_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "S_AXIS_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WRITE_DEPTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.ALWAYS_READY { PARAM_VALUE.ALWAYS_READY } {
	# Procedure called to update ALWAYS_READY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ALWAYS_READY { PARAM_VALUE.ALWAYS_READY } {
	# Procedure called to validate ALWAYS_READY
	return true
}

proc update_PARAM_VALUE.ALWAYS_VALID { PARAM_VALUE.ALWAYS_VALID } {
	# Procedure called to update ALWAYS_VALID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ALWAYS_VALID { PARAM_VALUE.ALWAYS_VALID } {
	# Procedure called to validate ALWAYS_VALID
	return true
}

proc update_PARAM_VALUE.M_AXIS_TDATA_WIDTH { PARAM_VALUE.M_AXIS_TDATA_WIDTH } {
	# Procedure called to update M_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_AXIS_TDATA_WIDTH { PARAM_VALUE.M_AXIS_TDATA_WIDTH } {
	# Procedure called to validate M_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.S_AXIS_TDATA_WIDTH { PARAM_VALUE.S_AXIS_TDATA_WIDTH } {
	# Procedure called to update S_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_AXIS_TDATA_WIDTH { PARAM_VALUE.S_AXIS_TDATA_WIDTH } {
	# Procedure called to validate S_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.WRITE_DEPTH { PARAM_VALUE.WRITE_DEPTH } {
	# Procedure called to update WRITE_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WRITE_DEPTH { PARAM_VALUE.WRITE_DEPTH } {
	# Procedure called to validate WRITE_DEPTH
	return true
}


proc update_MODELPARAM_VALUE.S_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.S_AXIS_TDATA_WIDTH PARAM_VALUE.S_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.S_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.M_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.M_AXIS_TDATA_WIDTH PARAM_VALUE.M_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.M_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.WRITE_DEPTH { MODELPARAM_VALUE.WRITE_DEPTH PARAM_VALUE.WRITE_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WRITE_DEPTH}] ${MODELPARAM_VALUE.WRITE_DEPTH}
}

proc update_MODELPARAM_VALUE.ALWAYS_READY { MODELPARAM_VALUE.ALWAYS_READY PARAM_VALUE.ALWAYS_READY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ALWAYS_READY}] ${MODELPARAM_VALUE.ALWAYS_READY}
}

proc update_MODELPARAM_VALUE.ALWAYS_VALID { MODELPARAM_VALUE.ALWAYS_VALID PARAM_VALUE.ALWAYS_VALID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ALWAYS_VALID}] ${MODELPARAM_VALUE.ALWAYS_VALID}
}

