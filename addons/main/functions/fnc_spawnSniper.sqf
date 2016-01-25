/*
Author: Nicholas Clark (SENSEI)

Description:
spawn sniper

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_pos","_count","_min","_max","_side","_uncache","_return","_sniper","_overwatch","_grp","_unit","_mrk"];

_pos = param [0];
_count = param [1,1,[0]];
_min = param [2,100,[0]];
_max = param [3,1100,[0]];
_side = param [4,GVAR(enemySide)];
_uncache = param [5,false];
_return = [];

call {
	if (_side isEqualTo EAST) exitWith {
		_sniper = (GVAR(sniperPoolEast) select floor (random (count GVAR(sniperPoolEast))));
	};
	if (_side isEqualTo WEST) exitWith {
		_sniper = (GVAR(sniperPoolWest) select floor (random (count GVAR(sniperPoolWest))));
	};
	_sniper = (GVAR(sniperPoolInd) select floor (random (count GVAR(sniperPoolInd))));
};

_overwatch = [_pos,_count,_min,_max] call FUNC(findOverwatchPos);

{
	_grp = createGroup _side;
	_unit = _grp createUnit [_sniper, [0,0,0], [], 0, "NONE"];
	_unit setPosASL _x;
	_unit setUnitPos "DOWN";
	_unit setskill ["spotDistance",0.97];
	units _grp doWatch _pos;
	_return pushBack _grp;
	_grp setBehaviour "COMBAT";
	if (_uncache) then {
		CACHE_DISABLE(_grp,true);
	};
	if(CHECK_DEBUG) then {
		_mrk = createMarker [format["%1_sniper_%2",QUOTE(PREFIX),_unit],getposATL leader _grp];
		_mrk setMarkerType "o_recon";
		_mrk setMarkerColor format ["Color%1",side _unit];
		_mrk setMarkerSize [0.7,0.7];
	};
} forEach _overwatch;

_return