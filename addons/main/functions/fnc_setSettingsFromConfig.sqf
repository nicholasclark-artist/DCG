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

params ["_optionEntry"];

private _fnc_getValueWithType = {
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

private _fnc_fixSettingValue = {
    private ["_pool","_class"];
    params ["_name","_typeName","_typeDetail","_value","_debug"];

    if (toUpper _typeDetail isEqualTo "POOL") then {
        _pool = [];
        {
            if (toUpper (_x select 0) isEqualTo "ALL" || {toUpper (_x select 0) isEqualTo toUpper worldName} || {toUpper (_x select 0) isEqualTo toUpper missionName}) then {
                _x deleteAt 0;
                _pool append _x;
            };
            false
        } count _value;

        _pool = _pool arrayIntersect _pool;
        _value = _pool;

        for "_i" from (count _value - 1) to 0 step -1 do {
            _class = _value select _i;
            if (_class isEqualType "") then {
                if !(isClass (configfile >> "CfgVehicles" >> _class)) then {
                    INFO_1("%1 does not exist on server.", _class);
                    _value deleteAt _i;
                } else {
                    _side = getNumber (configfile >> "CfgVehicles" >> _class >> "side");
                    call {
                        if (_side isEqualTo 0) exitWith {
                            _side = "EAST";
                        };
                        if (_side isEqualTo 1) exitWith {
                            _side = "WEST";
                        };
                        if (_side isEqualTo 2) exitWith {
                            _side = "INDEPENDENT";
                        };
                        if (_side isEqualTo 3) exitWith {
                            _side = "CIVILIAN";
                        };
                    };
                    if (_debug) then {
                        LOG_2("%1 (%2) exists on server.", _class, _side);
                    };
                };
            };
        };

        if (_value isEqualTo []) then {
            WARNING_1("%1 is empty.", _name);
        };
    };

    if (toUpper _typeDetail isEqualTo "WORLD") then {
        private _arr = [];
        {
            if (toUpper (_x select 0) isEqualTo toUpper worldName) then {
                _x deleteAt 0;
                _arr append _x;
            };
            false
        } count _value;

        _value = _arr;
    };

    _value
};

_name = configName _optionEntry;
private _typeDetail = getText (_optionEntry >> "typeDetail");

// Check if the variable is already defined
if (isNil _name) then {
    // Get type from config
    private _typeName = toUpper (getText (_optionEntry >> "typeName"));

    if (_typeName isEqualTo "") then {
        _typeName = "SCALAR";
    };

    // Read entry and cast it to the correct type
    _value = [_optionEntry, _typeName] call _fnc_getValueWithType;

    // get correct pool for map and check if values exists on server
    _value = [_name,_typeName,_typeDetail,_value,false] call _fnc_fixSettingValue;

    LOG_4("%1, %2, %3, %4", _name, _typeName, _typeDetail, _value);

    // Init the variable
    missionNamespace setVariable [_name,_value];

    // Add the setting to a list on the server
    private _settingData = [
        _name,
        _typeName,
        _typeDetail,
        _value
    ];

    GVAR(settings) pushBack _settingData;
} else {
    private _typeName = "";
    {
        if ((_x select 0) isEqualTo _name) then {
            _typeName = _x select 1;
        };
        false
    } count GVAR(settings);

    // Read entry and cast it to the correct type from the existing variable
    private _value = [_optionEntry, _typeName] call _fnc_getValueWithType;

    // get correct pool for map and check if values exists on server
    _value = [_name,_typeName,_typeDetail,_value,true] call _fnc_fixSettingValue;

    // Update the variable
    missionNamespace setVariable [_name,_value];
};