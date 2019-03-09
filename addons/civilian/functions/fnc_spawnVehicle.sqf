/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn civilian vehicle

Arguments:
0: road where vehicle will spawn <OBJECT>
1: road near target player <OBJECT>
2: road where vehicle will be deleted <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define CLEANUP QUOTE(GVAR(drivers) deleteAt (GVAR(drivers) find this); (vehicle this) call EFUNC(main,cleanup))
#define TIMEOUT 300
#define COMPLETION_RADIUS 30

params ["_start","_mid","_end"];

private _grp = [getPosASL _start,1,1,CIVILIAN] call EFUNC(main,spawnGroup);

[_grp] call EFUNC(cache,disableCache);

[
    {!(isNull (assignedVehicle leader (_this select 0)))},
    {
        params ["_grp","_start","_mid","_end"];

        private _veh = vehicle (leader _grp);
        private _driver = driver _veh;

        // eventhandlers
        _driver addEventHandler ["GetOutMan", {
            GVAR(drivers) deleteAt (GVAR(drivers) find (_this select 0));
            [_this select 0, _this select 2] call EFUNC(main,cleanup);            
        }];

        // behaviors
        _grp setBehaviour "CARELESS";
        _veh allowCrewInImmobile true;
        _driver disableAI "FSM";
        
        // set waypoint to midpoint
        private _wp = _grp addWaypoint [_mid,0];
        _wp setWaypointTimeout [0,0,0];
        _wp setWaypointBehaviour "CARELESS";
        _wp setWaypointSpeed (selectRandom ["LIMITED","NORMAL"]);
        _wp setWaypointStatements [FORMAT_1(QUOTE(CHECK_DIST2D(this,%1,COMPLETION_RADIUS)),getPosASL _end), CLEANUP];

        // move waypoint position to endpoint once unit is close to midpoint
        // this method solves unit hesitating at midpoint
        [
            {CHECK_DIST2D(_this select 0,_this select 2,COMPLETION_RADIUS)},
            {
                // exact placement
                (_this select 1) setWaypointPosition [getPosASL(_this select 3), -1];
            },
            [_driver,_wp,_mid,_end]
        ] call CBA_fnc_waitUntilAndExecute;    

        // add to driver array
        GVAR(drivers) pushBack _driver;

        TRACE_5("spawned civilian vehicle",getPosASL _driver, typeOf _veh, getPosASL _start, getPosASL _mid, getPosASL _end);
    },
    [_grp,_start,_mid,_end]
] call CBA_fnc_waitUntilAndExecute;

// unit must complete route before timeout
[
    compile CLEANUP, 
    nil,
    TIMEOUT
] call CBA_fnc_waitAndExecute;

nil