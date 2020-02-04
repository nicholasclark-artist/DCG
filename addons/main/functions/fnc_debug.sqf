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

params [
    ["_option",1,[0]]
];

switch _option do {
    case 0: {
        GVAR(debug) = false; 
        GVAR(debugMarkers) apply {_x setMarkerAlpha 0};

        [QGVAR(debug),[0]] call CBA_fnc_serverEvent;
    };
    case 1: {
        GVAR(debug) = true; 
        GVAR(debugMarkers) apply {_x setMarkerAlpha 1};

        [QGVAR(debug),[1]] call CBA_fnc_serverEvent;
    };
    default { };
};

nil