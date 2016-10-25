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

if (CHECK_ADDON_1("acre_main")) then {
	{
		[_x, "default", PRESET] call acre_api_fnc_copyPreset;

		call {
			_channel = _forEachIndex + 1;
			_name = ["Comm Net", str _channel] joinString " ";

			if (_x == "ACRE_PRC343") exitWith {};

			if (_x == "ACRE_PRC148") exitWith {
				[_x, PRESET, _channel, "label", _name] call acre_api_fnc_setPresetChannelField;
			};

			if (_x == "ACRE_PRC152") exitWith {
				[_x, PRESET, _channel, "description", _name] call acre_api_fnc_setPresetChannelField;
			};

			if (_x == "ACRE_PRC117F") exitWith {
				[_x, PRESET, _channel, "name", _name] call acre_api_fnc_setPresetChannelField;
			};

			INFO_1("%1 is not a recognized type.",_x);
		};

		[_x, PRESET] call acre_api_fnc_setPreset;
	} forEach [
		GVAR(commNet01_ACRE),
		GVAR(commNet02_ACRE),
		GVAR(commNet03_ACRE),
		GVAR(commNet04_ACRE),
		GVAR(commNet05_ACRE),
		GVAR(commNet06_ACRE)
	];

	if (hasInterface) then {
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
};

if (isServer) then {
    // TFAR settings, cast to clients with "server" param
    if (CHECK_ADDON_1("task_force_radio")) then {
        _testSetting = "tf_same_sw_frequencies_for_side";

        [
            {[_this select 0, true] call CBA_settings_fnc_check},
            {
                ["tf_give_personal_radio_to_regular_soldier", false, true, "server"] call CBA_settings_fnc_set;
                ["tf_no_auto_long_range_radio", true, true, "server"] call CBA_settings_fnc_set;
                ["tf_give_microdagr_to_soldier", true, true, "server"] call CBA_settings_fnc_set;
                ["tf_same_sw_frequencies_for_side", true, true, "server"] call CBA_settings_fnc_set;
                ["tf_same_lr_frequencies_for_side", true, true, "server"] call CBA_settings_fnc_set;
                ["tf_same_dd_frequencies_for_side", true, true, "server"] call CBA_settings_fnc_set;
            },
            [_testSetting]
        ] call CBA_fnc_waitUntilAndExecute;
    };
};
