/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn outposts, should not be called directly

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE "spawnOutpost"
#define SPAWN_DELAY 0.15

// @todo add mil_camp compositions 

// define scope to break hash loop
scopeName SCOPE;

[GVAR(outposts),{
    // get composition type
    private _type = (_value getVariable [QGVAR(terrain),""]) call {
        if (COMPARE_STR(_this,"meadow")) exitWith {"mil_base"};
        if (COMPARE_STR(_this,"hill")) exitWith {"mil_outpost"};
        if (COMPARE_STR(_this,"forest")) exitWith {/* "mil_camp" */"civ_camp"};
    };

    // get patrol unit count based on player count
    private _unitCount = [10,32,5] call EFUNC(main,getUnitCount);

    // simplify outpost position 
    private _posOutpost = getPos _value;
    _posOutpost resize 2;

    // spawn outpost for certain terrain type
    private _composition = [_posOutpost,_type,random 0.15,random 360,true] call EFUNC(main,spawnComposition);
    
    if (_composition isEqualTo []) then {
        breakTo SCOPE;
    };

    // set new outpost radius 
    _value setVariable [QGVAR(radius),_composition select 0];

    // spawn infantry patrol
    private _pos = [_posOutpost,(_composition select 0) + 10,(_composition select 0) + 50,2,0,-1,[0,360],_posOutpost getPos [(_composition select 0) + 20,random 360]] call EFUNC(main,findPosSafe);

    for "_i" from 1 to floor (_unitCount/OP_PATROLSIZE) do {
        private _grp = [_pos,0,OP_PATROLSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

        [{(_this select 0) getVariable [QEGVAR(main,ready),false]},
            {
                params ["_grp","_location"];
                
                // add eventhandlers
                {
                    _x setVariable [QGVAR(location),_location];
                    _x addEventHandler ["Killed", {
                        _location = (_this select 0) getVariable [QGVAR(location),locationNull];
                        _location call (_location getVariable [QGVAR(onKilled),{}]);
                    }]; 
                } forEach (units _grp);

                [QGVAR(updateUnitCount),[_location,count units _grp]] call CBA_fnc_localEvent;
                [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;

                // set group on patrol
                [_grp, getPos _location, (50 max (_location getVariable [QGVAR(radius),100])) * (random [1,1.5,2]), 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "if (0.1 > random 1) then {this spawn CBA_fnc_searchNearby}", [5,16,15]] call CBA_fnc_taskPatrol;
            },
            [_grp,_value],
            (SPAWN_DELAY * _unitCount) * 2
        ] call CBA_fnc_waitUntilAndExecute;
    };
    
    // get composition buildings with suitable positions  
    private _buildings = _posOutpost nearObjects ["House", _composition select 0];
    _buildings = _buildings select {!((_x buildingPos -1) isEqualTo [])};
    
    if (_buildings isEqualTo []) then {
        WARNING("%1 outpost does not have building positions",_key);
    };

    // garrison infantry
    private ["_unit"];

    {
        if (PROBABILITY(0.5)) then {
            _unit = (createGroup EGVAR(main,enemySide)) createUnit [selectRandom ([EGVAR(main,enemySide),0] call EFUNC(main,getPool)), DEFAULT_SPAWNPOS, [], 0, "CAN_COLLIDE"];


            private _dir = random 360;
            _unit setFormDir _dir;
            _unit setDir _dir;

            if (PROBABILITY(0.5)) then { // garrison building exit
                _unit setPosATL (_x buildingExit 0);
            } else { // garrison building
                _unit setPosATL selectRandom (_x buildingPos -1);
            };

            // add eventhandlers
            _unit setVariable [QGVAR(location),_value];
            _unit addEventHandler ["Killed", {
                _location = (_this select 0) getVariable [QGVAR(location),locationNull];
                _location call (_location getVariable [QGVAR(onKilled),{}]);
            }]; 

            [QEGVAR(cache,enableGroup),group _unit] call CBA_fnc_serverEvent;
            [QGVAR(updateUnitCount),[_value,1]] call CBA_fnc_localEvent;
            [QGVAR(updateGroups),[_value,group _unit]] call CBA_fnc_localEvent;
        };
    } forEach _buildings;

    // garrison officer
    private _officer = (createGroup EGVAR(main,enemySide)) createUnit [selectRandom ([EGVAR(main,enemySide),3] call EFUNC(main,getPool)), DEFAULT_SPAWNPOS, [], 0, "CAN_COLLIDE"];
    
    private _dir = random 360;
    _officer setFormDir _dir;
    _officer setDir _dir;
    
    if (_buildings isEqualTo []) then {
        _officer setPos (_posOutpost getPos [(_composition select 0) * 0.5,random 360]);
    } else {
        _officer setPosATL selectRandom ((selectRandom _buildings) buildingPos -1);
    };


    // add eventhandlers and vars
    _value setVariable [QGVAR(officer),_officer];
    _officer setVariable [QGVAR(location),_value];
    _officer addEventHandler ["Killed", {
        _location = (_this select 0) getVariable [QGVAR(location),locationNull];
        _location call (_location getVariable [QGVAR(onKilled),{}]);
    }]; 

    [QEGVAR(cache,enableGroup),group _officer] call CBA_fnc_serverEvent;
    [QGVAR(updateUnitCount),[_value,1]] call CBA_fnc_localEvent;
    [QGVAR(updateGroups),[_value,group _officer]] call CBA_fnc_localEvent;

    // check dynamic task params

    // spawn outpost task
    // private _locationAO = [GVAR(areas),_key] call CBA_fnc_hashGet;
    // private _taskNearest = _locationAO getVariable [QGVAR(nearestLocation),locationNull];

}] call CBA_fnc_hashEachPair;

nil