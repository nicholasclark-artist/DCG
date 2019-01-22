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
#define CATEGORY_FACTION [COMPONENT_NAME,"Faction Settings"]
#define CATEGORY_SAVE [COMPONENT_NAME,"Save System Settings"]
#define CATEGORY_SAFE [COMPONENT_NAME,"Safezone Settings"]
#define ERROR_SAMESIDE format ["%1 cannot be equal to %2!",QGVAR(enemySide),QGVAR(playerSide)]

[
    QGVAR(enable),
    "CHECKBOX",
    format ["Enable %1", toUpper QUOTE(PREFIX)],
    COMPONENT_NAME,
    true,
    true,
    {[QGVAR(enable),_this] call FUNC(handleSettingChange)},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(loadData),
    "CHECKBOX",
    ["Load Mission Data","Load mission data from server profile."],
    CATEGORY_SAVE,
    false,
    true,
    {[QGVAR(loadData),_this] call FUNC(handleSettingChange)},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(autoSave),
    "CHECKBOX",
    ["Autosave Mission Data","Autosave mission data to server profile."],
    CATEGORY_SAVE,
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
    {[QGVAR(playerSide),_this] call FUNC(handleSettingChange)},
    true
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
        [QGVAR(enemySide),_this] call FUNC(handleSettingChange);

        if (_this isEqualTo GVAR(playerSide)) then {
            systemChat (LOG_SYS_FORMAT("ERROR",ERROR_SAMESIDE));
            ERROR(ERROR_SAMESIDE);
        };
    },
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(factionsEast),
    "EDITBOX",
    ["East Factions","Entities from the listed factions will be included. Factions must be separated by a comma."],
    CATEGORY_FACTION,
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
    CATEGORY_FACTION,
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
    CATEGORY_FACTION,
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
    CATEGORY_FACTION,
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
    CATEGORY_FACTION,
    "IND_F",
    true,
    {
        [2] call FUNC(setPool);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(filtersInd),
    "EDITBOX",
    ["Independent Filters","Exclude entities by listing display names. Names must be separated by a comma and partial names are allowed."],
    CATEGORY_FACTION,
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
    CATEGORY_FACTION,
    "CIV_F",
    true,
    {
        [3] call FUNC(setPool);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(filtersCiv),
    "EDITBOX",
    ["Civilian Filters","Exclude entities by listing display names. Names must be separated by a comma and partial names are allowed."],
    CATEGORY_FACTION,
    "driver,vr ,pilot,construction,kart",
    true,
    {
        [3] call FUNC(setPool);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(safezoneEnable),
    "CHECKBOX",
    "Enable Safezones",
    CATEGORY_SAFE,
    true,
    true,
    {[QGVAR(enable),_this] call FUNC(handleSettingChange)},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(safezoneMarkersDisplay),
    "LIST",
    ["Safezone Markers", "Safezone map marker display settings."],
    CATEGORY_SAFE,
    [
        [0,1,2],
        ["Off", "Solid", "Border"],
        0
    ],
    true,
    {
        if (!isServer) exitWith {};
        
        switch (_this) do {
            case 0: {
                GVAR(safezoneMarkers) apply {_x setMarkerAlpha 0};
            };
            case 1: {
                GVAR(safezoneMarkers) apply {
                    _x setMarkerAlpha 0.4;
                    _x setMarkerBrush "SolidBorder";
                };
            };
            case 2: {
                GVAR(safezoneMarkers) apply {
                    _x setMarkerAlpha 1;
                    _x setMarkerBrush "Border";
                };
            };
            default {};
        };
    }
] call CBA_Settings_fnc_init;