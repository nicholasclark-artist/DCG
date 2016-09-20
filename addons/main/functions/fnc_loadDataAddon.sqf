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

_ret = [];

if (GVAR(loadData) && {count GVAR(saveDataCurrent) > 1}) then {
	for "_index" from 1 to count GVAR(saveDataCurrent) - 1 do {
		if (toLower ((GVAR(saveDataCurrent) select _index) select 0) isEqualTo toLower _this) then {
			_ret = (GVAR(saveDataCurrent) select _index) select 1;
			LOG_DEBUG_2("Loading data for %1: %2.",_this,_ret);
		};
	};
};

_ret