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
    if !(GVAR(debug)) then {
        GVAR(debug) = true;

        [] spawn {
            while {GVAR(debug)} do {
                GVAR(debugMarkers) apply {_x setMarkerAlpha 1};
                sleep 2;
            };
        }; 
    };
} else {
    GVAR(debug) = false; 
    GVAR(debugMarkers) apply {_x setMarkerAlpha 0};
};

nil