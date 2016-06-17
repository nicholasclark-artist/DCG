/*
Author:
Nicholas Clark (SENSEI)

Description:
export object data from 3DEN, should be used in VR map to cut down on unwanted data

Arguments:

Return:
string
__________________________________________________________________*/
#include "script_component.hpp"
#define VAR_VECTORUP QUOTE(DOUBLES(PREFIX,vectorUp))
#define VAR_ANCHOR QUOTE(DOUBLES(PREFIX,anchor))
#define VAR_SNAP QUOTE(DOUBLES(PREFIX,snap))
#define GET_DATA(OBJ) _objects pushBack [str(typeof OBJ), _anchor worldToModel (ASLtoAGL(getPosWorld OBJ)), ((getDir OBJ) - (getDir _anchor)) mod 360, OBJ getVariable [VAR_VECTORUP,0],OBJ getVariable [VAR_SNAP,1]]
/*
	this setVariable ["dcg_vectorUp",1];
	this setVariable ["dcg_anchor",1];
	this setVariable ["dcg_snap",0];

	call dcg_main_fnc_exportObjects;
*/

private ["_objects","_rAnchor","_anchor","_mObjects","_br","_tab","_r","_strength","_format","_compiledEntry"];
_objects = [];
_rAnchor = 0;
_anchor = objNull;
_mObjects = allMissionObjects "All";
_br = toString [13,10];
_tab = toString [9];

{
	if (isClass (configfile >> "CfgVehicles" >> typeOf _x) && {(_x getVariable [VAR_ANCHOR,0]) isEqualTo 1}) exitWith {
		_anchor = _x;
		_anchor setVectorUp [0,0,1];
	};
} forEach _mObjects;

if (isNull _anchor) exitWith {
	LOG_DEBUG("Cannot export object data because anchor is undefined.");
	copyToClipboard "Cannot export object data because anchor is undefined."
};

for "_i" from 0 to 500 step 1 do {
	_rAnchor = _i;
	if ((getPos _anchor isFlatEmpty  [_rAnchor, -1, -1, -1, -1, false, _anchor]) isEqualTo []) exitWith {};
};

{
	if (isClass (configfile >> "CfgVehicles" >> typeOf _x) && {!(_x isKindOf "Man")} && {getNumber (configfile >> "CfgVehicles" >> typeOf _x >> "side") != 7}) then {
		GET_DATA(_x);
	};
} forEach (_mObjects - [_anchor]);

_mObjects = nearestObjects [getPos _anchor, ["ALL"], 1000];
_mObjects = _mObjects select {!(_x isKindOf "Man")};
_r = round ((_mObjects select (count _mObjects - 1)) distance2D (getPos _anchor));
_strength = round (_r + (count _mObjects * 0.5));

// format command has a character limit
// compiled entry uses string addition as workaround so object array is not shortened
_name = format ["%1_base_%2_%3_%4",QUOTE(PREFIX),_r,count _mObjects,_strength];
_format = "class %3 {%1%2radius = %4;%1%2radiusAnchor = %5;%1%2strength = %6;%1%2objects = ";
_compiledEntry = format [_format,_br,_tab,_name,_r,_rAnchor,_strength];
_compiledEntry = _compiledEntry + str (str _objects) + format [";%2%1};", _br,_tab];

copyToClipboard _compiledEntry;

_compiledEntry