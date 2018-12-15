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
    format ["Enable %1", toUpper QUOTE(PREFIX)], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    COMPONENT_NAME, // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting
    true, // "global" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_Settings_fnc_init;

[
    QGVAR(loadData),
    "CHECKBOX",
    ["Load Mission Data","Load mission data saved to server profile."],
    COMPONENT_NAME,
    false,
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(autoSave),
    "CHECKBOX",
    ["Autosave Mission Data","Autosave mission data to server profile."],
    COMPONENT_NAME,
    false,
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(playerSide),
    "LIST",
    ["Player Side","Cannot be the same as enemy side."],
    COMPONENT_NAME,
    [
        [EAST,WEST,INDEPENDENT],
        ["EAST","WEST","INDEPENDENT"],
        1
    ],
    false,
    {
        if (isServer) then {
            SETTINGS_OVERWRITE(QGVAR(playerSide),GVAR(playerSide));

            if (GVAR(playerSide) isEqualTo GVAR(enemySide)) then {
                ERROR("Player side cannot be equal to enemy side")
            };
        };
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(enemySide),
    "LIST",
    ["Enemy Side","Cannot be the same as player side."],
    COMPONENT_NAME,
    [
        [EAST,WEST,INDEPENDENT],
        ["EAST","WEST","INDEPENDENT"],
        0
    ],
    false,
    {
        if (isServer) then {
            SETTINGS_OVERWRITE(QGVAR(enemySide),GVAR(enemySide));

            if (GVAR(playerSide) isEqualTo GVAR(enemySide)) then {
                ERROR("Enemy side cannot be equal to player side")
            };
        };
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(factionEast),
    "EDITBOX",
    ["East Factions","Units from the listed factions will be included. Factions must be separated by a comma."],
    COMPONENT_NAME,
    "OPF_F",
    false,
    {
        if (isServer) then {
            [0] call FUNC(parseFactions);
        };
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(factionWest),
    "EDITBOX",
    ["West Factions","Units from the listed factions will be included. Factions must be separated by a comma."],
    COMPONENT_NAME,
    "BLU_F",
    false,
    {
        if (isServer) then {
            [1] call FUNC(parseFactions);
        };
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(factionInd),
    "EDITBOX",
    ["Independent Factions","Units from the listed factions will be included. Factions must be separated by a comma."],
    COMPONENT_NAME,
    "IND_F",
    false,
    {
        if (isServer) then {
            [2] call FUNC(parseFactions);
        };
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(factionCiv),
    "EDITBOX",
    ["Civilian Factions","Units from the listed factions will be included. Factions must be separated by a comma."],
    COMPONENT_NAME,
    "CIV_F",
    false,
    {
        if (isServer) then {
            [3] call FUNC(parseFactions);
        };
    }
] call CBA_Settings_fnc_init;