/*
Author:
Nicholas Clark (SENSEI)

Description:
set radio settings, must be ran globally

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define P_ACRE "acre_main"
#define P_TFAR "task_force_radio"
#define PRESET QUOTE(DOUBLES(PREFIX,preset))

waitUntil {time > 10};

if (CHECK_ADDON_1(P_ACRE)) then {
	[GVAR(acre_command), "default", PRESET] call acre_api_fnc_copyPreset;
	[GVAR(acre_squad), "default", PRESET] call acre_api_fnc_copyPreset;
	[GVAR(acre_support), "default", PRESET] call acre_api_fnc_copyPreset;
	// setup command radio
	call {
		if (GVAR(acre_command) isEqualTo "ACRE_PRC343") exitWith {

		};
		if (GVAR(acre_command) isEqualTo "ACRE_PRC148") exitWith {
			[GVAR(acre_command), PRESET, 1, "label", "COMMAND"] call acre_api_fnc_setPresetChannelField;
			[GVAR(acre_command), PRESET, 2, "label", "SUPPORT"] call acre_api_fnc_setPresetChannelField;
		};
		if (GVAR(acre_command) isEqualTo "ACRE_PRC152") exitWith {
			[GVAR(acre_command), PRESET, 1, "description", "COMMAND"] call acre_api_fnc_setPresetChannelField;
			[GVAR(acre_command), PRESET, 2, "description", "SUPPORT"] call acre_api_fnc_setPresetChannelField;
		};
		if (GVAR(acre_command) isEqualTo "ACRE_PRC117F") exitWith {
			[GVAR(acre_command), PRESET, 1, "name", "COMMAND"] call acre_api_fnc_setPresetChannelField;
			[GVAR(acre_command), PRESET, 2, "name", "SUPPORT"] call acre_api_fnc_setPresetChannelField;
		};
		LOG_DEBUG_1("%1 is not a recognized type.",GVAR(acre_command));
	};
	// setup support radio
	call {
		if (GVAR(acre_support) isEqualTo "ACRE_PRC343") exitWith {

		};
		if (GVAR(acre_support) isEqualTo "ACRE_PRC148") exitWith {
			[GVAR(acre_support), PRESET, 1, "label", "COMMAND"] call acre_api_fnc_setPresetChannelField;
			[GVAR(acre_support), PRESET, 2, "label", "SUPPORT"] call acre_api_fnc_setPresetChannelField;
		};
		if (GVAR(acre_support) isEqualTo "ACRE_PRC152") exitWith {
			[GVAR(acre_support), PRESET, 1, "description", "COMMAND"] call acre_api_fnc_setPresetChannelField;
			[GVAR(acre_support), PRESET, 2, "description", "SUPPORT"] call acre_api_fnc_setPresetChannelField;
		};
		if (GVAR(acre_support) isEqualTo "ACRE_PRC117F") exitWith {
			[GVAR(acre_support), PRESET, 1, "name", "COMMAND"] call acre_api_fnc_setPresetChannelField;
			[GVAR(acre_support), PRESET, 2, "name", "SUPPORT"] call acre_api_fnc_setPresetChannelField;
		};
		LOG_DEBUG_1("%1 is not a recognized type.",GVAR(acre_support));
	};
	// setup squad radio
	call {
		if (GVAR(acre_squad) isEqualTo "ACRE_PRC343") exitWith {

		};
		if (GVAR(acre_squad) isEqualTo "ACRE_PRC148") exitWith {
			[GVAR(acre_squad), PRESET, 1, "label", "COMMAND"] call acre_api_fnc_setPresetChannelField;
			[GVAR(acre_squad), PRESET, 2, "label", "SUPPORT"] call acre_api_fnc_setPresetChannelField;
		};
		if (GVAR(acre_squad) isEqualTo "ACRE_PRC152") exitWith {
			[GVAR(acre_squad), PRESET, 1, "description", "COMMAND"] call acre_api_fnc_setPresetChannelField;
			[GVAR(acre_squad), PRESET, 2, "description", "SUPPORT"] call acre_api_fnc_setPresetChannelField;
		};
		if (GVAR(acre_squad) isEqualTo "ACRE_PRC117F") exitWith {
			[GVAR(acre_squad), PRESET, 1, "name", "COMMAND"] call acre_api_fnc_setPresetChannelField;
			[GVAR(acre_squad), PRESET, 2, "name", "SUPPORT"] call acre_api_fnc_setPresetChannelField;
		};
		LOG_DEBUG_1("%1 is not a recognized type.",GVAR(acre_squad));
	};

	[GVAR(acre_squad), PRESET] call acre_api_fnc_setPreset;
	[GVAR(acre_command), PRESET] call acre_api_fnc_setPreset;
	[GVAR(acre_support), PRESET] call acre_api_fnc_setPreset;
};
if (CHECK_ADDON_1(P_TFAR)) then {
	tf_give_personal_radio_to_regular_soldier = false;
	tf_no_auto_long_range_radio = true;
	tf_give_microdagr_to_soldier = false;
	tf_same_sw_frequencies_for_side = true;
	tf_same_lr_frequencies_for_side = true;
};
if (hasInterface) then {
	// workaround for acre, if inventory full and can't add radio, acre throws rpt error: (Warning: Radio ID ACRE_PRC343_ID_1 was returned for a non-existent baseclass...)
	// if ((backpack player) isEqualTo "") then {player addBackpack "B_Kitbag_cbr"};
	waitUntil {!isNull (findDisplay 46) && {!isNull player} && {alive player}};
	call FUNC(setRadio);
};