/*
Author:
Nicholas Clark (SENSEI)

Description:
setup fob on server

Arguments:
0: unit to assign to curator <OBJECT>
1: fob position <ARRAY>
2: points available to curator <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

private ["_revealed","_mrkArray","_screens","_hq","_objects","_obj","_time"];
params ["_unit","_pos",["_points",1]];

_pos set [2,0];
_revealed = [];
_mrkArray = [];
_time = time;

// create fob location on all machines
[_pos,{
 	GVAR(location) = createLocation ["NameCity", _this, GVAR(range), GVAR(range)];
 	GVAR(location) setText format ["%1", GVAR(name)];
}] remoteExecCall ["BIS_fnc_call",0,true];

// assign unit and send unit curator UID
// unit does not immediately become owner of curator, it takes a few seconds
if !(isNull _unit) then {
	_unit assignCurator GVAR(curator);
	GVAR(UID) = getPlayerUID _unit;
	(owner _unit) publicVariableClient QGVAR(UID);
};

// setup curator
removeAllCuratorAddons GVAR(curator);
GVAR(curator) addCuratorAddons GVAR(addons);
GVAR(curator) addCuratorPoints _points;
GVAR(curator) setCuratorCoef ["Place", GVAR(placingMultiplier)];
GVAR(curator) setCuratorCoef ["Delete", GVAR(deletingMultiplier)];
GVAR(curator) setCuratorWaypointCost 0;
GVAR(curator) addCuratorEditingArea [0,_pos,GVAR(range)];
GVAR(curator) addCuratorCameraArea [0,_pos,GVAR(range)];
GVAR(curator) setCuratorCameraAreaCeiling 40;
[GVAR(curator),"object",["UnitPos","Rank","Lock"]] call BIS_fnc_setCuratorAttributes;

// setup eventhandlers
if !(isNull _unit) then {
	remoteExecCall [QFUNC(curatorEH), owner _unit, false];
};

// create fob flag
GVAR(flag) = "Flag_NATO_F" createVehicle _pos;
GVAR(flag) setFlagTexture GVAR(flagTexturePath);