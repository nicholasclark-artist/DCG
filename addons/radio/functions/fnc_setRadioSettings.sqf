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
#define PRESET QGVARMAIN(preset)
#define NETWORK_COUNT 6
#define ACRE_BASERADIOS ["ACRE_PRC343","ACRE_PRC148","ACRE_PRC152","ACRE_PRC117F","ACRE_PRC77","ACRE_SEM52SL"]

if (CHECK_ADDON_1(acre_main)) then {
    {
        [_x, "default", PRESET] call acre_api_fnc_copyPreset;
    } forEach ACRE_BASERADIOS;

    for "_c" from 1 to NETWORK_COUNT do {
        _name = ["Network", _c] joinString " ";
        ["ACRE_PRC148", PRESET, _c, "name", _name] call acre_api_fnc_setPresetChannelField;
        ["ACRE_PRC152", PRESET, _c, "description", _name] call acre_api_fnc_setPresetChannelField;
        ["ACRE_PRC117F", PRESET, _c, "label", _name] call acre_api_fnc_setPresetChannelField;
    };

    {
        [_x, PRESET] call acre_api_fnc_setPreset;
    } forEach ACRE_BASERADIOS;

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
    if (CHECK_ADDON_1(task_force_radio)) then {
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
