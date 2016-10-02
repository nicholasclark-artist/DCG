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
#define VAR_VECTORUP QUOTE(DOUBLES(PREFIX,vectorUp))
#define VAR_ANCHOR QUOTE(DOUBLES(PREFIX,anchor))
#define VAR_SNAP QUOTE(DOUBLES(PREFIX,snap))
#define VAR_NODE QUOTE(DOUBLES(PREFIX,node))
#define GET_DATA(OBJ) _objects pushBack [str (typeof OBJ), str (str (_anchor worldToModel (getPos OBJ))), str (str (((getDir OBJ) - (getDir _anchor)) mod 360)), OBJ getVariable [VAR_VECTORUP,0],OBJ getVariable [VAR_SNAP,1]]
/*
	this setVariable ["dcg_vectorUp",1];
	this setVariable ["dcg_anchor",1];
	this setVariable ["dcg_snap",0];
	this setVariable ["dcg_node",1];

	call dcg_main_fnc_exportBase;
*/

private ["_objects","_nodes","_count","_r","_anchor","_mObjects","_br","_tab","_strength","_className","_compiledEntry"];

_objects = [];
_nodes = [];
_count = 0;
_r = 0;
_anchor = objNull;
_mObjects = allMissionObjects "All";
_br = toString [13,10];
_tab = toString [9];

{
	if ((_x getVariable [VAR_ANCHOR,0]) isEqualTo 1) exitWith {
		_anchor = _x;
		_anchor setVectorUp [0,0,1];
	};
} forEach _mObjects;

if (isNull _anchor) exitWith {
	WARNING("Cannot export object data because anchor is undefined.");
	copyToClipboard "Cannot export object data because anchor is undefined."
};

{
	if ((_x getVariable [VAR_NODE,0]) isEqualTo 1) then {
		for "_i" from 0 to 100 step 2 do {
			if (((getPos _x) isFlatEmpty [_i, -1, -1, -1, -1, false, _x]) isEqualTo []) exitWith {
				_nodes pushBack [str (str (_anchor worldToModel (getPos _x))),str (str _i)];
			};
		};
		_mObjects deleteAt _forEachIndex;
	};
} forEach _mObjects;

{
	if (!(_x isKindOf "Man") && {getNumber (configfile >> "CfgVehicles" >> typeOf _x >> "side") != 7} && {getText (configfile >> "CfgVehicles" >> typeOf _x >> "displayName") != ""}) then {
		GET_DATA(_x);
		_count = _count + 1;
		_r = (round (_x distance2D _anchor)) max _r;
	};
} forEach _mObjects;

_strength = round (_r + (_count * 0.5));

// format command has a character limit
// compiled entry uses string addition as workaround for long arrays
_className = format ["TRIPLES(PREFIX,base,%1_%2%3%4)",_count,_r,_strength,round diag_tickTime];
_compiledEntry = format ["class %3 {%1%2radius = %4;%1%2strength = %5;%1%2objects = ",_br,_tab,_className,_r,_strength];
_compiledEntry = _compiledEntry + str (str _objects) + format [";%1%2nodes = ", _br,_tab];
_compiledEntry = _compiledEntry + str (str _nodes) + format [";%2%1};", _br,_tab];

copyToClipboard _compiledEntry;

_compiledEntry