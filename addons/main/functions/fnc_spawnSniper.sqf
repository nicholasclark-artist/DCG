/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn sniper

Arguments:
0: center position <ARRAY>
1: number of snipers to spawn <NUMBER>
2: min distance from center to spawn sniper <NUMBER>
3: max distance from center to spawn sniper <NUMBER>
4: side that spawned sniper will belong to <SIDE>
5: disable caching for spawned snipers <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    "_pos",
    ["_count",1,[0]],
    ["_min",100,[0]],
    ["_max",1000,[0]],
    ["_side",GVAR(enemySide),[sideUnknown]]
];

private _return = [];
private _overwatch = [_pos,_count,_min,_max] call FUNC(findPosOverwatch);

private ["_grp", "_unit", "_mrk"];
{
    _grp = createGroup _side;
    _unit = _grp createUnit [selectRandom ([_side,4] call FUNC(getPool)), DEFAULT_SPAWNPOS, [], 0, "CAN_COLLIDE"];
    [_unit,_x] call FUNC(setPosSafe);
    _unit setUnitPos "DOWN";
    _unit setSkill ["spotDistance",0.97];
    units _grp doWatch _pos;
    _return pushBack _grp;
    _grp setBehaviour "COMBAT";

    _mrk = createMarker [FORMAT_2("%1_sniper_%2",QUOTE(PREFIX),_unit),getposATL leader _grp];
    _mrk setMarkerType "o_recon";
    _mrk setMarkerColor ([_side,true] call BIS_fnc_sideColor);
    _mrk setMarkerSize [0.7,0.7];
    [_mrk] call EFUNC(main,setDebugMarker);
} forEach _overwatch;

_return