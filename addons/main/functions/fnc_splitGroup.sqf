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
4: number of units to keep in old group <NUMBER>
5: delay between splitting groups <NUMBER>

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_oldGrp",grpNull,[grpNull]],
    ["_count",1,[0]],
    ["_code",{},[{}]],
    ["_params",[],[[]]],
    ["_remaining",0,[0]],
    ["_delay",0,[0]]
];

private _oldCount = count units _oldGrp;

_count = (ceil _count) max 1;
_remaining = ((ceil _remaining) min _oldCount) max 0;

// move units to temp group first, so old group count is correct at function end
private _tempGrp = createGroup side _oldGrp;
((units _oldGrp) select [0,_oldCount - _remaining]) joinSilent _tempGrp;

[{
    params ["_args","_idPFH"];
    _args params ["_tempGrp","_count","_code","_params","_remaining"];

    _newGrp = createGroup side _tempGrp;
    ((units _tempGrp) select [0,_count]) joinSilent _newGrp;
    _newGrp setBehaviour "SAFE";
    _args = [_newGrp];
    _args append _params;
    _args call _code;

    if (count units _tempGrp <= _remaining) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };
}, _delay, [_tempGrp,_count,_code,_params,_remaining]] call CBA_fnc_addPerFrameHandler;

nil
