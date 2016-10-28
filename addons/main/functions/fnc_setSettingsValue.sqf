/*
Author:
esteldunedain, Nicholas Clark (SENSEI)

Description:
process setting value

Arguments:
0: setting name <STRING>
1: setting type <STRING>
2: setting value <ANY>

Return:
value
__________________________________________________________________*/
#include "script_component.hpp"

params ["_name","_typeName","_value"];

call {
    if (COMPARE_STR(_typeName,"bool")) exitWith {
        _value = _value > 0;
    };
    if (COMPARE_STR(_typeName,"side")) exitWith {
        call {
            if (_value isEqualTo 0) exitWith {
                _value = EAST;
            };
            if (_value isEqualTo 1) exitWith {
                _value = WEST;
            };
            if (_value isEqualTo 2) exitWith {
                _value = RESISTANCE;
            };
            if (_value isEqualTo 3) exitWith {
                _value = CIVILIAN;
            };
        };
    };
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
                WARNING_2("%1 does not exist on server, removing class from %2", _class,_name);
                _pool deleteAt _i;
            };
        };

        if (_pool isEqualTo []) then {
            WARNING_1("%1 is empty", _name);
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
