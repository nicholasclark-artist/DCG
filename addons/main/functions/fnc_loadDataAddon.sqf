/*
Author:
Nicholas Clark (SENSEI)

Description:
load saved data for passed addon

Arguments:

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
			LOG_DEBUG_1("Loading saved data for %1.",_this);
		};
	};
};

_ret