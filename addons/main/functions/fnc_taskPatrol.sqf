/*
Author:
Nicholas Clark (SENSEI)

Description:
set group on patrol

Arguments:
0: patrol group <GROUP>
1: patrol center position <ARRAY>
2: distance from center position <NUMBER>
3: patrol type <NUMBER>
4: waypoint completion statement <STRING>
5: array of blacklist polygons <ARRAY>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_group",grpNull,[grpNull]],
    ["_position",DEFAULT_POS,[[]]],
    ["_radius",100,[0]],
    ["_type",0,[0]],
    ["_onComplete","",[""]],
    ["_blacklist",[],[[]]]
];

/* 
    types
        0: group patrols in and around area
        1: group patrols perimeter of area
        2: group patrols area as individuals
*/

if !(local _group) exitWith {false};

if (isNull _group) exitWith {
    WARNING("group does not exist");
    false
};

if (_position isEqualTo []) exitWith {
    WARNING("position is empty");
    false
};

private _groupVehicle = vehicle leader _group;
private _formation = selectRandom ["STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","DIAMOND"];

// clamp aircraft patrol radius
if (_groupVehicle isKindOf "Air") then {
	_radius = _radius max 1000;
};

// clear existing waypoints
[_group] call CBA_fnc_clearWaypoints;

// make sure units can move
{
    _x enableAI "PATH";
} forEach units _group;

if (_type < 2) then {
    // count increases with radius
    private _count = (round (_radius / 64) max 3) min 6;
    private _wpPositions = [];

    private ["_angle","_a","_b"];

    for "_i" from 0 to _count - 1 do {
        _angle = (360 / _count) * _i;
        _a = (_position select 0) + (sin _angle * _radius);
        _b = (_position select 1) + (cos _angle * _radius);

        if (_groupVehicle isKindOf "LAND" && !(surfaceIsWater [_a,_b]) || {_groupVehicle isKindOf "SHIP" && surfaceIsWater [_a,_b]} || {_groupVehicle isKindOf "AIR"}) then {
            // check if position in blacklist
            // if (_blacklist findIf {[_a,_b,0] inPolygon _x} < 0) then {
            //     _wpPositions pushBack [_a,_b,0];
            // };
            _wpPositions pushBack [_a,_b,0];
        };
    };

    if (_wpPositions isEqualTo []) exitWith {
        WARNING_1("cannot find suitable waypoint positions for %1",_group);
        false
    };
    
    // allow crisscrossing
    if (_type isEqualTo 0) then {
        _wpPositions = _wpPositions call BIS_fnc_arrayShuffle;
    };

    // add waypoints
    private ["_wp"];

    {
        _wp = _group addWaypoint [_x, 0];

        _wp setWaypointType "MOVE";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointCombatMode "YELLOW";
        _wp setWaypointSpeed (["NORMAL","LIMITED"] select (isNull (objectParent (leader _group)))); 
        _wp setWaypointFormation _formation;
        _wp setWaypointStatements ["TRUE",_onComplete];
        _wp setWaypointTimeout [0,5,16];
        _wp setWaypointCompletionRadius (10 + (_radius / 5));
    } forEach _wpPositions;

    // close patrol loop
    _wp setWaypointType "CYCLE";

    true
} else {
    if !(leader _group isEqualTo _groupVehicle) exitWith {
        WARNING_1("cannot patrol as individuals while %1 leader in vehicle",_group);
        false
    };

    {
        
    } forEach units _group;
};