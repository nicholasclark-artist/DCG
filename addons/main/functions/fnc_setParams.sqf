/*
Author:
Nicholas Clark (SENSEI)

Description:
sets parameters

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

private ["_pname","_pval","_ptype","_pset"];

{
	_pname = configName ((missionConfigFile >> "Params") select _ForEachIndex);
	_pval = paramsArray select _ForEachIndex;
    _ptype = getText (missionConfigFile >> "Params" >> _pname >> "typeName");
	_pset = getNumber (missionConfigFile >> "Params" >> _pname >> "setParam");
    if (_pset > 0) then {
        if (_ptype isEqualTo "BOOL") then {
            _pval = _pval > 0
        };
        if (_ptype isEqualTo "SIDE") then {
            if (_pval isEqualTo 0) exitWith {
                _pval = EAST;
            };
            if (_pval isEqualTo 1) exitWith {
                _pval = WEST;
            };
            if (_pval isEqualTo 2) exitWith {
                _pval = RESISTANCE;
            };
            if (_pval isEqualTo 3) exitWith {
                _pval = CIVILIAN;
            };
        };

        missionNamespace setVariable [_pname,_pval,true];
        INFO_2("Parameter: %1 = %2", _pname,_pval);
    };
} forEach paramsArray;