/*
Author:
Nicholas Clark (SENSEI)

Description:
send marker to debug handler

Arguments:
0: marker <STRING>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

(_this select 0) setMarkerAlpha 0;
GVAR(debugMarkers) pushBack (_this select 0);

[QGVAR(debugMarkers),[]] call CBA_fnc_serverEvent;

nil