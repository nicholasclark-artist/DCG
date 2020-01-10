/*
Author:
Nicholas Clark (SENSEI)

Description:
get bounding box corners or nearest corner

Arguments:
0: bounding box object <OBJECT>
1: position for which nearest corner is returned <ARRAY,OBJECT>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_obj",objNull,[objNull]],
    ["_pos",nil,[[],objNull]]
];

private _bbr = 0 boundingBoxReal _obj;
private _bbx = [_bbr select 0 select 0,_bbr select 1 select 0];
private _bby = [_bbr select 0 select 1,_bbr select 1 select 1];
private _ret = [];

{
    _y = _x;

    {
        _ret pushBack ((_this select 0) modelToWorld [_x,_y,(_bbr select 0 select 2) min (_bbr select 1 select 2)]); 
    } forEach _bbx;
    // reverse x order, so polygon draws correctly ([x1,y1],[x2,y1],[x2,y2],[x1,y2])
    reverse _bbx;
} forEach _bby;

if !(isNil "_pos") then {
    _ret = _ret apply {[_x distance2D _pos,_x]};
    _ret sort true;
    _ret = _ret select 0 select 1;
};

_ret