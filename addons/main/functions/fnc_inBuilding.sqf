/*
Author:
Killzone Kid, Nicholas Clark (SENSEI)

Description:
check if in building

Arguments:
0: position or object to check <ARRAY,OBJECT>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

private ["_pos","_ignore","_house"];

if ((_this select 0) isEqualType objNull) then {
    _pos = getPosWorld (_this select 0);
    _ignore = (_this select 0);
} else {
    _pos = AGLToASL (_this select 0);
    _ignore = objNull;
};

lineIntersectsSurfaces [_pos, _pos vectorAdd [0, 0, 50], _ignore, objNull, true, 1, "GEOM", "NONE"] select 0 params ["","","","_house"];

if (_house isKindOf "House") exitWith {true};

false