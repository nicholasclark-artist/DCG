/*
Author:
Nicholas Clark (SENSEI)

Description:
format task title and description into operation order (OPORD)
ref: https://semo.edu/pdf/showmegold-lab_opRedhawk.pdf

Arguments:
0: location <LOCATION>
1: OPORD situation paragraph <STRING>
2: OPORD mission paragraph <STRING>
3: OPORD sustainment paragraph <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define TAB "    "
#define NEWLINE "<br/>"

params [
    ["_location",locationNull,[locationNull]],
    ["_situation","",[""]],
    ["_mission","",[""]],
    ["_sustainment",[],[[]]]
];

private _OPORD = [];
private _isArea = [GVAR(areas),_location getVariable [QEGVAR(main,name),""]] call CBA_fnc_hashHasKey;

private _para1 = if (_isArea) then {
    // get area orientation
    private _center = [_location getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON],1] call EFUNC(main,polygonCenter);
    private _orientation = if (CHECK_DIST2D(_center,EGVAR(main,center),EGVAR(main,radius) * 0.2)) then {
        "central"
    } else {
        [[EGVAR(main,center) getDir (getPos _location)] call EFUNC(main,getDirCardinal),"ern"] joinString ""
    };

    // get area km²
    private _A = parseNumber (([_location getVariable [QEGVAR(main,polygon),[]]] call EFUNC(main,polygonArea)) toFixed 1);

    // get area elevation
    private _elevation = 0;
    private _elevations =+ (_location getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON]);

    _elevations = _elevations apply {ASLZ(_x)};

    {
        _elevation = _elevation + _x;
    } forEach _elevations;

    _elevation = round (_elevation / (count _elevations));

    [
        "ORIENTATION",
        format ["%1a. AO %2 is located in the %3 region of %4.",TAB,_location getVariable [QGVAR(name),""],_orientation,[worldName] call CBA_fnc_capitalize],
        format ["%1b. AO %2 covers %3km².",TAB,_location getVariable [QGVAR(name),""],_A],
        format ["%1c. The average elevation of the area is %2m above sea level.",TAB,_elevation]
    ] joinString NEWLINE;
} else {
    ""
};

private _para2 = if !(_situation isEqualTo "") then {
    [
        "SITUATION",
        format ["%1a. %2",TAB,_situation]
    ] joinString NEWLINE;
} else {
    ""
};

private _para3 = if !(_mission isEqualTo "") then {
    [
        "MISSION",
        format ["%1a. %2",TAB,_mission]
    ] joinString NEWLINE;
} else {
    ""
};

private _para4 = if !(_sustainment isEqualTo []) then {
    // get CASEVAC status
    private _transport = if (CHECK_ADDON_2(transport)) then {
        "Available upon request."
    } else {
        "None."
    };

    // format sustainment classes
    private _sustainmentFormatted = [];
    private _sustainmentClasses = [
        format ["%1%1%1a. Class I - Rations -",TAB],
        format ["%1%1%1b. Class II - Clothing / equipment -",TAB],
        format ["%1%1%1c. Class III - POL -",TAB],
        format ["%1%1%1d. Class IV - Construction materials -",TAB],
        format ["%1%1%1e. Class V - Ammunition -",TAB],
        format ["%1%1%1f. Class VI - Personal demand items -",TAB],
        format ["%1%1%1g. Class VII - Major end items -",TAB],
        format ["%1%1%1h. Class VIII - Medical material -",TAB],
        format ["%1%1%1i. Class IX - Repair parts -",TAB],
        format ["%1%1%1j. Class X - Misc. supplies -",TAB]
    ];

    // make sure sustainment is correct length
    _sustainment =+ _sustainment;
    _sustainment resize 10;

    {
        if (!isNil "_x" && {!COMPARE_STR(_x,"")}) then {
            _sustainmentFormatted pushBack ([_sustainmentClasses select _forEachIndex,_x] joinString " ");
        };
    } forEach _sustainment;

    _sustainmentFormatted = _sustainmentFormatted joinString NEWLINE;

    [
        "SUSTAINMENT",
        format ["%1a. Logistics.",TAB],
        format ["%1%1 1. Classes of supply.",TAB],
        _sustainmentFormatted,
        format ["%1b. Personnel.",TAB],
        format ["%1%1 1. Transport - %2",TAB,_transport]
    ] joinString NEWLINE;
} else {
    ""
};

// format paragraph order
{
    if !(_x isEqualTo "") then {
        private _formatted = [(count _OPORD) + 1,_x] joinString ". ";
        _OPORD pushBack _formatted;
    };
} forEach [_para1,_para2,_para3,_para4];

[format ["%1 %2",["OBJ","AO"] select _isArea,_location getVariable [QGVAR(name),""]],_OPORD joinString (NEWLINE + NEWLINE)]