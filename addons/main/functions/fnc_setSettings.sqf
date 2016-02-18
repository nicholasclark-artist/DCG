/*
Author:
esteldunedain, SENSEI

Description:
loads server parameters

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_fnc_parseConfigForSettings"];

_fnc_parseConfigForSettings = {
    private ["_config", "_countOptions", "_optionEntry"];
    _config = _this select 0;
    _countOptions = count _config;

    for "_index" from 0 to (_countOptions - 1) do {
        _optionEntry = _config select _index;
        [_optionEntry] call FUNC(setSettingsFromConfig);
    };
};
// default config
[configFile >> QUOTE(DOUBLES(PREFIX,settings))] call _fnc_parseConfigForSettings;

// server config
[configFile >> QUOTE(DOUBLES(PREFIX,serverSettings))] call _fnc_parseConfigForSettings;

// Publish all settings data
publicVariable QGVAR(settings);

// Publish all setting values
{
    publicVariable (_x select 0);
    false
} count GVAR(settings);