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

private _fnc_getValueWithType = {
    params ["_entry", "_typeName"];

    private _value = (_entry >> "value");

    if (COMPARE_STR(_typeName,"scalar")) exitWith {
        getNumber _value
    };
    if (COMPARE_STR(_typeName,"bool")) exitWith {
        (getNumber _value) > 0
    };
    if (COMPARE_STR(_typeName,"string")) exitWith {
        getText _value
    };
    if (COMPARE_STR(_typeName,"array") || {COMPARE_STR(_typeName,"pool")} || {COMPARE_STR(_typeName,"world")}) exitWith {
        getArray _value
    };

    getNumber _value // default
};

private _fnc_setValueWithType = {
    params ["_name","_typeName","_value"];

    call {
        if (COMPARE_STR(_typeName,"pool")) exitWith {
            private _pool = [];
            {
                if (COMPARE_STR(_x select 0,"all") || {COMPARE_STR(_x select 0,worldName)} || {COMPARE_STR(_x select 0,missionName)}) then {
                    _x deleteAt 0;
                    _pool append _x;
                };
                false
            } count _value;

            _pool = _pool arrayIntersect _pool; // remove duplicates
            _pool = _pool select {_x isEqualType ""}; // remove non string elements

            for "_i" from (count _pool - 1) to 0 step -1 do { // remove bad classes
                private _class = _pool select _i;

                if !(isClass (configfile >> "CfgVehicles" >> _class)) then {
                    INFO_2("%1 does not exist on server, removing class from %2", _class,_name);
                    _pool deleteAt _i;
                };
            };

            if (_pool isEqualTo []) then {
                INFO_1("%1 is empty.", _name);
            };

            _value = _pool;
        };

        if (COMPARE_STR(_typeName,"world")) exitWith {
            private _arr = [];

            {
                if (COMPARE_STR(_x select 0,worldName)) exitWith {
                    _x deleteAt 0;
                    _arr append _x;
                };
                false
            } count _value;

             _value = _arr;
        };
    };

    _value
};

_name = configName _entry;
private _typeName = getText (_entry >> "typeName");

if (_typeName isEqualTo "") then {
    _typeName = "scalar";
};

// Check if the variable is already defined
if (isNil _name) then {
    // Read entry and cast it to the correct type
    private _value = [_entry, _typeName] call _fnc_getValueWithType;

    _value = [_name,_typeName,_value] call _fnc_setValueWithType;

    // Init the variable
    missionNamespace setVariable [_name,_value];

    // Add the setting to a list on the server
    private _settingData = [
        _name,
        _typeName,
        _value
    ];

    GVAR(settings) pushBack _settingData;
} else {
    // Read entry and cast it to the correct type from the existing variable
    private _value = [_entry, _typeName] call _fnc_getValueWithType;

    _value = [_name,_typeName,_value] call _fnc_setValueWithType;

    INFO_3("Include userconfig setting: %1, %2, %3", _name, _typeName, _value);

    // Update the variable
    missionNamespace setVariable [_name,_value];
};