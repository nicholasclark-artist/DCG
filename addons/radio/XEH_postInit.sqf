/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	INFO("Addon is disabled.");
};

// ACRE2 workaround, remove items from communications tab
_data = missionnamespace getVariable "bis_fnc_arsenal_data";
_data set [12,[]];
missionnamespace setVariable ["bis_fnc_arsenal_data",_data,true];

// TFAR settings, cast to clients with "server" param
["tf_give_personal_radio_to_regular_soldier", false, "server"] call CBA_settings_fnc_set;
["tf_no_auto_long_range_radio", true, "server"] call CBA_settings_fnc_set;
["tf_give_microdagr_to_soldier", true, "server"] call CBA_settings_fnc_set;
["tf_same_sw_frequencies_for_side", true, "server"] call CBA_settings_fnc_set;
["tf_same_lr_frequencies_for_side", true, "server"] call CBA_settings_fnc_set;

ADDON = true;
