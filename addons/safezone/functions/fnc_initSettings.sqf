/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize settings via CBA framework

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

[
    QGVAR(enable), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    format ["Enable %1", COMPONENT_NAME], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    COMPONENT_NAME, // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting
    true, // "global" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_Settings_fnc_init;

[
    QGVAR(displayMarkers),
    "LIST",
    ["Safezone Markers", "Safezone map marker display settings."],
    COMPONENT_NAME,
    [
        [0,1,2],
        ["Off", "Solid", "Border"],
        0
    ],
    true,
    {
        if (isServer) then {
            switch (_this) do {
                case 0: {
                    GVAR(markers) apply {_x setMarkerAlpha 0};
                };
                case 1: {
                    GVAR(markers) apply {
                        _x setMarkerAlpha 0.4;
                        _x setMarkerBrush "SolidBorder";
                    };
                };
                case 2: {
                    GVAR(markers) apply {
                        _x setMarkerAlpha 1;
                        _x setMarkerBrush "Border";
                    };
                };
                default {};
            };	
        };
    }
] call CBA_Settings_fnc_init;