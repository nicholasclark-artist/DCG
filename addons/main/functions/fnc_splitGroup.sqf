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

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_oldGrp",grpNull,[grpNull]],
    ["_count",1,[0]],
    ["_code",{},[{}]],
    ["_params",[],[[]]],
    ["_remaining",0,[0]]
];

TRACE_1("",_oldGrp);

private _oldCount = count units _oldGrp;

_count = (ceil _count) max 1;
_remaining = ((ceil _remaining) min _oldCount) max 0;

// move units to temp group first,so old group count is correct at function end
private _tempGrp = createGroup [side _oldGrp,true];
_tempGrp setBehaviourStrong (behaviour leader _oldGrp);
((units _oldGrp) select [0,_oldCount - _remaining]) joinSilent _tempGrp;

// move units to new group until temp group remaining count is reached
[{
    params ["_args","_idPFH"];
    _args params ["_tempGrp","_count","_code","_params","_remaining"];

    // move units to new group
    private _newGrp = createGroup [side _tempGrp,true];
    ((units _tempGrp) select [0,_count]) joinSilent _newGrp;

    // set behaviour and vars
    _newGrp setBehaviourStrong "SAFE";
    _newGrp setVariable [QGVAR(ready),true,false];

    // run code on new group
    _args = [_newGrp];
    _args append _params;
    _args call _code;

    if (count units _tempGrp <= _remaining) exitWith {
        TRACE_2("",_tempGrp,_newGrp);

        [_idPFH] call CBA_fnc_removePerFrameHandler;
        [QEGVAR(cache,enableGroup),_newGrp] call CBA_fnc_serverEvent;
    };
},0.1,[_tempGrp,_count,_code,_params,_remaining]] call CBA_fnc_addPerFrameHandler;

nil
