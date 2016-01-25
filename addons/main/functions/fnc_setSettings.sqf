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

private ["_fnc_parseConfigForSettings","_fnc_removeUnusedPools","_fnc_setSide","_fnc_setSettingValid"];

_fnc_parseConfigForSettings = {
    private ["_config", "_countOptions", "_optionEntry"];
    _config = _this select 0;
    _countOptions = count _config;

    for "_index" from 0 to (_countOptions - 1) do {
        _optionEntry = _config select _index;
        [_optionEntry] call FUNC(setSettingsFromConfig);
    };
};

_fnc_removeUnusedPools = {
	private "_pool";
	_pool = [];
	{
		if (toUpper (_x select 0) isEqualTo "ALL" || {toUpper (_x select 0) isEqualTo toUpper worldName}) then {
			_x deleteAt 0;
			_pool append _x;
		};
	} forEach (_this select 0);
	_pool
};

_fnc_setSettingValid = {
	params ["_name","_typeName","_typeDetail","_value"];
	if (toUpper _typeDetail isEqualTo "POOL") then {
		if (_name in [GVAR(airPoolEast),GVAR(airPoolInd),GVAR(airPoolWest)]) then {
			{
				if !(_x isKindOf "Helicopter") then {_name deleteAt _forEachIndex};
			} forEach _name;
		};
		{
			if (typeName _x isEqualTo "STRING") then {
				if !(isClass (configfile >> "CfgVehicles" >> _x)) then {
					LOG_DEBUG_1("%1 does not exist on server.", _x);
					_value deleteAt _forEachIndex;
				};
			};
		} forEach _value;
		if (_value isEqualTo []) then {
			LOG_DEBUG_1("%1 is empty.", _name);
		};
	};
};

// default config
[configFile >> QUOTE(DOUBLES(PREFIX,settings))] call _fnc_parseConfigForSettings;

// server config
[configFile >> QUOTE(DOUBLES(PREFIX,serverSettings))] call _fnc_parseConfigForSettings;

// remove unused entries from pools
{
	if (toUpper(_x select 2) isEqualTo "POOL") then {
		_fixedPool = [_x select 3] call _fnc_removeUnusedPools;
		(_x select 3) deleteRange [0,count (_x select 3)];
		(_x select 3) append _fixedPool;
	};
} forEach GVAR(settings);

// check if settings are valid
{
	if !((_x select 2) isEqualTo "") then {
		_x call _fnc_setSettingValid;
	};
} forEach GVAR(settings);

// Publish all settings data
publicVariable QGVAR(settings);

// Publish all setting values
{
    publicVariable (_x select 0);
    false
} count GVAR(settings);