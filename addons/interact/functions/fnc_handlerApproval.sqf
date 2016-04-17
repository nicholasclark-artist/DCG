/*
Author:
Nicholas Clark (SENSEI)

Description:
handles approval

Arguments:
0: unit or number used to base value change on <OBJECT, NUMBER>
1: object that killed unit <OBJECT>
2: to add or subtract value <BOOL>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if ((_this select 0) isEqualType objNull) exitWith {
	params ["_unit",["_killer",objNull],["_subtract",true]];
	_value = 0;

	// get base value
	call {
		if (side _unit isEqualTo EGVAR(main,playerSide)) exitWith {
			_value = _value + VAL_FRIENDLY;
		};
		if (side _unit isEqualTo CIVILIAN && {isPlayer _killer}) exitWith { // TODO make sure isPlayer objNull returns false
			_value = _value + VAL_CIV;
		};
		if (side _unit isEqualTo EGVAR(main,enemySide)) exitWith {
			_value = _value + VAL_ENEMY;
		};
	};

	// add a percentage of value based on rank
	if !(side _unit isEqualTo CIVILIAN) then {
		call {
			if (rank _unit isEqualTo "PRIVATE") exitWith {
				_value = _value + (_value*0.05);
			};
			if (rank _unit isEqualTo "CORPORAL") exitWith {
				_value = _value + (_value*0.10);
			};
			if (rank _unit isEqualTo "SERGEANT") exitWith {
				_value = _value + (_value*0.15);
			};
			if (rank _unit isEqualTo "LIEUTENANT") exitWith {
				_value = _value + (_value*0.20);
			};
			if (rank _unit isEqualTo "CAPTAIN") exitWith {
				_value = _value + (_value*0.25);
			};
			if (rank _unit isEqualTo "MAJOR") exitWith {
				_value = _value + (_value*0.30);
			};
			if (rank _unit isEqualTo "COLONEL") exitWith {
				_value = _value + (_value*0.35);
			};
		};
	};

	if (_subtract) then {
		_value = 0 - _value;
	};

	[_value] call FUNC(addValue);
};

if ((_this select 0) isEqualType 0) exitWith {
	[_this select 0] call FUNC(addValue);
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