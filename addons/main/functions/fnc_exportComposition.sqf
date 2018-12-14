/*
Author:
Nicholas Clark (SENSEI)

Description:
export base data from 3DEN, should be used in VR map

Arguments:

Return:
string
__________________________________________________________________*/
#include "script_component.hpp"
#define ATTRIBUTE_ANCHOR(ENTITY) ((ENTITY get3DENAttribute QUOTE(DOUBLES(PREFIX,Anchor))) select 0)
#define ATTRIBUTE_SNAP(ENTITY) ((ENTITY get3DENAttribute QUOTE(DOUBLES(PREFIX,Snap))) select 0)
#define ATTRIBUTE_VECTORUP(ENTITY) ((ENTITY get3DENAttribute QUOTE(DOUBLES(PREFIX,VectorUp))) select 0)
#define ATTRIBUTE_SIMPLE(ENTITY) ((ENTITY get3DENAttribute "objectIsSimple") select 0)
#define NODE_CHECK(ENTITY) ENTITY isKindOf "Land_HelipadEmpty_F"
#define PRINT_MSG(MSG) titleText [MSG, "PLAIN"]
#define GET_DATA(ENTITY) _composition pushBack [typeof ENTITY, str (getPosATL ENTITY vectorDiff getPosATL _anchor), str (((getDir ENTITY) - (getDir _anchor)) mod 360), ATTRIBUTE_VECTORUP(ENTITY),ATTRIBUTE_SNAP(ENTITY),ATTRIBUTE_SIMPLE(ENTITY)]

private _composition = [];
private _selected = get3DENSelected "object";
private _nodes = [];
private _strength = 0;
private _count = 0;
private _r = 0;
private _anchor = objNull;
private _br = toString [13,10];
private _tab = toString [9];

{
	if (ATTRIBUTE_ANCHOR(_x)) exitWith {
        _anchor = "Land_HelipadEmpty_F" createVehicle [0,0,0];
        _anchor setVectorUp [0,0,1];
        _anchor setPosATL [getPosATL _x select 0,getPosATL _x select 1,0];
	};
} forEach _selected;

if (isNull _anchor) exitWith {
    PRINT_MSG("Cannot export composition while anchor is undefined")
};

{
    if (NODE_CHECK(_x)) then {
        for "_i" from 2 to 50 step 1 do {
            private _near = nearestObjects [_x, [], _i];
			if (count _near > 1) exitWith {
				_nodes pushBack [str (getPosATL _x vectorDiff getPosATL _anchor), str (_i - 1)];
			};
		};
    };
} forEach _selected;

{
	if !(_x isKindOf "Man") then {
        if (NODE_CHECK(_x) && {!ATTRIBUTE_ANCHOR(_x)}) exitWith {};
		GET_DATA(_x);
		_count = _count + 1;
        _r = (round (_x distance2D _anchor)) max _r;
	};
} forEach _selected;

_strength = round (_r + (_count * 0.5));

// format command has a character limit
// compiled entry uses string addition as workaround for long arrays
private _className = format ["DOUBLES(PREFIX,%1%2)",round random 1000,round diag_tickTime];
private _compiledEntry = format ["class %3 {%1%2radius = %4;%1%2strength = %5;%1%2objects = ",_br,_tab,_className,_r,_strength];
_compiledEntry = _compiledEntry + str (str _composition) + format [";%1%2nodes = ", _br,_tab];
_compiledEntry = _compiledEntry + str (str _nodes) + format [";%2%1};", _br,_tab];

private _msg = format ["Exporting composition to clipboard, objects: %1, radius: %2, strength: %3",_count, _r, _strength];
PRINT_MSG(_msg);

copyToClipboard _compiledEntry;

_compiledEntry
