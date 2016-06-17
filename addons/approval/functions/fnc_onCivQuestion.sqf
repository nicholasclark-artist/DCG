/*
Author:
Nicholas Clark (SENSEI)

Description:
question nearby civilian

Arguments:
0: player <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define RANGE EGVAR(main,range)*0.15
#define QVAR QUOTE(DOUBLES(ADDON,questioned))
#define COOLDOWN 300
#define REJECT(CIV) format ["%1 doesn't have any relevant information.",name CIV]

private ["_player","_enemies","_near","_civ","_enemy","_area"];

_player = _this select 0;
_enemies = [];
_near = getposATL player nearEntities ["Man", 5];

{
	if (!(side _x isEqualTo CIVILIAN) || {isPlayer _x}) then {
		_near deleteAt _forEachIndex;
	};
} forEach _near;

if (_near isEqualTo []) exitWith {
	["There are no civilians near you."] remoteExecCall [QEFUNC(main,displayText),_player];
};

if ([getpos _player] call FUNC(getValue) < AV_MAX*0.1) exitWith {
	["The locals don't trust you enough to cooperate."] remoteExecCall [QEFUNC(main,displayText),_player];
};

_civ = selectRandom _near;

if (diag_tickTime < (_civ getVariable [QVAR,COOLDOWN * -1]) + COOLDOWN) exitWith {
	[format ["%1 was questioned recently.",name _civ]] remoteExecCall [QEFUNC(main,displayText),_player];
};

_civ setVariable [QVAR,diag_tickTime,true];

if (random 100 < 85) then {
	_near = _civ nearEntities [["Man","LandVehicle","Ship"], RANGE];
	{
		if !(side _x isEqualTo EGVAR(main,playerSide) && {side _x isEqualTo CIVILIAN}) then {
			_enemies pushBack _x
		};
	} forEach _near;

	if (_enemies isEqualTo []) exitWith {
		[REJECT(_civ)] remoteExecCall [QEFUNC(main,displayText),_player];
	};

	_enemy = selectRandom _enemies;
	_area = nearestLocations [getposATL _enemy, ["NameCityCapital","NameCity","NameVillage"], (((RANGE * 0.5) min 1000) max 500)];

	if (_area isEqualTo []) exitWith {
		[REJECT(_civ)] remoteExecCall [QEFUNC(main,displayText),_player];
	};

	[format ["%1 saw soldiers around %2 not too long ago.",name _civ,text (_area select 0)]] remoteExecCall [QEFUNC(main,displayText),_player];
} else {
	[REJECT(_civ)] remoteExecCall [QEFUNC(main,displayText),_player];
};