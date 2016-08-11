/*
Author:
Nicholas Clark (SENSEI)

Description:
checks if position is safe, function assumes model direction is 0

Arguments:
0: position <ARRAY>
1: model to check <OBJECT,ARRAY,NUMBER>
2: allow water <NUMBER>
3: max gradient <NUMBER>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

private ["_bbr","_p1","_p2","_w","_l","_h","_empty"];
params [
	"_pos",
	["_model",objNull],
	["_water",-1],
	["_gradient",-1]
];

_pos = [_pos select 0,_pos select 1,0.5];

if (_pos isFlatEmpty [-1, -1, _gradient, 10, _water] isEqualTo []) exitWith {false};

if !(_model isEqualTo objNull) exitWith {
	_empty = true;
	_pos = AGLToASL _pos;

	call {
		if (_model isEqualType objNull) exitWith {
			_bbr = boundingBoxReal _model;
			_p1 = _bbr select 0;
			_p2 = _bbr select 1;
			_w = abs ((_p2 select 0) - (_p1 select 0)) * 0.85;
			_l = abs ((_p2 select 1) - (_p1 select 1)) * 0.85;
			_h = abs ((_p2 select 2) - (_p1 select 2)) * 0.85;
		};

		if (_model isEqualType 0) exitWith {
			_w = _model;
			_l = _model;
			_h = _model;

			_model = objNull;
		};

		if (_model isEqualType []) exitWith {
			_w = _model select 0;
			_l = _model select 1;
			_h = _model select 2;

			_model = objNull;
		};
		_model = objNull;
	};

	if (lineIntersects [_pos, _pos vectorAdd [0, 0, _h],_model] ||
		{lineIntersects [_pos, _pos vectorAdd [_w, 0, 0],_model]} ||
		{lineIntersects [_pos, _pos vectorAdd [- _w, 0, 0],_model]} ||
		{lineIntersects [_pos, _pos vectorAdd [0, _l, 0],_model]} ||
		{lineIntersects [_pos, _pos vectorAdd [0, - _l, 0],_model]}) then {
			_empty = false;
	};

	_empty
};

true