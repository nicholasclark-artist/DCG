/*
Author: Nicholas Clark (SENSEI)

Description:
add to cleanup loop, does not support nested arrays

Arguments:
0: item to cleanup <ARRAY, STRING, OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if (typeName _this isEqualTo "ARRAY") exitWith {
	if (typeName (_this select 0) isEqualTo "STRING") then {
		GVAR(markerCleanup) append _this;
	} else {
		GVAR(objectCleanup) append _this;
	};
};
if (typeName _this isEqualTo "STRING") exitWith {
	GVAR(markerCleanup) pushBack _this;
};
if (typeName _this isEqualTo "OBJECT") exitWith {
	GVAR(objectCleanup) pushBack _this;
};