/*
Author:
Nicholas Clark (SENSEI)

Description:
fill a sorted convex polygon on given control

Arguments:
0: polygon vertices <ARRAY>
1: polygon color <ARRAY>
2: polygon texture <STRING>
3: outline polygon <BOOL>
4: draw control <CONTROL>
5: draw ID <STRING>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_polygon",DEFAULT_POLYGON,[[]]],
    ["_color",[1,0,0,0.5],[[]]],
    ["_texture","#(rgb,1,1,1)color(1,1,1,1)",[""]],
    ["_outline",false,[false]],
    ["_ctrl",findDisplay 12 displayCtrl 51,[controlNull]],
    ["_idGlobal","",[""]]
];

private _id = 0;
private _ret = [];
private _tris = [_polygon] call FUNC(polygonTriangulate);

{
    // draw polygon on given control
    _id = _ctrl ctrlAddEventHandler ["Draw",format ["(_this select 0) drawTriangle [%1,%2,'%3'];",_x,_color,_texture]];

    _ret pushBack _id;
} forEach _tris;

// outline polygon
if (_outline) then {
    _id = _ctrl ctrlAddEventHandler ["Draw",format ["(_this select 0) drawPolygon [%1,%2];",_polygon,_color]];
    _ret pushBack _id;
};

// set global variable reference to return value
if !(_idGlobal isEqualTo "") then {
    private _value = missionNamespace getVariable [_idGlobal,[]];
    _value append _ret;
    missionNamespace setVariable [_idGlobal,_value,false];
};

_ret