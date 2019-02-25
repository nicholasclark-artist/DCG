/*
Author:
Nicholas Clark (SENSEI)

Description:
check for bounding box intersection between two objects

Arguments:
0: object or array containing _obj1 and position to check (array required if _obj1 is not at desired position) <OBJECT, ARRAY>
1: object to check against <OBJECT>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_obj1",objNull,[objNull,[]]],
    ["_obj2",objNull,[objNull]]
];

private _bb2 = boundingBoxReal _obj2;

private _width = (abs (((_bb2 select 1) select 0) - ((_bb2 select 0) select 0))) * 0.5;
private _length = (abs (((_bb2 select 1) select 1) - ((_bb2 select 0) select 1))) * 0.5;

private ["_pos"];

// assume object 1 is at desired position if array is not provided
if (_obj1 isEqualType objNull) then {
    _pos = getPosATL _obj1;
} else {
    _pos = _obj1 select 1;
    _obj1 = _obj1 select 0;
};

// exit if center is not safe
if (_pos inArea [_obj2,_width,_length,getDir _obj2,true,-1]) exitWith {true};

private _bb1 = boundingBoxReal _obj1;

private _getBoundingBox = {
    _bbr = _this select 1;
    _bbx = [_bbr select 0 select 0, _bbr select 1 select 0];
    _bby = [_bbr select 0 select 1, _bbr select 1 select 1];

    _arr = [];

    {
        _y = _x;

        {
            _arr pushBack ((_this select 0) modelToWorld [_x,_y,(_bbr select 0 select 2) min (_bbr select 1 select 2)]); 
        } forEach _bbx;
        // reverse x order, so polygon draws correctly ([x1,y1], [x2,y1], [x2,y2], [x1,y2])
        reverse _bbx;
    } forEach _bby;

    _arr
};

_bb1 = [_obj1,_bb1] call _getBoundingBox;
_bb2 = [_obj2,_bb2] call _getBoundingBox;

if (_this select 0 isEqualType []) then {
    private ["_offset"];
    {
        _offset = _x vectorDiff (getPosATL _obj1);
        _bb1 set [_forEachIndex,_pos vectorAdd _offset];
    } forEach _bb1;
};

(_bb1 findIf {_x inPolygon _bb2} >= 0) || {_bb2 findIf {_x inPolygon _bb1} >= 0}