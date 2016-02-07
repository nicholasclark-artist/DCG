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

params ["_unit","_pos",["_points",1]];

_pos set [2,0];
_revealed = [];
_mrkArray = [];

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
GVAR(curator) setCuratorCameraAreaCeiling 80;
[GVAR(curator),"object",["UnitPos","Rank","Lock"]] call BIS_fnc_setCuratorAttributes;

// setup eventhandlers
if !(isNull _unit) then {
	remoteExecCall [QFUNC(curatorEH), owner _unit, false];
};

// create fob flag
GVAR(flag) = "Flag_NATO_F" createVehicle _pos;
GVAR(flag) setFlagTexture GVAR(flagTexturePath);

// recon PFH
[{
	params ["_args","_idPFH"];
	_args params ["_revealed","_mrkArray","_flag"];

	if (GVAR(location) isEqualTo locationNull) exitWith { // exit when fob is dismantled
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		{
			deleteMarker _x;
		} forEach _mrkArray;
	};

	if ({typeOf _x in ARRAY_HQ} count (curatorEditableObjects GVAR(curator)) > 0) then {
		{
			if (side _x isEqualTo EGVAR(main,enemySide) && {!(group _x in _revealed)} && {random 1 < 0.5}) exitWith {
				_hour = str (date select 3);
				_min = str (date select 4);
				if (count _min < 2) then {_min = "0"+_min};
				_format = _hour + ":" + _min;
				_mrk = createMarker [format["%1_%2_%3",QUOTE(ADDON),getposATL (leader _x),diag_tickTime],getposATL (leader _x)];
				_mrk setMarkerColor format ["Color%1",side _x];
				_mrk setMarkerType "o_unknown";
				_mrk setMarkerText format["%1",_format];
				_mrk setMarkerSize [0.75,0.75];
				_mrkArray pushBack _mrk;
				_revealed pushBack (group _x);
			};
		} forEach (MARKER_POS nearEntities [["Man","LandVehicle","Ship"], GVAR(rangeRecon)]);
	};
}, GVAR(cooldownRecon) max 60, [_revealed,_mrkArray,_flag]] call CBA_fnc_addPerFrameHandler;