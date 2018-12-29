/*
Author:
Nicholas Clark (SENSEI)

Description:
enable/disable debug markers

Arguments:
0: enable debug <BOOL>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (_this) then {
	GVAR(debugMarkers) apply {_x setMarkerAlpha 1};
} else {
	GVAR(debugMarkers) apply {_x setMarkerAlpha 0};
};

nil