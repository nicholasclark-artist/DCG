/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Returns the x-coordinate of the intersection of neighbouring parabolas on the beachline.
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params ["_parPtr", "_y"];

//diag_log text format ["_parPtr = %1", _parPtr];
//diag_log text format ["_y = %1", _y];
private _pPtr = [_parPtr, true] call FUNC(treeGetLeafChild);
private _rPtr = [_parPtr, false] call FUNC(treeGetLeafChild);

//diag_log text format ["_pPtr = %1", _pPtr];
//diag_log text format ["_rPtr = %1", _rPtr];

private _p = GET_PTR(_pPtr);
private _r = GET_PTR(_rPtr);

//diag_log text format ["_p = %1", _p];
//diag_log text format ["_r = %1", _r];

private _pSite = _p#PARABOLA_SITE;
private _rSite = _r#PARABOLA_SITE;

//diag_log text format ["_pSite = %1", _pSite];
//diag_log text format ["_rSite = %1", _rSite];

_pSite params ["_pX", "_pY"];
_rSite params ["_rX", "_rY"];

//diag_log text format ["_pX = %1", _pX];
//diag_log text format ["_pY = %1", _pY];
//diag_log text format ["_rX = %1", _rX];
//diag_log text format ["_rY = %1", _rY];

private _dp = 2 * (_pY - _y);
if(_dp == 0) then {_dp = 0.0001; };
private _a1 = 1 / _dp;
private _b1 = -2 * _pX / _dp;
private _c1 = _y + _dp / 4 + _pX * _pX / _dp;

//diag_log text format ["_dp = %1", _dp];
//diag_log text format ["_a1 = %1", _a1];
//diag_log text format ["_b1 = %1", _b1];
//diag_log text format ["_c1 = %1", _c1];

private _dp = 2 * (_rY - _y);
if(_dp == 0) then {_dp = 0.0001; };
private _a2 = 1 / _dp;
private _b2 = -2 * _rX / _dp;
private _c2 = _y + _dp / 4 + _rX * _rX / _dp;

//diag_log text format ["_dp = %1", _dp];
//diag_log text format ["_a2 = %1", _a2];
//diag_log text format ["_b2 = %1", _b2];
//diag_log text format ["_c2 = %1", _c2];

private _a = _a1 - _a2;
private _b = _b1 - _b2;
private _c = _c1 - _c2;

//diag_log text format ["_a = %1", _a];
//diag_log text format ["_b = %1", _b];
//diag_log text format ["_c = %1", _c];

private _disc = _b^2 - 4 * _a * _c;
private _sqrtDisc = sqrt _disc;
private _2a = 2*_a;
if(_2a == 0) then { _2a = 0.0001; };

private _x1 = (-_b + _sqrtDisc) / _2a;
private _x2 = (-_b - _sqrtDisc) / _2a;

//diag_log text format ["_disc = %1", _disc];
//diag_log text format ["_sqrtDisc = %1", _sqrtDisc];
//diag_log text format ["_2a = %1", _2a];
//diag_log text format ["_x1 = %1", _x1];
//diag_log text format ["_x2 = %1", _x2];

private _return = if(_pY < _rY) then { _x1 max _x2 } else { _x1 min _x2 };

_return