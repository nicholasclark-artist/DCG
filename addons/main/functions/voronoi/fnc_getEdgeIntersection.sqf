/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Returns the intersection point of 2 half-edges.
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params ["_aPtr", "_bPtr", "_vertices"];

//diag_log text format ["_a = %1", _a];
//diag_log text format ["_b = %1", _b];

private _a = GET_PTR(_aPtr);
private _b = GET_PTR(_bPtr);

private _aF = _a#EDGE_LINE_F;
private _aG = _a#EDGE_LINE_G;
private _bF = _b#EDGE_LINE_F;
private _bG = _b#EDGE_LINE_G;

//diag_log text format ["_aF = %1", _aF];
//diag_log text format ["_aG = %1", _aG];
//diag_log text format ["_bF = %1", _bF];
//diag_log text format ["_bG = %1", _bG];

private _x = (_bG - _aG) / (_aF - _bF);
private _y = _aF * _x + _aG;

//diag_log text format ["_x = %1", _x];
//diag_log text format ["_y = %1", _y];

(_a#EDGE_DIRECTION) params ["_aDirX", "_aDirY"];
(_b#EDGE_DIRECTION) params ["_bDirX", "_bDirY"];

if(_aDirX == 0) then { _aDirX = 0.0001; };
if(_aDirY == 0) then { _aDirY = 0.0001; };

if(_bDirX == 0) then { _bDirX = 0.0001; };
if(_bDirY == 0) then { _bDirY = 0.0001; };

//diag_log text format ["_aDirX = %1", _aDirX];
//diag_log text format ["_aDirY = %1", _aDirY];
//diag_log text format ["_bDirX = %1", _bDirX];
//diag_log text format ["_bDirY = %1", _bDirY];

(_a#EDGE_START) params [ "_aX", "_aY" ];
(_b#EDGE_START) params [ "_bX", "_bY" ];

//diag_log text format ["_aX = %1", _aX];
//diag_log text format ["_aY = %1", _aY];
//diag_log text format ["_bX = %1", _bX];
//diag_log text format ["_bY = %1", _bY];

//diag_log text "(_x - _aX)/_aDirX < 0 = ";
if((_x - _aX)/_aDirX < 0) exitWith {
    //diag_log text "true";
    POINT_NULL
};
//diag_log text "false";

//diag_log text "(_y - _aY)/_aDirY < 0 =";
if((_y - _aY)/_aDirY < 0) exitWith {
    //diag_log text "true";
    POINT_NULL
};
//diag_log text "false";

//diag_log text "(_x - _bX)/_bDirX < 0 =";
if((_x - _bX)/_bDirX < 0) exitWith {
    //diag_log text "true";
    POINT_NULL
};
//diag_log text "false";

//diag_log text "(_y - _bY)/_bDirY < 0 =";
if((_y - _bY)/_bDirY < 0) exitWith {
    //diag_log text "true";
    POINT_NULL
};
//diag_log text "false";

private _p = [_x, _y];
_vertices pushBack _p;
#ifdef DO_DEBUG
diag_log text format ["Returned edge intersection = %1", _p];
#endif
_p