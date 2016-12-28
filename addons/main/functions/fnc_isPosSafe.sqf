/*
Author:
Nicholas Clark (SENSEI)

Description:
checks if position is safe

Arguments:
0: position <ARRAY>
1: check distance <NUMBER>
2: allow water <NUMBER>
3: max gradient <NUMBER>
4: object to ignore in collsion check <OBJECT>
5: object to ignore in collsion check <OBJECT>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

params [
	"_pos",
	["_dist",5,[0]],
	["_water",-1,[0]],
	["_gradient",-1,[0]],
	["_ignore1",objNull,[objNull]],
	["_ignore2",objNull,[objNull]]
];

_pos =+ _pos;
_pos set [2,0.3];

if (_pos isFlatEmpty [-1, -1, _gradient, 30, _water] isEqualTo []) exitWith {false};

private _safe = true;
_pos = AGLtoASL _pos;

if (lineIntersects [_pos, _pos vectorAdd [0, 0, _dist],_ignore1,_ignore2] ||
	{lineIntersects [_pos, _pos vectorAdd [_dist, 0, 0],_ignore1,_ignore2]} ||
	{lineIntersects [_pos, _pos vectorAdd [-_dist, 0, 0],_ignore1,_ignore2]} ||
	{lineIntersects [_pos, _pos vectorAdd [0, _dist, 0],_ignore1,_ignore2]} ||
	{lineIntersects [_pos, _pos vectorAdd [0, -_dist, 0],_ignore1,_ignore2]}) then {
		_safe = false;
};

_safe
