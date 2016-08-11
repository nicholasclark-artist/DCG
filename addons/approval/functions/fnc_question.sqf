/*
Author:
Nicholas Clark (SENSEI)

Description:
question nearby unit

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define RANGE EGVAR(main,range)*0.18
#define QVAR QUOTE(DOUBLES(ADDON,questioned))
#define COOLDOWN 300
#define SEND_MSG(MSG) [MSG] call EFUNC(main,displayText)

private ["_near","_unit","_text","_enemies","_enemy","_area"];

_near = player nearEntities [["Man"], 5];
_near = _near select {!isPlayer _x};

if (_near isEqualTo []) exitWith {
	_text = [
		format ["There's no one around to question."]
	];
	SEND_MSG(selectRandom _text);
};

_unit = _near select 0;

if (diag_tickTime < (_unit getVariable [QVAR,COOLDOWN * -1]) + COOLDOWN) exitWith {
	_text = [
		format ["%1 was questioned recently.",name _unit],
		format ["You questioned %1 not too long ago.",name _unit],
		format ["%1 already spoke to you.",name _unit]
	];
	SEND_MSG(selectRandom _text);
};

_unit setVariable [QVAR,diag_tickTime,true];

_text = [
	format ["%1 doesn't have any relevant information.",name _unit],
	format ["%1 doesn't know anything.",name _unit],
	format ["%1 isn't interested in talking right now.",name _unit]
];

if (random 1 < (linearConversion [AV_MIN, AV_MAX, [getpos player] call FUNC(getValue), 0, 1, true])) then {
	_enemies = [];
	_near = _unit nearEntities [["Man","LandVehicle","Ship"], RANGE];
	{
		if !(side _x isEqualTo EGVAR(main,playerSide) && {side _x isEqualTo CIVILIAN}) then {
			_enemies pushBack _x
		};
	} forEach _near;

	if (_enemies isEqualTo []) exitWith {
		SEND_MSG(selectRandom _text);
	};

	_enemy = selectRandom _enemies;
	_area = nearestLocations [getposATL _enemy, ["NameCityCapital","NameCity","NameVillage"], ((RANGE min 1000) max 500)];

	if (_area isEqualTo []) exitWith {
		SEND_MSG(selectRandom _text);
	};

	_text = [
		format ["%1 saw soldiers around %2 not too long ago.",name _unit,text (_area select 0)],
		format ["%1 saw something suspicious around %2.",name _unit,text (_area select 0)]
	];
	SEND_MSG(selectRandom _text);
} else {
	SEND_MSG(selectRandom _text);
};