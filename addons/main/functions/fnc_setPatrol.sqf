/*
Author:
Nicholas Clark (SENSEI)

Description:
set group on patrol

Arguments:
0: patrol group <GROUP>
1: patrol center positionAGL <ARRAY>
2: distance from center position <NUMBER>
3: patrol type <NUMBER>
4: waypoint completion statement <STRING>
5: array of blacklist polygons <ARRAY>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"
#define AIR_RADIUS_MIN 800
#define ROAD_SEARCH_DIST 500

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

[_group] call CBA_fnc_clearWaypoints;

// make sure units can move
{
    _x enableAI "PATH";
} forEach units _group;

// make sure air patrol radius is large enough
if (_groupVehicle isKindOf "Air") then {
    _radius = _radius max AIR_RADIUS_MIN;
};

private _count = [3,6] call BIS_fnc_randomInt;
private _wpPositions = [];

private ["_angle","_a","_b","_roads"];

for "_i" from 0 to _count - 1 do {
    _angle = (360 / _count) * _i;
    _a = (_position select 0) + (sin _angle * _radius);
    _b = (_position select 1) + (cos _angle * _radius);

    if (_groupVehicle isKindOf "LandVehicle") then {
        _roads = [_a,_b] nearRoads ROAD_SEARCH_DIST;

        if (_roads isEqualTo []) exitWith {};

        _roads = selectRandom _roads;
        _a = (getPosATL _roads) select 0;
        _b = (getPosATL _roads) select 1;
    };

    if (_groupVehicle isKindOf "Land" && !(surfaceIsWater [_a,_b]) || {_groupVehicle isKindOf "Ship" && surfaceIsWater [_a,_b]} || {_groupVehicle isKindOf "Air"}) then {
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

private "_wp";

{
    _wp = _group addWaypoint [_x,[-1,0] select (isNull objectParent leader _group)];

    _wp setWaypointType "MOVE";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointCombatMode "YELLOW";
    _wp setWaypointSpeed (["NORMAL","LIMITED"] select (isNull objectParent leader _group));
    _wp setWaypointFormation _formation;
    _wp setWaypointStatements ["TRUE",_onComplete];
    _wp setWaypointTimeout ([[0,5,16],[0,0,0]] select (_groupVehicle isKindOf "Air"));
    _wp setWaypointCompletionRadius (10 + (_radius * 0.1));
} forEach _wpPositions;

// close patrol loop
_wp = _group addWaypoint [_position,0];

_wp setWaypointType "CYCLE";
_wp setWaypointStatements ["TRUE",_onComplete];
_wp setWaypointCompletionRadius (10 + (_radius * 0.1));

true