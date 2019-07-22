/*
Author:
Nicholas Clark (SENSEI)

Description:
fill a sorted polygon on given control

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
    ["_polygon",[],[[]]],
    ["_color",[1,0,0,0.5],[[]]],
    ["_texture","#(rgb,1,1,1)color(1,1,1,1)",[""]],
    ["_ctrl",findDisplay 12 displayCtrl 51,[controlNull]],
    ["_idGlobal","",[""]]
];

private _ret = [];

// for "_i" from 0 to (count _polygon) - 3 do {
for "_i" from 0 to (count _polygon) - 1 do {
    // get triangles
    private _vertices = _polygon select [_i + 1,2];
    reverse _vertices;
    _vertices pushBack (_polygon select 0);
    reverse _vertices;

    // draw polygon on given control
    if (count _vertices isEqualTo 3) then {
        private _id = _ctrl ctrlAddEventHandler ["Draw",format ["(_this select 0) drawTriangle [%1,%2,'%3'];",_vertices,_color,_texture]];

        _ret pushBack _id;
    };
};

// set global variable reference to id array
if !(_idGlobal isEqualTo "") then {
    private _value = missionNamespace getVariable [_idGlobal,[]];
    _value append _ret;
    missionNamespace setVariable [_idGlobal,_value,false];
};

_ret