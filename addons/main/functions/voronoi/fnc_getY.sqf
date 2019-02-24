/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Returns f(x) for a given x-value of the parabola defined by _point and _dirY
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params ["_point", "_x", "_dirY"];

_point params ["_pointX", "_pointY"];

private _dp = 2 * (_pointY - _dirY);
private _a1 = 1 / _dp;
private _b1 = -2 * _pointX / _dp;
private _c1 = _dirY + _dp / 4 + _pointX * _pointX / _dp;

(_a1 * _x*_x + _b1*_x + _c1)