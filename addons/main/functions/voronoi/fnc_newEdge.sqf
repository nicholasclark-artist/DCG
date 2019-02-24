/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Returns a new edge between _leftSite and _rightSite starting at _start.
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params [
    "_start", //Starting point
    "_leftSite", //Site on the life
    "_rightSite" //Site on the right
];

_start params ["_startX", "_startY"];
_leftSite params ["_leftX", "_leftY"];
_rightSite params ["_rightX", "_rightY"];

private _dX = _rightX - _leftX;
private _dY = _leftY - _rightY;
if(_dY == 0) then {_dY = 0.0001;};

private _f = _dX / _dY;
private _g = _startY - _f * _startX;

private _direction = [_rightY - _leftY, -(_rightX - _leftX)];

[_start, nil, _leftSite, _rightSite, PTR_NULL, _f, _g, _direction]