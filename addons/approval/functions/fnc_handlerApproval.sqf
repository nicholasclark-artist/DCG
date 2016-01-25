/*
Author: Nicholas Clark (SENSEI)

Description:
handles approval points

Arguments:

Return:
__________________________________________________________________*/
#include "script_component.hpp"

/*
	situations value is changed
		if _this = object, get obj data and change value
		if _this = number, basic value change
*/
params ["_type"];

// TODO handle if killer is player check outside func
if (_type isEqualTo 0) exitWith {
	private ["_victim","_killer","_value"];

	_victim = _this select 1;
	_killer = _this select 2;
	_value = 0;

	if !(isPlayer _killer) exitWith {};

	if (_victim isKindOf "Man") then {
		// get type of man
		call {
			if (isPlayer _victim) exitWith {
				_value = _value + VAL_PLAYER;
			};
			if (side _victim isEqualTo CIVILIAN) exitWith {
				_value = _value + VAL_CIV;
			};
			_value = _value + VAL_MAN;
		};

		// add a percentage of value based on rank
		call {
			if (rank _victim isEqualTo "PRIVATE") exitWith {
				_value = _value + (_value*0.05);
			};
			if (rank _victim isEqualTo "CORPORAL") exitWith {
				_value = _value + (_value*0.10);
			};
			if (rank _victim isEqualTo "SERGEANT") exitWith {
				_value = _value + (_value*0.15);
			};
			if (rank _victim isEqualTo "LIEUTENANT") exitWith {
				_value = _value + (_value*0.20);
			};
			if (rank _victim isEqualTo "CAPTAIN") exitWith {
				_value = _value + (_value*0.25);
			};
			if (rank _victim isEqualTo "MAJOR") exitWith {
				_value = _value + (_value*0.30);
			};
			if (rank _victim isEqualTo "COLONEL") exitWith {
				_value = _value + (_value*0.35);
			};
		};
	};

	if !(side _victim isEqualTo EGVAR(main,enemySide)) then { // if object not on enemy side, subtract value
		_value = 0 - _value;
	};

	_value call FUNC(addValue);
};

if (_type isEqualTo 1) exitWith { // calculate passive percentages
	_chance = round (50 - (0.1*DCG_approval)) min 50;
	_chance = _chance max 5;

	_chance
};




// TODO move to separate func
if (_type isEqualTo 2) exitWith { // check approval for client
	/*
		Approval Breakdown
			general grade
			civilian approval statement
			fob pirelli assets
	*/
	_requestor = _this select 1;
	_chance = [1] call DCG_fnc_handlerApproval;

	call {
		if (DCG_approval <= 20) exitWith {
			_stance = "The local population does not support you!";
		};
		if (DCG_approval > 21 && {DCG_approval <= 60}) exitWith {
			_stance = "The local population is displeased with you.";
		};
		if (DCG_approval > 60 && {DCG_approval <= 110}) exitWith {
			_stance = "The local population is indifferent to you.";
		};
		if (DCG_approval > 110 && {DCG_approval <= 250}) exitWith {
			_stance = "The local population is pleased with you.";
		};
		if (DCG_approval > 250) exitWith {
			_stance = "The local population supports you!";
		};

		_stance = "The local population is indifferent to you.";
	};

	_hint = "";
	_hint remoteExecCall ["hint",owner _requestor,false];
};