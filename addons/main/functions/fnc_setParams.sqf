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

{
    private _pname = configName ((missionConfigFile >> "Params") select _ForEachIndex);
    private _pval = paramsArray select _ForEachIndex;
    private _ptype = getText (missionConfigFile >> "Params" >> _pname >> "typeName");
    private _pset = getNumber (missionConfigFile >> "Params" >> _pname >> QUOTE(DOUBLES(PREFIX,setting)));

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
        INFO_3("Include mission parameter setting: %1, %2, %3", _pname,_pval,_ptype);
    };
} forEach paramsArray;