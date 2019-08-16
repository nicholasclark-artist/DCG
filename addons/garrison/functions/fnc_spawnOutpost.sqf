/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn outposts

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"
#define SPAWN_DELAY 0.25
#define PATROL_UNITCOUNT 2

[GVAR(outposts),{
    private _type = (_value getVariable [QGVAR(terrain),""]) call {
        if (COMPARE_STR(_this,"meadow")) exitWith {"mil_base"};
        if (COMPARE_STR(_this,"hill")) exitWith {"mil_outpost"};
        if (COMPARE_STR(_this,"forest")) exitWith {"mil_camp"};
    };

    // spawn outpost for certain terrain type
    private _composition = [getPos _value,_type,(random 1) min 0.5,random 360,true] call EFUNC(main,spawnComposition);
    
    // set new outpost radius 
    _value setVariable [QGVAR(radius),_composition select 0];

    // spawn group to garrison outpost
    private _grp = [getPos _value,0,OP_UNITCOUNT,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

    [{(_this select 0) setVariable [QEGVAR(main,ready),false]},
        {
            params ["_grp","_location"];
            
            // update unit count 
            private _count = _value getVariable [QGVAR(unitCountCurrent),-1];
            _value setVariable [QGVAR(unitCountCurrent),_count + (count units _grp)];

            // add eventhandlers and vars
            {
                _x setVariable [QGVAR(outpost),true];
                _x setVariable [QGVAR(location),_location];

                _x addEventHandler ["Killed", {
                    _location = (_this select 0) getVariable [QGVAR(location),locationNull];
                    _location call (_location getVariable [QGVAR(onKilled),{}]);
                }]; 
            } forEach (units _grp);

            // split into patrol groups
            [
                _grp,
                PATROL_UNITCOUNT,
                {
                    [_this select 0, _this select 1, _this select 2, 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "if (random 1 < 0.15) then {this spawn CBA_fnc_searchNearby}", [0,10,15]] call CBA_fnc_taskPatrol
                },
                [getPos _location, _location getVariable [QGVAR(radius),100]],
                0,
                0.1
            ] call EFUNC(main,splitGroup);

            TRACE_2("outpost infantry",getPos _location, _grp);
        },
        [_grp,_value],
        (SPAWN_DELAY * OP_UNITCOUNT) * 2,
        {
            WARNING_2("infantry count is low: %1. intended count: %2",count units _grp,OP_UNITCOUNT)
        }
    ] call CBA_fnc_waitUntilAndExecute;

    // find safe position for vehicle
    _pos = [getPos _value,1,_value getVariable [QGVAR(radius),100],12,0,-1,[0,360],getPos _value] call EFUNC(main,findPosSafe);

    // spawn vehicle
    if !(_pos isEqualTo (getPos _value)) then {
        _grp = [_pos,1,1,EGVAR(main,enemySide),SPAWN_DELAY,true] call EFUNC(main,spawnGroup);

        [{(_this select 0) setVariable [QEGVAR(main,ready),false]},
            {
                params ["_grp","_location"];

                // update unit count 
                private _count = _value getVariable [QGVAR(unitCountCurrent),-1];
                _value setVariable [QGVAR(unitCountCurrent),_count + (count units _grp)];

                // add eventhandlers and vars
                {
                    _x setVariable [QGVAR(outpost),true];
                    _x setVariable [QGVAR(location),_location];

                    _x addEventHandler ["Killed", {
                        _location = (_this select 0) getVariable [QGVAR(location),locationNull];
                        _location call (_location getVariable [QGVAR(onKilled),{}]);
                    }]; 
                } forEach (units _grp);

                (assignedVehicle leader _grp) addEventHandler ["Fuel",{if !(_this select 1) then {(_this select 0) setFuel 1}}];

                // set patrol
                [_grp, getPos _location, _location getVariable [QGVAR(radius),100], 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [10,20,30]] call CBA_fnc_taskPatrol;
            },
            [_grp,_value],
            (SPAWN_DELAY * OP_UNITCOUNT) * 2
        ] call CBA_fnc_waitUntilAndExecute;  
    };

    // spawn officer
    private _officer = (createGroup EGVAR(main,enemySide)) createUnit [selectRandom ([EGVAR(main,enemySide),3] call EFUNC(main,getPool)), getPos _value, [], 0, "NONE"];
    
    _value setVariable [QGVAR(officer),_officer];

    // update unit count 
    private _count = _value getVariable [QGVAR(unitCountCurrent),-1];
    _value setVariable [QGVAR(unitCountCurrent),_count + 1];

    // officer patrol
    [group _officer, getPos _value, (_value getVariable [QGVAR(radius),100]) * 0.5, 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "if (random 1 < 0.15) then {this spawn CBA_fnc_searchNearby}", [0,10,15]] call CBA_fnc_taskPatrol;
}] call CBA_fnc_hashEachPair;

true