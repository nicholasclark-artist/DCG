/*
Author:
Nicholas Clark (SENSEI)

Description:
format task title and description into operation order (OPORD) 
ref: https://semo.edu/pdf/showmegold-lab_opRedhawk.pdf

Arguments:
0: location <LOCATION>
1: terrain type <STRING>
2: OPORD situation paragraph <STRING>
3: OPORD mission paragraph <STRING>
4: OPORD sustainment paragraph <STRING>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define TAB "    "
#define NEWLINE "<br/>"

params [
    ["_location",locationNull,[locationNull]],
    ["_terrain","meadow",[""]],
    ["_situation","",[""]],
    ["_mission","",[""]],
    ["_sustainment",["","","","","","","","","",""],[[]]]
];

private _OPORD = [];
private _isArea = [GVAR(areas), _location getVariable [QEGVAR(main,name),""]] call CBA_fnc_hashHasKey;

_terrain = call {
    if (COMPARE_STR(_terrain,"meadow")) exitWith {"The terrain is predominantly flat"};
    if (COMPARE_STR(_terrain,"forest")) exitWith {"The terrain is predominantly forested"};
    if (COMPARE_STR(_terrain,"peak")) exitWith {"The terrain is predominantly uneven with large elevation changes"};

    "The terrain characteristics are unavailable"
};

private _para1 = if (_isArea) then {
    // get area elevation
    private _elevation = 0;
    private _elevations =+ _location getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON];

    _elevations = _elevations apply {getTerrainHeightASL _x};

    {
        _elevation = _elevation + _x;
    } forEach _elevations;    

    // get area weather 
    private _weather = if (CHECK_ADDON_2(weather)) then {
        format ["%1°C high, %2°C low, %3%4 chance of precipitation.",EGVAR(weather,tempDay),EGVAR(weather,tempNight),round EGVAR(weather,precipitation),"%"]
    } else {
        "Weather forecast data is unavailable."
    };

    [
        "ORIENTATION",
        format ["%1a. The average elevation of the area is %2m above sea level. %3.",TAB,round (_elevation / (count _elevations)),_terrain],
        format ["%1b. Weather: %2",TAB,_weather]
    ] joinString (NEWLINE); 
} else {
    ""
};

private _para2 = if !(_situation isEqualTo "") then {
    [
        "SITUATION",
        format ["%1a. %2",TAB,_situation]
    ] joinString (NEWLINE);
} else {
    ""
};

private _para3 = if !(_mission isEqualTo "") then {
    [
        "MISSION",
        format ["%1a. %2",TAB,_mission]
    ] joinString (NEWLINE);
} else {
    ""
};

private _para4 = if !(_sustainment isEqualTo "") then {
    // get CASEVAC status
    private _transport = if (CHECK_ADDON_2(transport)) then {
        "CASEVAC is available upon request."
    } else {
        "None."
    };

    // format sustainment classes
    private _sustainmentFormatted = [];

    {
        if (COMPARE_STR(_x,"")) then {
            _sustainmentFormatted pushBack "None.";
        } else {
            _sustainmentFormatted pushBack _x;
        };
    } forEach _sustainment;

    [
        "SUSTAINMENT",
        format ["%1a. Logistics.",TAB],
        format ["%1%1 1. Classes of supply.",TAB],
        format ["%1%1%1a. Class I - Rations - %2",TAB,_sustainmentFormatted select 0],
        format ["%1%1%1b. Class II - Clothing / equipment - %2",TAB,_sustainmentFormatted select 1],
        format ["%1%1%1c. Class III - POL - %2",TAB,_sustainmentFormatted select 2],
        format ["%1%1%1d. Class IV - Construction materials - %2",TAB,_sustainmentFormatted select 3],
        format ["%1%1%1e. Class V - Ammunition - %2",TAB,_sustainmentFormatted select 4],
        format ["%1%1%1f. Class VI - Personal demand items - %2",TAB,_sustainmentFormatted select 5],
        format ["%1%1%1g. Class VII - Major end items - %2",TAB,_sustainmentFormatted select 6],
        format ["%1%1%1h. Class VIII - Medical material - %2",TAB,_sustainmentFormatted select 7],
        format ["%1%1%1i. Class IX - Repair parts - %2",TAB,_sustainmentFormatted select 8],
        format ["%1%1%1j. Class X - Misc. supplies - %2",TAB,_sustainmentFormatted select 9],
        format ["%1b. Personnel.",TAB],
        format ["%1%1 1. Transport - %2",TAB,_transport]
    ] joinString (NEWLINE); 
} else {
    ""
};

// format paragraph order 
{
    if !(_x isEqualTo "") then {
        private _formatted = [_forEachIndex + 1,_x] joinString ". ";
        _OPORD pushBack _formatted;
    };
} forEach [_para1,_para2,_para3,_para4];

[format ["%1 %2",["OBJ","AO"] select _isArea,_location getVariable [QGVAR(name),""]],_OPORD joinString ((NEWLINE) + (NEWLINE))]