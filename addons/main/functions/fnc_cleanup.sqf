/*
Author: SENSEI

Last modified: 9/30/2015

Description: add to cleanup handler

Note: does not support nested arrays

Return: nothing
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