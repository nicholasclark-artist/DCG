/*
Author:
Nicholas Clark (SENSEI)

Description:
export object data from 3DEN, should be used in VR map to cut down on unwanted data

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define VAR_VECTORUP QUOTE(DOUBLES(PREFIX,vectorUp))
#define VAR_ANCHOR QUOTE(DOUBLES(PREFIX,anchor))
#define VAR_SNAP QUOTE(DOUBLES(PREFIX,snap))
#define GET_DATA(OBJ) _data pushBack [typeof OBJ, str (_anchor worldToModel (getPos OBJ)), str (getDir OBJ), OBJ getVariable [VAR_VECTORUP,0],OBJ getVariable [VAR_SNAP,1]]

private ["_data","_anchor","_objects"];

_data = [];
_anchor = objNull;
_objects = allMissionObjects "All";

// get anchor object
{
	if (isClass (configfile >> "CfgVehicles" >> typeOf _x) && {(_x getVariable [VAR_ANCHOR,0]) isEqualTo 1}) exitWith {
		_anchor = _x;
		_anchor setVectorUp [0,0,1];
		GET_DATA(_anchor);
	};
} forEach _objects;

if (isNull _anchor) exitWith {
	LOG_DEBUG("Cannot export object data because anchor is undefined.");
	copyToClipboard "Cannot export object data because anchor is undefined."
};

// get all object data, excluding logics
// data: [classname, model position relative to anchor, direction, vectorUp variable]
{
	if (isClass (configfile >> "CfgVehicles" >> typeOf _x) && {!(_x isKindOf "Man")} && {getNumber (configfile >> "CfgVehicles" >> typeOf _x >> "side") != 7}) then {
		GET_DATA(_x);
	};
} forEach (_objects - [_anchor]);

copyToClipboard str _data;

// this setVariable ["dcg_vectorUp",1];
// this setVariable ["dcg_anchor",1];