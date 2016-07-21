/*
Author:
Nicholas Clark (SENSEI)

Description:
question nearby civilian

Arguments:
0: player <OBJECT>
1: target <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define RANGE EGVAR(main,range)*0.15
#define QVAR QUOTE(DOUBLES(ADDON,questioned))
#define COOLDOWN 300
#define SEND_MSG(MSG,TARGET) [MSG] remoteExecCall [QEFUNC(main,displayText),TARGET]

(_this select 0) params ["_player","_target"];

if (diag_tickTime < (_target getVariable [QVAR,COOLDOWN * -1]) + COOLDOWN) exitWith {
	_text = [
		format ["%1 was questioned recently.",name _target],
		format ["You questioned %1 not too long ago.",name _target],
		format ["%1 already spoke to you.",name _target]
	];
	SEND_MSG(selectRandom _text,_player);
};

_target setVariable [QVAR,diag_tickTime,true];

_text = [
	format ["%1 doesn't have any relevant information.",name _target],
	format ["%1 doesn't know anything.",name _target],
	format ["%1 isn't interested in talking right now.",name _target]
];

if (random 1 < (linearConversion [AV_MIN, AV_MAX, [getpos _player] call EFUNC(approval,getValue), 0, 1, true])) then {
	_enemies = [];
	_near = _target nearEntities [["Man","LandVehicle","Ship"], RANGE];
	{
		if !(side _x isEqualTo EGVAR(main,playerSide) && {side _x isEqualTo CIVILIAN}) then {
			_enemies pushBack _x
		};
	} forEach _near;

	if (_enemies isEqualTo []) exitWith {
		SEND_MSG(selectRandom _text,_player);
	};

	_enemy = selectRandom _enemies;
	_area = nearestLocations [getposATL _enemy, ["NameCityCapital","NameCity","NameVillage"], (((RANGE * 0.5) min 1000) max 500)];

	if (_area isEqualTo []) exitWith {
		SEND_MSG(selectRandom _text,_player);
	};

	_text = [
		format ["%1 saw soldiers around %2 not too long ago.",name _target,text (_area select 0)],
		format ["%1 saw something suspicious around %2.",name _target,text (_area select 0)]
	];
	SEND_MSG(selectRandom _text,_player);
} else {
	SEND_MSG(selectRandom _text,_player);
};