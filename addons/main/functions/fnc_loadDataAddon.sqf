/*
Author:
Nicholas Clark (SENSEI)

Description:
load saved data for passed addon

Arguments:
0: addon name <STRING>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

private _ret = [];

if (GVAR(loadData)) then {
    {
        if (_forEachIndex > 0 && {COMPARE_STR(_x#0,_this#0)}) exitWith {
            _ret = _x#1;
            INFO_2("Loading data for %1: %2.",_this#0,_ret);
        };
    } forEach GVAR(saveDataScenario);
};

_ret