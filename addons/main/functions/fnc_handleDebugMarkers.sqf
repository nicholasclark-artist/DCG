/*
Author:
Nicholas Clark (SENSEI)

Description:
handle debug marker array

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if (CHECK_DEBUG) then {
	GVAR(debugMarkers) apply {_x setMarkerAlpha 1};
} else {
	GVAR(debugMarkers) apply {_x setMarkerAlpha 0};
};