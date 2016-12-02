/*
Author:
Nicholas Clark (SENSEI)

Description:
handle damage for task objects

Arguments:
0: object <OBJECT>
1: code to run on object killed <STRING>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_obj",objNull,[objNull]],
    ["_onKilled","",[""]]
];

if !(local _obj) exitWith {
    WARNING_1("%1 is not local",_obj);
    false
};

_obj addEventHandler ["HandleDamage", format ["
    _ret = 0;
    if ((_this select 4) isKindof ""PipeBombBase"") then {
        _ret = 1;
        call compile %1;
    } else {
        _ret = 0;
    };

    _ret
",str _onKilled]];

true
