/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize mod for given settings

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

private _fnc_parseConfigForInit = {
    private _config = _this select 0;
    private _countOptions = count _config;

    for "_index" from 0 to (_countOptions - 1) do {
        private _optionEntry = _config select _index;
        if (configName _optionEntry isEqualTo QGVAR(init)) exitWith {
    		{
			    if (toUpper _x isEqualTo "ALL" || {toUpper _x isEqualTo toUpper worldName} || {toUpper _x isEqualTo toUpper missionName}) exitWith {
			        GVAR(enable) = 1;
			    };
			    GVAR(enable) = 0;
			} forEach (getArray (_optionEntry >> "value"));
        };
    };
};

// default config
[configFile >> QUOTE(DOUBLES(PREFIX,settings))] call _fnc_parseConfigForInit;

// server config
[configFile >> QUOTE(DOUBLES(PREFIX,serverSettings))] call _fnc_parseConfigForInit;

publicVariable QGVAR(enable);