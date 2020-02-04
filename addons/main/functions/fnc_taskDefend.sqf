/*
Author:
Rommel,SilentSpike,Nicholas Clark (SENSEI)

Description:
set group to defend area. Modified version of CBA_fnc_taskDefend

if buildings in defended area are spawned after mission start, the group must exist and initialize before said buildings in order for pathing to function

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

// {deleteVehicle _x} forEach arrows;
// arrows = [];

if !(local _group) exitWith {false};

// clear existing waypoints
[_group] call CBA_fnc_clearWaypoints;

// make sure units can move
{
    _x enableAI "PATH";
} forEach units _group;

private _statics = _position nearObjects ["StaticWeapon",_radius];
private _buildings = _position nearObjects ["House",_radius];

// Filter out occupied statics
_statics = _statics select {!((locked _x) isEqualTo 2) && {(_x emptyPositions "Gunner") > 0}}; 

// Filter out buildings below the size threshold (and store positions for later use)
private ["_positions"];

_buildings = _buildings select {
    _positions = _x buildingPos -1;

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

private ["_building","_buildingPositions","_pos"];
{
    // 31% chance to occupy nearest free static weapon
    if (PROBABILITY(0.31) && {!(_statics isEqualto [])}) then {
        _x assignAsGunner (_statics deleteAt 0);
        [_x] orderGetIn true;
    } else {
        if (!(_buildings isEqualto []) && {!(PROBABILITY(_patrol))}) then {
            _building = selectRandom _buildings;
            _buildingPositions = _building getVariable ["CBA_taskDefend_positions",[]];

            if !(_buildingPositions isEqualTo []) then {
                _pos = _buildingPositions deleteAt (floor (random (count _buildingPositions)));
                
                // @todo CBA_taskDefend_positions isn't being updated correctly, multiple units taking same position
                // If building positions are all taken remove from possible buildings
                if (_buildingPositions isEqualTo []) then {
                    _buildings deleteAt (_buildings find _building);
                    _building setVariable ["CBA_taskDefend_positions",nil];
                } else {
                    _building setVariable ["CBA_taskDefend_positions",_buildingPositions];
                };

                _x setVariable [QGVAR(taskDefend_pos),_pos];

                // Wait until AI is in position then force them to stay
                [_x,_pos] spawn {
                    params ["_unit","_pos"];

                    // _arrow = createVehicle ["Sign_Arrow_F",_pos,[],0,"CAN_COLLIDE"];
                    // _arrow setPos _pos;
                    // arrows pushBack _arrow;

                    if (surfaceIsWater _pos) exitwith {};

                    _unit doMove _pos;
        
                    waitUntil {unitReady _unit};

                    // snap units into position if necessary
                    if !(CHECK_DIST(_unit,_pos,1.5)) then {
                        _unit setPosATL _pos;
                    };

                    doStop _unit;

                    // This command causes AI to repeatedly attempt to crouch when engaged
                    // If ever fixed by BI then consider uncommenting
                    _unit setUnitPos "UP";

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

// Unassigned (or combat reacted) units will patrol
[_group,_position,_radius,0,"if (0.15 > random 1) then {this spawn CBA_fnc_searchNearby}"] call FUNC(taskPatrol);

true