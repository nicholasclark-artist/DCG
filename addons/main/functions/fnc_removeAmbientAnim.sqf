/*
Author:
Nicholas Clark (SENSEI)

Description:
remove ambient animation

Arguments:
0: unit <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_unit",objNull,[objNull]]
];

// @todo equip stored gear 

_logic = _unit getVariable [QGVAR(ambientAnimLogic),objNull];
_obj = _unit getVariable [QGVAR(ambientAnimObject),objNull];
_onKilled = _unit getVariable [QGVAR(ambientAnimOnKilled),-1];

deleteVehicle _logic;
detach _unit;

if !(_onKilled isEqualTo -1) then {
    _unit removeEventHandler ["Killed",_onKilled];
    _unit setVariable [QGVAR(ambientAnimOnKilled),nil];
};

if !(_obj isEqualTo _unit) then {
    _obj enableCollisionWith _unit;
    _unit enableCollisionWith _obj;
};

if (alive _unit) then {
    [_unit,"",2] call FUNC(setAnim);
    {_unit enableAI _x} forEach ["ANIM","MOVE"];
    _unit setVehiclePosition [_unit,[],0,"NONE"];
};

_unit setVariable [QGVAR(ambientAnimLogic),nil];
_unit setVariable [QGVAR(ambientAnimObject),nil];
_unit setVariable [QGVAR(ambientAnimWeapon),nil];

nil