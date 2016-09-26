/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn sniper

Arguments:
0: center position <ARRAY>
1: number of snipers to spawn <NUMBER>
2: min distance from center to spawn sniper <NUMBER>
3: max distance from center to spawn sniper <NUMBER>
4: side that spawned sniper will belong to <SIDE>
5: disable caching for spawned snipers <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
	"_pos",
	["_count",1,[0]],
	["_min",100,[0]],
	["_max",1000,[0]],
	["_side",GVAR(enemySide)],
	["_uncache",false]
];

private _return = [];
private _sniper = objNull;
private _overwatch = [_pos,_count,_min,_max] call FUNC(findPosOverwatch);

call {
	if (_side isEqualTo EAST) exitWith {
		_sniper = selectRandom GVAR(sniperPoolEast);
	};
	if (_side isEqualTo WEST) exitWith {
		_sniper = selectRandom GVAR(sniperPoolWest);
	};
	_sniper = selectRandom GVAR(sniperPoolInd);
};

{
	private _grp = createGroup _side;
	private _unit = _grp createUnit [_sniper, [0,0,0], [], 0, "NONE"];
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
		private _mrk = createMarker [format["%1_sniper_%2",QUOTE(PREFIX),_unit],getposATL leader _grp];
		_mrk setMarkerType "o_recon";
		_mrk setMarkerColor format ["Color%1",side _unit];
		_mrk setMarkerSize [0.7,0.7];
	};
} forEach _overwatch;

_return