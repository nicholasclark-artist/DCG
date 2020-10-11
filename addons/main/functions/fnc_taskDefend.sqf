/*
Author:
Rommel,SilentSpike,Nicholas Clark (SENSEI)

Description:
set group to defend area. Modified version of CBA_fnc_taskDefend

if buildings in the defended area are spawned after mission start, the group must exist and initialize prior to said buildings. Otherwise, the group's pathing will not take into account the spawned buildings.

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

if !(local _group) exitWith {false};

if (isNull _group) exitWith {
    WARNING("group does not exist");
    false
};

// clear existing waypoints
[_group] call CBA_fnc_clearWaypoints;

// make sure units can move
{
    _x enableAI "PATH";
} forEach units _group;

private _statics = _position nearObjects ["StaticWeapon",_radius];
private _buildings = _position nearObjects ["House",_radius];

// add custom buildings
_buildings append (_position nearObjects ["CBA_buildingPos",_radius]);

// filter out occupied statics
_statics = _statics select {!((locked _x) isEqualTo 2) && {(_x emptyPositions "Gunner") > 0}};

// filter out buildings below the size threshold (and store positions for later use)
private ["_positions","_exit"];

_buildings = _buildings select {
    _positions = _x buildingPos -1;
    _exit = _x buildingExit 0;

    if !(_exit isEqualTo [0,0,0]) then {
        _positions pushBack _exit;
    };

    if (isNil {_x getVariable "CBA_taskDefend_positions"}) then {
        _x setVariable ["CBA_taskDefend_positions",_positions];
    };

    count _positions >= 1
};

// if patrolling is enabled then the leader must be free to lead it
private _units = units _group;
if (_patrol > 0 && {count _units > 1}) then {
    _units deleteAt (_units find (leader _group));
};

private ["_building","_buildingPositions","_pos","_static"];
{
    // 31% chance to occupy nearest free static weapon
    if (PROBABILITY(0.31) && {!(_statics isEqualto [])}) then {
        _static = _statics deleteAt 0;
        _x assignAsGunner _static;
        _x moveInGunner _static;
    } else {
        if (!(_buildings isEqualto []) && {!(PROBABILITY(_patrol))}) then {
            _building = selectRandom _buildings;
            _buildingPositions = _building getVariable ["CBA_taskDefend_positions",[]];

            if !(_buildingPositions isEqualTo []) then {
                _pos = _buildingPositions deleteAt (floor (random (count _buildingPositions)));

                // if building positions are all taken remove from possible buildings
                if (_buildingPositions isEqualTo []) then {
                    _buildings deleteAt (_buildings find _building);
                    _building setVariable ["CBA_taskDefend_positions",nil];
                } else {
                    _building setVariable ["CBA_taskDefend_positions",_buildingPositions];
                };

                [_x,_pos] spawn {
                    params ["_unit","_pos"];

                    _unit setPosATL _pos;

                    doStop _unit;

                    _unit setUnitPos "UP";

                    // spread out network traffic caused by setPos
                    sleep 0.1;

                    if !(leader group _unit isEqualTo _unit) exitwith {};

                    // fall back into formation on contact
                    _unit addEventHandler ["AnimChanged",{
                        params ["_leader"];

                        if ((toUpper behaviour _leader) isEqualTo "COMBAT") then {
                            _leader removeEventHandler ["AnimChanged",_thisEventHandler];

                            _leader doFollow _leader;

                            // release some units to formation
                            {
                                if (PROBABILITY(0.5)) then {
                                    _x doFollow _leader;
                                    TRACE_1("doFollow",_x);
                                };
                            } forEach units group _leader;

                            TRACE_2("AnimChanged",_leader,behaviour _leader);
                        };
                    }];
                };
            };
        };
    };
} forEach _units;

// unassigned (or combat reacted) units will patrol
[_group,_position,_radius max 50,0] call FUNC(taskPatrol);

true