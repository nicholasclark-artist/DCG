/*
Author:
Nicholas Clark (SENSEI)

Description:
set ambient animation

Arguments:
0: unit to animate <OBJECT>
1: animation set <STRING>
2: animation interact object <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define ANIMS_STAND1 [""]
#define ANIMS_STAND2 [""]
#define ANIMS_KNEEL [""]

params [
    ["_unit",objNull,[objNull]],
    ["_set","stand1",[""]],
    ["_obj",objNull,[objNull]]
];

private ["_animData"];

// get anim data
switch (toLower _set) do {
    case "stand1": {
        _animData = [[0,0,0],0,ANIMS_STAND1];
    };
    case "stand2": {
        _animData = [[0,0,0],0,ANIMS_STAND2];
    };
    case "kneel": {
        _animData = [[0,0,0],0,ANIMS_KNEEL];
    };
    case "object": {
        _animData = [getModelInfo _obj] call FUNC(getAnimModelData);
    };
    default {};
};

if (isNil "_animData" || {_animData isEqualTo []}) exitWith {
    nil
};

if (isNull _obj) then {
    _obj = _unit;
};

// setup unit
{_unit disableAI _x} forEach ["ANIM","MOVE"];
detach _unit;

// disable collision
if !(_obj isEqualTo _unit) then {
    _obj disableCollisionWith _unit;
    _unit disableCollisionWith _obj;
};

// setup gear
private _weapon = currentWeapon _unit;
_unit removeWeapon currentWeapon _unit;

private _pos = getPosASL _obj;

// game logic used as attach object
private _logic = (createGroup CIVILIAN) createUnit ["Logic",[_pos select 0,_pos select 1,0],[],0,"CAN_COLLIDE"];
(group _logic) deleteGroupWhenEmpty true;

_logic setPosASL _pos;
_logic setDir (getDir _obj + (_animData select 1));

// attach to logic
_unit attachTo [_logic,_animData select 0];
[_unit,selectRandom (_animData select 2),2] call FUNC(setAnim);

// eventhandlers 
private _onKilled = _unit addEventHandler ["Killed",{[_this select 0] call FUNC(removeAmbientAnim)}];

// store vars in unit namespace
_unit setVariable [QGVAR(ambientAnimOnKilled),_onKilled];
_unit setVariable [QGVAR(ambientAnimLogic),_logic];
_unit setVariable [QGVAR(ambientAnimObject),_obj];
_unit setVariable [QGVAR(ambientAnimWeapon),_weapon];

nil