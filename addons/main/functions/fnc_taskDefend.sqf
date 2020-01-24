/*
Author:
Rommel,SilentSpike,Nicholas Clark (SENSEI)

Description:
set group to defend area. Modified version of CBA_fnc_taskDefend

Arguments:
0: group <GROUP>
1: center position <ARRAY>
2: distance from center position <NUMBER>
3: chance for unit to patrol <NUMBER>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_group",grpNull,[grpNull]],
    ["_position",DEFAULT_POS,[[]]],
    ["_radius",100,[0]],
    ["_patrol",0.1,[0]]
];

if !(local _group) exitWith {};

// clear existing waypoints
[_group] call CBA_fnc_clearWaypoints;

// make sure units can move
{
    _x enableAI "PATH";
} forEach units _group;

private _statics = _position nearObjects ["StaticWeapon",_radius];
private _buildings = _position nearObjects ["House",_radius];

// Filter out occupied statics
_statics = _statics select {locked _x != 2 && {(_x emptyPositions "Gunner") > 0}};

// Filter out buildings below the size threshold (and store positions for later use)
_buildings = _buildings select {
    private _positions = [_x] call CBA_fnc_buildingPositions;

    if (isNil {_x getVariable "CBA_taskDefend_positions"}) then {
        _x setVariable ["CBA_taskDefend_positions",_positions];
    };

    count _positions >= 1
};

// If patrolling is enabled then the leader must be free to lead it
private _units = units _group;
if (_patrol > 0 && {count _units > 1}) then {
    _units deleteAt (_units find (leader _group));
};

{
    // 31% chance to occupy nearest free static weapon
    if ((random 1 < 0.31) && { !(_statics isEqualto []) }) then {
        _x assignAsGunner (_statics deleteAt 0);
        [_x] orderGetIn true;
    } else {
        // Respect chance to patrol, or force if no building positions left
        if !((_buildings isEqualto []) || { (random 1 < _patrol) }) then {
            private _building = selectRandom _buildings;
            private _array = _building getVariable ["CBA_taskDefend_positions",[]];

            if !(_array isEqualTo []) then {
                private _pos = _array deleteAt (floor (random (count _array)));

                // If building positions are all taken remove from possible buildings
                if (_array isEqualTo []) then {
                    _buildings deleteAt (_buildings find _building);
                    _building setVariable ["CBA_taskDefend_positions",nil];
                } else {
                    _building setVariable ["CBA_taskDefend_positions",_array];
                };

                // Wait until AI is in position then force them to stay
                [_x,_pos,_hold] spawn {
                    params ["_unit","_pos","_hold"];
                    if (surfaceIsWater _pos) exitwith {};

                    _unit doMove _pos;

                    waituntil {unitReady _unit};

                    doStop _unit;

                    // This command causes AI to repeatedly attempt to crouch when engaged
                    // If ever fixed by BI then consider uncommenting
                    // _unit setUnitPos "UP";
                };
            };
        };
    };
} forEach _units;

// fall back into formation on contact
[{
    params ["_args","_idPFH"];
    _args params ["_group"];

    if (isNull _group || {behaviour leader _group isEqualTo "COMBAT"}) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        units _group doFollow leader _group;
    };

},5,[_group]] call CBA_fnc_addPerFrameHandler;

// Unassigned (or combat reacted) units will patrol
[_group,_position,_radius,0,"if (0.15 > random 1) then {this spawn CBA_fnc_searchNearby}"] call FUNC(taskPatrol);