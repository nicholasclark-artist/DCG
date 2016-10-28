/*
Author:
esteldunedain, Nicholas Clark (SENSEI)

Description:
Load a setting from config

Arguments:
0: config entry <CONFIG>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_entry"];

_name = configName _entry;
private _typeName = getText (_entry >> "typeName");

private _fnc_getConfigValue = {
    params ["_entry", "_typeName"];

    private _value = (_entry >> "value");

    if (COMPARE_STR(_typeName,"string")) exitWith {
        getText _value
    };
    if (COMPARE_STR(_typeName,"array") || {COMPARE_STR(_typeName,"pool")} || {COMPARE_STR(_typeName,"world")}) exitWith {
        getArray _value
    };

    getNumber _value // default
};

_value = [_entry,_typeName] call _fnc_getConfigValue;
_value = [_name,_typeName,_value] call FUNC(setSettingsValue);

if (isNil _name) then { // init setting and send to clients
    missionNamespace setVariable [_name,_value,true];
} else {
    if !((missionNamespace getVariable [_name, nil]) isEqualTo _value) then { // update setting and send to clients
        missionNamespace setVariable [_name,_value,true];
        INFO_3("Overwriting %1 (%2): %3", _name, _typeName, _value);
    };
};
