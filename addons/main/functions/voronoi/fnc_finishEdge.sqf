/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Recursively finish of remaining edges in the beachline tree.
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params ["_nPtr", "_width", "_height", "_vertices"];
private _n = GET_PTR(_nPtr);
if(_n#PARABOLA_IS_LEAF) exitWith {
    SET_PTR(_nPtr,PTR_NULL);
};

private _nEdge = GET_PTR(_n#PARABOLA_EDGE);
private _nDir = _nEdge#EDGE_DIRECTION;

private _mx = if(_nDir#POINT_X > 0) then {
    _width max (_nEdge#EDGE_START#POINT_X + 10) 
} else {
    0 min (_nEdge#EDGE_START#POINT_X - 10) 
};

private _eF = _nEdge#EDGE_LINE_F;
private _eG = _nEdge#EDGE_LINE_G;

private _my = _mx * _eF + _eG;

private _end = if(_my < 0 || _my > _height) then {
    _my = if(_nDir#POINT_Y > 0) then {
        _height max (_nEdge#EDGE_START#POINT_Y + 10) 
    } else {
        0 min (_nEdge#EDGE_START#POINT_Y - 10) 
    };

    [(_my-_eG)/_eF, _my]
} else {
    [_mx, _my]
};

_nEdge set [EDGE_END, _end];
_vertices pushBack _end;

private _leftChildPtr = _n#PARABOLA_LEFT;
private _rightChildPtr = _n#PARABOLA_RIGHT;

#ifdef DO_DEBUG
diag_log text format ["_leftChildPtr = %1", _leftChildPtr];
diag_log text format ["_rightChildPtr = %1", _rightChildPtr];
#endif

[_leftChildPtr, _width, _height, _vertices] call FUNC(finishEdge);
[_rightChildPtr, _width, _height, _vertices] call FUNC(finishEdge);
DEL_PTR(_nPtr);