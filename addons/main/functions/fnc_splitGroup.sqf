/*
Author:
Nicholas Clark (SENSEI)

Description:
split group into smaller groups

Arguments:
0: group to split <GROUP>
1: new group unit count <NUMBER>
2: code to run on new group <CODE>
3: code parameters <ARRAY>
4: delay between splitting groups <NUMBER>

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_grp",grpNull,[grpNull]],
    ["_count",1,[0]],
    ["_code",{},[{}]],
    ["_params",[],[[]]],
    ["_delay",0,[0]]
];

_count = _count max 1;

[{
    params ["_args","_idPFH"];
    _args params ["_grp","_count","_code","_params"];

    if (count units _grp < 1) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    _newGrp = createGroup side _grp;
    ((units _grp) select [0,_count]) joinSilent _newGrp;
    _newGrp setBehaviour "SAFE";
    _args = [_newGrp];
    _args append _params;
    _args call _code;
}, _delay, [_grp,_count,_code,_params]] call CBA_fnc_addPerFrameHandler;

nil
