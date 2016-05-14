/*
Author:
Nicholas Clark (SENSEI)

Description:
send approval hint to client

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

_player = _this select 0;
_textArray = [];
_value = [getpos _player] call FUNC(getValue);

call {
	if (_value > AV_MAX*0.1 && {_value <= AV_MAX*0.25}) exitWith {
		_textArray = [
			"AV 1 10%",
			"AV 2 10%"
		];
	};
	if (_value > AV_MAX*0.25 && {_value <= AV_MAX*0.5}) exitWith {
		_textArray = [
			"AV 1 25%",
			"AV 2 25%"
		];
	};
	if (_value > AV_MAX*0.5 && {_value <= AV_MAX*0.75}) exitWith {
		_textArray = [
			"AV 1 50%",
			"AV 2 50%"
		];
	};
	if (_value > AV_MAX*0.75 && {_value <= AV_MAX}) exitWith {
		_textArray = [
			"AV 1 75%",
			"AV 2 75%"
		];
	};
	if (_value > AV_MAX) exitWith {
		_textArray = [
			"AV 1 100%",
			"AV 2 100%"
		];
	};
	_textArray = [
		"AV 1 less than 10%",
		"AV 2 less than 10%"
	];
};
_hint = format ["%1", selectRandom _textArray];
[_hint,true] remoteExecCall [QEFUNC(main,displayText),_player,false]
