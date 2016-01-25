/*
Author: esteldunedain, SENSEI

Description:
Load a setting from config

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_optionEntry","_fnc_getValueWithType","_typeName","_value","_typeDetail","_settingData"];
params ["_optionEntry"];

_fnc_getValueWithType = {
    private ["_value"];
    params ["_optionEntry", "_typeName"];

    _value = (_optionEntry >> "value");
    if (_typeName isEqualTo "SCALAR") exitWith {
        getNumber _value
    };
    if (_typeName isEqualTo "BOOL") exitWith {
        (getNumber _value) > 0
    };
    if (_typeName isEqualTo "STRING") exitWith {
        getText _value
    };
    if (_typeName isEqualTo "ARRAY") exitWith {
        getArray _value
    };
    if (_typeName isEqualTo "COLOR") exitWith {
        getArray _value
    };

    getNumber _value // default
};

_name = configName _optionEntry;
_typeDetail = getText (_optionEntry >> "typeDetail");
// Check if the variable is already defined
if (isNil _name) then {
    // Get type from config
    _typeName = toUpper (getText (_optionEntry >> "typeName"));
    if (_typeName isEqualTo "") then {
        _typeName = "SCALAR";
    };

    // Read entry and cast it to the correct type
    _value = [_optionEntry, _typeName] call _fnc_getValueWithType;
    // LOG_DEBUG_4("%1, %2, %3, %4", _name, _typeName, _typeDetail, _value);
    // Init the variable
    missionNamespace setVariable [_name,_value];
    // Add the setting to a list on the server
    _settingData = [
        _name,
        _typeName,
        _typeDetail,
        _value
    ];
    GVAR(settings) pushBack _settingData;
} else {
    _typeName = "";
    {
        if ((_x select 0) isEqualTo _name) then {
            _typeName = _x select 1;
        };
    } count GVAR(settings);
    // Read entry and cast it to the correct type from the existing variable
    _value = [_optionEntry, _typeName] call _fnc_getValueWithType;
    // LOG_DEBUG_4("%1, %2, %3, %4", _name, _settingData select 1, _settingData select 2, _value);

    // Update the variable
    missionNamespace setVariable [_name,_value];
};