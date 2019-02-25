/*
Author:
Nicholas Clark (SENSEI)

Description:
finds safe position (positionASL)

Arguments:
0: center position <ARRAY>
1: min distance from center <NUMBER>
2: max distance from center <NUMBER>
3: search radius, minimum distance from objects or object used to calculate search radius <NUMBER, OBJECT>
4: allow water <NUMBER>
5: max gradient <NUMBER>
6: direction min and max <ARRAY>
6: default position <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define ITERATIONS 1000

params [
    ["_center",[],[[],objNull]],
    ["_min",0,[0]],
    ["_max",50,[0]],
    ["_check",0,[0,objNull]],
    ["_water",-1,[0]],
    ["_gradient",-1,[0]],
    ["_dir",[0,360],[[]]],
    ["_default",[],[[]]]
];

scopeName "main";

for "_i" from 1 to ITERATIONS do {
    _center getPos [floor (random ((_max - _min) + 1)) + _min, floor (random (((_dir select 1) - (_dir select 0)) + 1)) + (_dir select 0)] call {
        if !([_this,_check,_water,_gradient] call FUNC(isPosSafe)) exitWith {};   
        _this set [2,ASLZ(_this)];
        _this select [0,3] breakOut "main";
    };
};

WARNING("falling back to default position");

(_water > 0) call {
    if !(_default isEqualTo []) exitWith {_default};
    
    private _pos = getArray (configFile >> "CfgWorlds" >> worldName >> "Armory" >> ["positionStart", "positionStartWater"] select _this);

    if !(_pos isEqualTo []) exitWith {
        _pos set [2,ASLZ(_pos)];

        _pos
    };

    _pos = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");

    if !(_pos isEqualTo []) exitWith {
        _pos set [2,ASLZ(_pos)];
        
        _pos
    };

    GVAR(center)
}