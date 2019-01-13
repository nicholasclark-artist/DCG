/*
Author:
Nicholas Clark (SENSEI)

Description:
set debug options

Arguments:
0: debug options <NUMBER>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

switch (_this select 0) do {
    case 0: {
        GVAR(debug) = false; 
        GVAR(debugMarkers) apply {_x setMarkerAlpha 0};
    };
    case 1: {
        GVAR(debug) = true; 
        GVAR(debugMarkers) apply {_x setMarkerAlpha 1};
    };
    default { };
};

nil