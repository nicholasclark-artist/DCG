/*
Author:
Nicholas Clark (SENSEI)

Description:
fill a sorted convex polygon on given control

Arguments:
0: polygon vertices <ARRAY>
1: polygon color <ARRAY>
2: polygon texture <STRING>
3: draw control <CONTROL>
4: draw ID <STRING>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_polygon",[[0,0,0],[0,0,0],[0,0,0]],[[]]],
    ["_color",[1,0,0,0.5],[[]]],
    ["_texture","#(rgb,1,1,1)color(1,1,1,1)",[""]],
    ["_ctrl",findDisplay 12 displayCtrl 51,[controlNull]],
    ["_idGlobal","",[""]]
];

private _ret = [];
private _tris = [_polygon] call FUNC(polygonTriangulate);

{
    // draw polygon on given control
    private _id = _ctrl ctrlAddEventHandler ["Draw",format ["(_this select 0) drawTriangle [%1,%2,'%3'];",_x,_color,_texture]];

    _ret pushBack _id;
} forEach _tris;

// set global variable reference to id array
if !(_idGlobal isEqualTo "") then {
    private _value = missionNamespace getVariable [_idGlobal,[]];
    _value append _ret;
    missionNamespace setVariable [_idGlobal,_value,false];
};

_ret