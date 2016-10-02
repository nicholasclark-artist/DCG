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
#define PRESET QUOTE(DOUBLES(PREFIX,preset))

if !(hasInterface) exitWith {};

if (CHECK_ADDON_1("acre_main")) then {
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
		WARNING_1("%1 is not a recognized type.",GVAR(acre_command));
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
		WARNING_1("%1 is not a recognized type.",GVAR(acre_support));
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
		WARNING_1("%1 is not a recognized type.",GVAR(acre_squad));
	};

	[GVAR(acre_squad), PRESET] call acre_api_fnc_setPreset;
	[GVAR(acre_command), PRESET] call acre_api_fnc_setPreset;
	[GVAR(acre_support), PRESET] call acre_api_fnc_setPreset;

	player addEventHandler ["respawn",{
		[
			{!isNull player && {alive player}},
			{
				call FUNC(setRadioACRE)
			},
			[]
		] call CBA_fnc_waitUntilAndExecute;
	}];
};

if (CHECK_ADDON_1("task_force_radio")) then {
	tf_give_personal_radio_to_regular_soldier = false;
	tf_no_auto_long_range_radio = true;
	tf_give_microdagr_to_soldier = false;
	tf_same_sw_frequencies_for_side = true;
	tf_same_lr_frequencies_for_side = true;
};