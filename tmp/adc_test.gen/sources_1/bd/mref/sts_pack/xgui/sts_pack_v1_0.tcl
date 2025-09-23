# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "TOTAL_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_ADC_ABS_MAX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_ADC_CH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_ADC_SENT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_CUR_ADC" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_FIRST_TRGGED" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_LAST_DETRIGGED" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_RX_CNTR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_SAMPLES_COUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_TRIG_ACT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_TRIG_COUNT" -parent ${Page_0}


}

proc update_PARAM_VALUE.TOTAL_WIDTH { PARAM_VALUE.TOTAL_WIDTH } {
	# Procedure called to update TOTAL_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TOTAL_WIDTH { PARAM_VALUE.TOTAL_WIDTH } {
	# Procedure called to validate TOTAL_WIDTH
	return true
}

proc update_PARAM_VALUE.WIDTH_ADC_ABS_MAX { PARAM_VALUE.WIDTH_ADC_ABS_MAX } {
	# Procedure called to update WIDTH_ADC_ABS_MAX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_ADC_ABS_MAX { PARAM_VALUE.WIDTH_ADC_ABS_MAX } {
	# Procedure called to validate WIDTH_ADC_ABS_MAX
	return true
}

proc update_PARAM_VALUE.WIDTH_ADC_CH { PARAM_VALUE.WIDTH_ADC_CH } {
	# Procedure called to update WIDTH_ADC_CH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_ADC_CH { PARAM_VALUE.WIDTH_ADC_CH } {
	# Procedure called to validate WIDTH_ADC_CH
	return true
}

proc update_PARAM_VALUE.WIDTH_ADC_SENT { PARAM_VALUE.WIDTH_ADC_SENT } {
	# Procedure called to update WIDTH_ADC_SENT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_ADC_SENT { PARAM_VALUE.WIDTH_ADC_SENT } {
	# Procedure called to validate WIDTH_ADC_SENT
	return true
}

proc update_PARAM_VALUE.WIDTH_CUR_ADC { PARAM_VALUE.WIDTH_CUR_ADC } {
	# Procedure called to update WIDTH_CUR_ADC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_CUR_ADC { PARAM_VALUE.WIDTH_CUR_ADC } {
	# Procedure called to validate WIDTH_CUR_ADC
	return true
}

proc update_PARAM_VALUE.WIDTH_FIRST_TRGGED { PARAM_VALUE.WIDTH_FIRST_TRGGED } {
	# Procedure called to update WIDTH_FIRST_TRGGED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_FIRST_TRGGED { PARAM_VALUE.WIDTH_FIRST_TRGGED } {
	# Procedure called to validate WIDTH_FIRST_TRGGED
	return true
}

proc update_PARAM_VALUE.WIDTH_LAST_DETRIGGED { PARAM_VALUE.WIDTH_LAST_DETRIGGED } {
	# Procedure called to update WIDTH_LAST_DETRIGGED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_LAST_DETRIGGED { PARAM_VALUE.WIDTH_LAST_DETRIGGED } {
	# Procedure called to validate WIDTH_LAST_DETRIGGED
	return true
}

proc update_PARAM_VALUE.WIDTH_RX_CNTR { PARAM_VALUE.WIDTH_RX_CNTR } {
	# Procedure called to update WIDTH_RX_CNTR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_RX_CNTR { PARAM_VALUE.WIDTH_RX_CNTR } {
	# Procedure called to validate WIDTH_RX_CNTR
	return true
}

proc update_PARAM_VALUE.WIDTH_SAMPLES_COUNT { PARAM_VALUE.WIDTH_SAMPLES_COUNT } {
	# Procedure called to update WIDTH_SAMPLES_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_SAMPLES_COUNT { PARAM_VALUE.WIDTH_SAMPLES_COUNT } {
	# Procedure called to validate WIDTH_SAMPLES_COUNT
	return true
}

proc update_PARAM_VALUE.WIDTH_TRIG_ACT { PARAM_VALUE.WIDTH_TRIG_ACT } {
	# Procedure called to update WIDTH_TRIG_ACT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_TRIG_ACT { PARAM_VALUE.WIDTH_TRIG_ACT } {
	# Procedure called to validate WIDTH_TRIG_ACT
	return true
}

proc update_PARAM_VALUE.WIDTH_TRIG_COUNT { PARAM_VALUE.WIDTH_TRIG_COUNT } {
	# Procedure called to update WIDTH_TRIG_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_TRIG_COUNT { PARAM_VALUE.WIDTH_TRIG_COUNT } {
	# Procedure called to validate WIDTH_TRIG_COUNT
	return true
}


proc update_MODELPARAM_VALUE.TOTAL_WIDTH { MODELPARAM_VALUE.TOTAL_WIDTH PARAM_VALUE.TOTAL_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TOTAL_WIDTH}] ${MODELPARAM_VALUE.TOTAL_WIDTH}
}

proc update_MODELPARAM_VALUE.WIDTH_RX_CNTR { MODELPARAM_VALUE.WIDTH_RX_CNTR PARAM_VALUE.WIDTH_RX_CNTR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_RX_CNTR}] ${MODELPARAM_VALUE.WIDTH_RX_CNTR}
}

proc update_MODELPARAM_VALUE.WIDTH_ADC_ABS_MAX { MODELPARAM_VALUE.WIDTH_ADC_ABS_MAX PARAM_VALUE.WIDTH_ADC_ABS_MAX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_ADC_ABS_MAX}] ${MODELPARAM_VALUE.WIDTH_ADC_ABS_MAX}
}

proc update_MODELPARAM_VALUE.WIDTH_CUR_ADC { MODELPARAM_VALUE.WIDTH_CUR_ADC PARAM_VALUE.WIDTH_CUR_ADC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_CUR_ADC}] ${MODELPARAM_VALUE.WIDTH_CUR_ADC}
}

proc update_MODELPARAM_VALUE.WIDTH_LAST_DETRIGGED { MODELPARAM_VALUE.WIDTH_LAST_DETRIGGED PARAM_VALUE.WIDTH_LAST_DETRIGGED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_LAST_DETRIGGED}] ${MODELPARAM_VALUE.WIDTH_LAST_DETRIGGED}
}

proc update_MODELPARAM_VALUE.WIDTH_FIRST_TRGGED { MODELPARAM_VALUE.WIDTH_FIRST_TRGGED PARAM_VALUE.WIDTH_FIRST_TRGGED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_FIRST_TRGGED}] ${MODELPARAM_VALUE.WIDTH_FIRST_TRGGED}
}

proc update_MODELPARAM_VALUE.WIDTH_ADC_SENT { MODELPARAM_VALUE.WIDTH_ADC_SENT PARAM_VALUE.WIDTH_ADC_SENT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_ADC_SENT}] ${MODELPARAM_VALUE.WIDTH_ADC_SENT}
}

proc update_MODELPARAM_VALUE.WIDTH_TRIG_ACT { MODELPARAM_VALUE.WIDTH_TRIG_ACT PARAM_VALUE.WIDTH_TRIG_ACT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_TRIG_ACT}] ${MODELPARAM_VALUE.WIDTH_TRIG_ACT}
}

proc update_MODELPARAM_VALUE.WIDTH_TRIG_COUNT { MODELPARAM_VALUE.WIDTH_TRIG_COUNT PARAM_VALUE.WIDTH_TRIG_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_TRIG_COUNT}] ${MODELPARAM_VALUE.WIDTH_TRIG_COUNT}
}

proc update_MODELPARAM_VALUE.WIDTH_SAMPLES_COUNT { MODELPARAM_VALUE.WIDTH_SAMPLES_COUNT PARAM_VALUE.WIDTH_SAMPLES_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_SAMPLES_COUNT}] ${MODELPARAM_VALUE.WIDTH_SAMPLES_COUNT}
}

proc update_MODELPARAM_VALUE.WIDTH_ADC_CH { MODELPARAM_VALUE.WIDTH_ADC_CH PARAM_VALUE.WIDTH_ADC_CH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_ADC_CH}] ${MODELPARAM_VALUE.WIDTH_ADC_CH}
}

