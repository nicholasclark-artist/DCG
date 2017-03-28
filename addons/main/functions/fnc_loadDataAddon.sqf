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
        if (_forEachIndex > 0 && {COMPARE_STR(_x select 0,_this)}) exitWith {
            _ret = _x select 1;
        	INFO_2("Loading data for %1: %2.",_this,_ret);
        };
	} forEach GVAR(saveDataCurrent);
};

_ret
