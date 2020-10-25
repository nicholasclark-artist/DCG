/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn civilian vehicle

Arguments:
0: position where vehicle will spawn <ARRAY>
1: position near target player <ARRAY>
2: position where vehicle will be deleted <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define COMPLETION_DIST 100
#define SPEED_LIMIT 65

params ["_start","_mid","_end"];

private _grp = [_start,1,1,CIVILIAN,1,0,true] call EFUNC(main,spawnGroup);

[
    {(_this select 0) getVariable [QEGVAR(main,ready),false]},
    {
        params ["_grp","_start","_mid","_end"];

        private _veh = vehicle (leader _grp);
        private _driver = driver _veh;

        // add commandeer action on all machines
        [[_veh],{
            if (hasInterface) then {
                params ["_veh"];

                [
                    QGVAR(commandeer),
                    "Commandeer Vehicle",
                    {
                        [QGVAR(commandeer),_target] call CBA_fnc_serverEvent;
                    },
                    {!(_target getVariable [QGVAR(commandeer),false])},
                    {},
                    [],
                    _veh,
                    0,
                    ["ACE_MainActions"],
                    [0,0,0],
                    30
                ] call EFUNC(main,setAction);
            };
        }] remoteExecCall [QUOTE(BIS_fnc_call),0];

        // driver will never exit vehicle unless commandeered
        _veh allowCrewInImmobile true;

        // _veh forceFollowRoad true;
        _veh limitSpeed ([SPEED_LIMIT * 0.5,SPEED_LIMIT] call BIS_fnc_randomInt);
        _grp setBehaviourStrong "CARELESS";
        // _driver disableAI "FSM";
        // _driver disableAI "TARGET";
        // _driver disableAI "AUTOTARGET";
        // _driver setSkill 0;

        // set waypoint to midpoint
        private _wp = _grp addWaypoint [ATLtoASL _mid,-1];
        _wp setWaypointTimeout [0,0,0];
        _wp setWaypointStatements [
            format [QUOTE(CHECK_DIST(getPosATL this,%1,COMPLETION_DIST)),_end],
            format ["%1 deleteAt (%1 find this); ['%2',vehicle this] call CBA_fnc_serverEvent; (vehicle this) setVariable ['%3',true]; diag_log 'route complete';",QGVAR(drivers),QEGVAR(main,cleanup),QGVAR(complete)]
        ];

        // move waypoint position to endpoint once driver is close to midpoint
        // this method solves driver hesitating at midpoint
        [
            {CHECK_DIST(getPosATL (_this select 0),_this select 2,COMPLETION_DIST)},
            {
                // exact placement
                (_this select 1) setWaypointPosition [_this select 3,-1];
            },
            [_driver,_wp,_mid,_end]
        ] call CBA_fnc_waitUntilAndExecute;

        // delete driver if route not complete before timer
        [
            {
                params ["_veh","_driver"];

                if (_veh getVariable [QGVAR(complete),false] || {_veh getVariable [QGVAR(commandeer),false]}) exitWith {};

                WARNING_1("%1 did not complete route in time",_driver);

                if !(isNull _driver) then {
                    GVAR(drivers) deleteAt (GVAR(drivers) find _driver);
                    [QEGVAR(main,cleanup),_driver] call CBA_fnc_serverEvent;
                };

                // dont delete vehicle if comandeered
                if (!isNull _veh && {!(_veh getVariable [QGVAR(commandeer),false])}) then {
                    [QEGVAR(main,cleanup),_veh] call CBA_fnc_serverEvent;
                };
            },
            [_veh,_driver],
            ((((_start distance _end)/1000)/SPEED_LIMIT)*3600)*2.5
        ] call CBA_fnc_waitAndExecute;

        GVAR(drivers) pushBack _driver;

        TRACE_2("spawning driver",_driver,_this);
    },
    [_grp,_start,_mid,_end]
] call CBA_fnc_waitUntilAndExecute;

nil