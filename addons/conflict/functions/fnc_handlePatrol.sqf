/*
Author:
Nicholas Clark (SENSEI)

Description:
run dynamic patrol handler

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE_MAIN QGVAR(handlePatrol)

/*
    @todo
    - if knowsAbout > 0 then patrol wp is S&D
        - higher knowsAbout = player position precision
*/

scopeName SCOPE_MAIN;

// delete null and lonely groups
private _groupsToDelete = GVAR(patrolGroups) select {
    isNull _x ||
    {([getPosATL (leader _x),500] call EFUNC(main,getNearPlayers) isEqualTo []) &&
    !(behaviour (leader _x) isEqualTo "COMBAT")}
};

{
    GVAR(patrolGroups) deleteAt (GVAR(patrolGroups) find _x);
    (assignedVehicle (leader _x)) call CBA_fnc_deleteEntity;
    _x call CBA_fnc_deleteEntity;
} forEach _groupsToDelete;

if (count GVAR(patrolGroups) > DYNPAT_GRPLIMIT) exitWith {
    WARNING("group limit reached for dynamic patrols");
};

private _player = call EFUNC(main,getTargetPlayer);

if (isNull _player) exitWith {
    WARNING("cannot find target player for dynamic patrol");
};

// get chance to spawn patrols
private _dist = worldSize;
private _inAO = false;

[GVAR(areas),{
    // distance to nearest AO
    _dist = _dist min (_player distance2D (_value getVariable [QEGVAR(main,positionASL),DEFAULT_POS]));

    if ((getPosATL _player) inPolygon (_value getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON])) then {
        _inAO = true;
        breakTo SCOPE_MAIN;
    };
}] call CBA_fnc_hashEachPair;

// chance of patrol decreases as distance from AO increase
private _distProb = linearConversion [0,DYNPAT_RANGE,_dist,1,0.05,true];

if (!GVAR(enableExternalPatrols) && {!_inAO}) then {
    _distProb = 0;
};

TRACE_1("dynamic patrol probability",_distProb);

if (PROBABILITY(_distProb)) then {
    private _pos = EGVAR(main,grid) findIf {CHECK_DIST(_player,_x,DYNPAT_SPAWNRANGE)};

    if (_pos < 0) exitWith {
        WARNING("cannot find suitable position for dynamic patrol");
    };

    _pos = EGVAR(main,grid) select _pos;

    if !([_pos,50] call EFUNC(main,getNearPlayers) isEqualTo []) exitWith {
        WARNING("players found close to dynamic patrol spawn position");
    };

    private ["_grp","_posWP","_wp"];

    if (PROBABILITY(GVAR(vehicleProbability))) then {
        INFO_1("spawning dynamic patrol (vehicle) at %1",_pos);

        // don't cache patrol groups
        _grp = [_pos,1,-1,EGVAR(main,enemySide),1,true,true] call EFUNC(main,spawnGroup);

        [
            {(_this select 0) getVariable [QEGVAR(main,ready),false]},
            {
                [_this select 0,_this select 1,DYNPAT_RADIUS,0] call EFUNC(main,setPatrol);
            },
            [_grp,_pos],
            60
        ] call CBA_fnc_waitUntilAndExecute;

        // infinite fuel
        (objectParent leader _grp) addEventHandler ["Fuel",{
            if !(_this select 1) then {(_this select 0) setFuel 1};
        }];
    } else {
        INFO_1("spawning dynamic patrol (infantry) at %1",_pos);

        // don't cache patrol groups
        _grp = [_pos,0,[3,6] call BIS_fnc_randomInt,EGVAR(main,enemySide),2,0,true] call EFUNC(main,spawnGroup);

        _posWP = _player getPos [100,random 360];
        if (surfaceIsWater _posWP) then {
            _posWP = getPos _player;
        };

        [
            {(_this select 0) getVariable [QEGVAR(main,ready),false]},
            {
                _wp = (_this select 0) addWaypoint [_this select 1,0];
                _wp setWaypointType "MOVE";
                _wp setWaypointBehaviour "SAFE";
                _wp setWaypointSpeed "LIMITED";
                _wp setWaypointStatements [
                    "!(behaviour this isEqualTo ""COMBAT"")",
                    format ["[group this,getPos this,%1,0] call %2",DYNPAT_RADIUS,QEFUNC(main,setPatrol)]
                ];
            },
            [_grp,_posWP],
            60
        ] call CBA_fnc_waitUntilAndExecute;
    };

    GVAR(patrolGroups) pushBack _grp;
};

nil