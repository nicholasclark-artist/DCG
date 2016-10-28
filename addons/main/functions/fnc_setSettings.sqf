/*
Author:
esteldunedain, SENSEI

Description:
load settings

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private _start = diag_tickTime;

private _fnc_parseConfigForSettings = {
    private ["_config", "_countOptions", "_optionEntry"];
    _config = _this select 0;
    _countOptions = count _config;

    for "_index" from 0 to (_countOptions - 1) do {
        _optionEntry = _config select _index;
        [_optionEntry] call FUNC(setSettingsConfig);
    };
};

// default config
[configFile >> QUOTE(DOUBLES(PREFIX,settings))] call _fnc_parseConfigForSettings;

// server config
[configFile >> QUOTE(DOUBLES(PREFIX,serverSettings))] call _fnc_parseConfigForSettings;

// mission config
[missionConfigFile >> QUOTE(DOUBLES(PREFIX,settings))] call _fnc_parseConfigForSettings;

// mission params
call FUNC(setSettingsParams);

INFO_1("Settings loaded in %1ms",(diag_tickTime - _start));
