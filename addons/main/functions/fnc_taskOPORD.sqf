/*
Author:
Nicholas Clark (SENSEI)

Description:
format task title and description into operation order (OPORD) 
ref: https://semo.edu/pdf/showmegold-lab_opRedhawk.pdf

Arguments:
0: task location <LOCATION>
1: ao location <LOCATION>
2: task location name <STRING>
3: ao name <STRING>
4: terrain type <STRING>
5: OPORD situation paragraph <STRING>
6: OPORD mission paragraph <STRING>
7: OPORD sustainment paragraph <STRING>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define TAB "    "
#define NEWLINE "<br/>"

params [
    ["_locationTask",locationNull,[locationNull]],
    ["_locationAO",locationNull,[locationNull]],
    ["_nameTask","",[""]],
    ["_nameAO","",[""]],
    ["_terrain","meadow",[""]],
    ["_situation","",[""]],
    ["_mission","",[""]],
    ["_sustainment",["","","","","","","","","",""],[[]]]
];

_terrain = call {
    if (COMPARE_STR(_terrain,"meadow")) exitWith {"flat"};
    if (COMPARE_STR(_terrain,"forest")) exitWith {"forested"};
    if (COMPARE_STR(_terrain,"peak")) exitWith {"uneven with large elevation changes"};

    ""
};

private _weather = if (CHECK_ADDON_2(weather)) then {
    format ["%1°C high, %2°C low, %3%4 chance of precipitation.",EGVAR(weather,tempDay),EGVAR(weather,tempNight),round EGVAR(weather,precipitation),"%"]
} else {
    "Weather forecast data is unavailable."
};

private _transport = if (CHECK_ADDON_2(transport)) then {
    "CASEVAC is available upon request."
} else {
    "None."
};

private _sustainmentFormatted = [];

{
    if (COMPARE_STR(_x,"")) then {
        _sustainmentFormatted pushBack "None.";
    } else {
        _sustainmentFormatted pushBack _x;
    };
} forEach _sustainment;

private _para1 = [
    "1. ORIENTATION",
    format ["%1Map grid position: %2.",TAB,mapGridPosition getPos _locationTask],
    format ["%1Terrain: %2m Altitude. Terrain is predominantly %3.",TAB,round getTerrainHeightASL (getPos _locationTask),_terrain],
    format ["%1Weather: %2",TAB,_weather]
] joinString (NEWLINE); 

private _para2 = [
    "2. SITUATION",
    format ["%1%2",TAB,_situation]
] joinString (NEWLINE); 

private _para3 = [
    "3. MISSION",
    format ["%1%2",TAB,_mission]
] joinString (NEWLINE); 

private _para4 = [
    "4. SUSTAINMENT",
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

[format ["AO %1: OBJ %2",_nameAO,_nameTask],[_para1,_para2,_para3,_para4] joinString ((NEWLINE) + (NEWLINE))]

