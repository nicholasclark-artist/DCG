/*
Author:
Nicholas Clark (SENSEI)

Description:
enable/disable debug markers

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
	["_debug",false,[true]]
];

if (_debug) then {
	GVAR(debugMarkers) apply {_x setMarkerAlpha 1};
} else {
	GVAR(debugMarkers) apply {_x setMarkerAlpha 0};
};