/*
Author:
Nicholas Clark (SENSEI)

Description:
set units on patrol

Arguments:
0: group of units <GROUP>
1: max patrol distance <NUMBER>
2: infantry patrol as individuals <BOOL>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"
#define RADIUS_MIN 45
#define RADIUS_COMPMIN 20
#define LIMITSPEED_SLOW 5
#define LIMITSPEED_NONE 999999
#define HOUSE_DIST 50
#define HOUSE_CHANCE 0.25
#define HOUSE_TIMEOUT 60
#define HOUSE_DELAY 15 + random 15
#define HOUSE_POSRADIUS 3
#define SETPATROL(PATROLUNITS) \
{ \
    _x setVariable [ISONPATROL,1]; \
} forEach PATROLUNITS

params [
    ["_grp",grpNull,[grpNull]],
    ["_radius",100,[0]],
    ["_individual",true,[false]],
    ["_behavior","SAFE",[""]]
];

if !(local _grp) exitWith {
    WARNING_1("Cannot set patrol for non local group, %1",_grp);
    false
};

_behavior = toUpper _behavior;
_grp setBehaviour _behavior;
_leader = leader _grp;
_radius = _radius max RADIUS_MIN;

[_grp] call CBA_fnc_clearWaypoints;

if !(isNull objectParent _leader) then { // if unit is in vehicle
    private _veh = objectParent _leader;

    if (_veh isKindOf "Air") exitWith {
        private _waypoint = _grp addWaypoint [getPos _veh,0];
        _waypoint setWaypointType "LOITER";
        _waypoint setWaypointLoiterRadius _radius;
        _waypoint setWaypointLoiterType "CIRCLE";
        _waypoint setWaypointSpeed "NORMAL";
        _waypoint setWaypointBehaviour _behavior;

        SETPATROL(units _grp);

        true
    };

    private _center = getPos _leader;
    private _posPrev = _center;
    private _compRadius = _radius*0.15 max RADIUS_COMPMIN;

    for "_d" from 0 to 4 do {
        private _pos = [_posPrev,_radius,_radius,objNull,-1,-1,72*_d] call FUNC(findPosSafe);
        private _waypoint = _grp addWaypoint [ASLToAGL _pos,0];
        _waypoint setWaypointType "MOVE";
        _waypoint setWaypointCompletionRadius _compRadius;
        _waypoint setWaypointSpeed "LIMITED";
        _waypoint setWaypointFormation "COLUMN";
        _waypoint setWaypointBehaviour _behavior;
        _posPrev = _pos;
    };

    ((waypoints _grp) select (count (waypoints _grp) - 1)) setWaypointType "CYCLE";

    SETPATROL(units _grp);

    true
} else { // if unit is on foot
    if !(_individual) exitWith { // group patrol
        private _center = getPos _leader;
        private _posPrev = _center;
        private _compRadius = _radius*0.15 max RADIUS_COMPMIN;

        for "_d" from 0 to 4 do {
            private _pos = [_posPrev,_radius,_radius,objNull,-1,-1,72*_d] call FUNC(findPosSafe);
            private _waypoint = _grp addWaypoint [ASLToAGL _pos,0];
            _waypoint setWaypointType "MOVE";
            _waypoint setWaypointCompletionRadius _compRadius;
            _waypoint setWaypointSpeed "LIMITED";
            _waypoint setWaypointFormation "COLUMN";
            _waypoint setWaypointBehaviour _behavior;
            _posPrev = _pos;
        };

        ((waypoints _grp) select (count (waypoints _grp) - 1)) setWaypointType "CYCLE";

        SETPATROL(units _grp);

        true
    };

    {
        [{
            params ["_args","_idPFH"];
            _args params ["_unit","_center","_radius","_behavior"];

            if (!alive _unit || {_unit getVariable [ISONPATROL,-1] isEqualTo 0}) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                _unit limitSpeed LIMITSPEED_NONE;

                LOG_2("%1 exiting patrol at %2", _unit, getPosASL _unit);
            };

            if !(behaviour _unit isEqualTo "COMBAT") then {
                if (unitReady _unit) then {
                    _unit limitSpeed LIMITSPEED_SLOW;
                    _unit setBehaviour _behavior;

                    if (random 1 < HOUSE_CHANCE) exitWith {
                        private _houses = (getposATL _unit) nearObjects ["house",HOUSE_DIST];
                        private _housePosArray = (selectRandom _houses) buildingPos -1;
                        if !(_housePosArray isEqualTo []) then {
                            _pos = selectRandom _housePosArray;
                            _unit doMove _pos;
                            LOG_2("%1 moving to house position %2", _unit, _pos);

                            // move to house position and wait for some time
                            [
                                {CHECK_DIST2D(_this select 0,_this select 1,HOUSE_POSRADIUS) || {diag_tickTime > (_this select 2) + HOUSE_TIMEOUT}},
                                {
                                    params ["_unit","_pos","_time"];

                                    if (diag_tickTime <= _time + HOUSE_TIMEOUT) then {
                                        _unit limitSpeed 0;
                                        LOG_1("Stopping %1 in house position", _unit);

                                        [
                                            {
                                                params ["_unit"];

                                                LOG_1("%1 leaving house position", _unit);
                                                _unit limitSpeed LIMITSPEED_SLOW;
                                            },
                                            [_unit],
                                            HOUSE_DELAY
                                        ] call CBA_fnc_waitAndExecute;
                                    };
                                },
                                [_unit,_pos,diag_tickTime]
                            ] call CBA_fnc_waitUntilAndExecute;
                        };
                    };

                    _d = random 360;
                    _rMin = _radius*0.25;
                    _r = floor (random ((_radius - _rMin) + 1)) + _rMin;
                    _pos = [(_center select 0) + (sin _d) * _r, (_center select 1) + (cos _d) * _r, 0];

                    if !(surfaceIsWater _pos) then {
                        _unit doMove _pos;
                    };
                };
            };
        }, 10, [_x,getPosATL _x,_radius,_behavior]] call CBA_fnc_addPerFrameHandler;
    } forEach units _grp;

    SETPATROL(units _grp);

    true
};
