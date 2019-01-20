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
#define ERROR_SAMESIDE format ["%1 cannot be equal to %2!",QGVAR(enemySide),QGVAR(playerSide)]

[
    QGVAR(enable), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    format ["Enable %1", toUpper QUOTE(PREFIX)], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    COMPONENT_NAME, // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting
    true, // "global" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {}, // function that will be executed once on mission start and every time the setting is changed.
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(loadData),
    "CHECKBOX",
    ["Load Mission Data","Load mission data saved to server profile."],
    COMPONENT_NAME,
    false,
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(autoSave),
    "CHECKBOX",
    ["Autosave Mission Data","Autosave mission data to server profile."],
    COMPONENT_NAME,
    false,
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(playerSide),
    "LIST",
    ["Player Side","Cannot be the same as enemy side and must be equal to the side of playable units. It's recommended to force this setting in the EDEN editor."],
    COMPONENT_NAME,
    [
        [EAST,WEST,INDEPENDENT],
        ["EAST","WEST","INDEPENDENT"],
        1
    ],
    true,
    {}
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
    true,
    {
        if (_this isEqualTo GVAR(playerSide)) then {
            systemChat (LOG_SYS_FORMAT("ERROR",ERROR_SAMESIDE));
            ERROR(ERROR_SAMESIDE);
        };
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(factionsEast),
    "EDITBOX",
    ["East Factions","Entities from the listed factions will be included. Factions must be separated by a comma."],
    COMPONENT_NAME,
    "OPF_F",
    true,
    {
        [0] call FUNC(setPool);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(filtersEast),
    "EDITBOX",
    ["East Filters","Exclude entities by listing display names. Names must be separated by a comma and partial names are allowed."],
    COMPONENT_NAME,
    "diver,vr ,pilot,survivor,crew,rifleman (unarmed)",
    true,
    {
        [0] call FUNC(setPool);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(factionsWest),
    "EDITBOX",
    ["West Factions","Entities from the listed factions will be included. Factions must be separated by a comma."],
    COMPONENT_NAME,
    "BLU_F",
    true,
    {
        [1] call FUNC(setPool);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(filtersWest),
    "EDITBOX",
    ["West Filters","Exclude entities by listing display names. Names must be separated by a comma and partial names are allowed."],
    COMPONENT_NAME,
    "diver,vr ,pilot,survivor,crew,rifleman (unarmed)",
    true,
    {
        [1] call FUNC(setPool);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(factionsInd),
    "EDITBOX",
    ["Independent Factions","Entities from the listed factions will be included. Factions must be separated by a comma."],
    COMPONENT_NAME,
    "IND_F",
    true,
    {
        [2] call FUNC(setPool);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(filtersInd),
    "EDITBOX",
    ["Ind Filters","Exclude entities by listing display names. Names must be separated by a comma and partial names are allowed."],
    COMPONENT_NAME,
    "diver,vr ,pilot,survivor,crew,rifleman (unarmed)",
    true,
    {
        [2] call FUNC(setPool);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(factionsCiv),
    "EDITBOX",
    ["Civilian Factions","Entities from the listed factions will be included. Factions must be separated by a comma."],
    COMPONENT_NAME,
    "CIV_F",
    true,
    {
        [3] call FUNC(setPool);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(filtersCiv),
    "EDITBOX",
    ["Civ Filters","Exclude entities by listing display names. Names must be separated by a comma and partial names are allowed."],
    COMPONENT_NAME,
    "driver,vr ,pilot,construction,kart",
    true,
    {
        [3] call FUNC(setPool);
    }
] call CBA_Settings_fnc_init;