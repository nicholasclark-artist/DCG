/*
Author: Nicholas Clark (SENSEI)

Last modified: 1/9/2016

Description: load saved data for passed addon

Return: array
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

_ret = [];

if (GVAR(loadData) && {count GVAR(saveDataCurrent) > 1}) then {
	for "_index" from 1 to count GVAR(saveDataCurrent) - 1 do {
		if ((GVAR(saveDataCurrent) select _index) select 0 isEqualTo _this) then {
			_ret = (GVAR(saveDataCurrent) select _index) select 1;
			LOG_DEBUG_1("Loading saved data for %1.",_this);
		};
	};
};

_ret