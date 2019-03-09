/*
Author:
Nicholas Clark (SENSEI)

Description:
run patrol handler

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define PATROL_RANGE 700
#define PATROL_MINRANGE PATROL_RANGE*0.6

// delete null and lonely groups
_groupsToDelete = GVAR(groups) select {
    isNull _x || 
    {([getPosATL (leader _x),PATROL_RANGE] call EFUNC(main,getNearPlayers) isEqualTo []) && 
    !(behaviour (leader _x) isEqualTo "COMBAT")}
};

{
    GVAR(groups) deleteAt (GVAR(groups) find _x);
    GETVAR(leader _x,EGVAR(main,assignedVehicle),objNull) call CBA_fnc_deleteEntity;
    _x call CBA_fnc_deleteEntity;
} forEach _groupsToDelete;

if (count GVAR(groups) <= ceil GVAR(groupLimit)) then {
    _players = call CBA_fnc_players;

    if !(_players isEqualTo []) then {
        _player = selectRandom _players;
        
        if !([_player] call EFUNC(main,inSafezones)) then {
            _posArray = [getPosATL _player,100,PATROL_RANGE,PATROL_MINRANGE,10,0,false] call EFUNC(main,findPosGrid);

            if (_posArray isEqualTo []) exitWith {};

            _pos = selectRandom _posArray;
            _players = [getPosATL _player,100] call EFUNC(main,getNearPlayers);
            
            if ([_pos,100] call EFUNC(main,getNearPlayers) isEqualTo [] && {{[[_pos select 0,_pos select 1,(_pos select 2) + 1.5],eyePos _x] call EFUNC(main,inLOS)} count _players isEqualTo 0}) then {
                _grp = grpNull;
                _pos = ASLtoAGL _pos;

                if (PROBABILITY(GVAR(vehicleProbability))) then { 
                    _grp = [_pos,1,1,EGVAR(main,enemySide),1,true] call EFUNC(main,spawnGroup);
                    [QEGVAR(cache,disable),_grp] call CBA_fnc_serverEvent;

                    [
                        {count units (_this select 0) > 0},
                        {
                            params ["_grp","_player"];

                            // set waypoint around target player
                            _wp = _grp addWaypoint [getPosATL _player,0];
                            _wp setWaypointCompletionRadius 200;
                            _wp setWaypointBehaviour "SAFE";
                            _wp setWaypointFormation "STAG COLUMN";
                            _wp setWaypointSpeed "NORMAL";
                            _wp setWaypointStatements [
                                "!(behaviour this isEqualTo ""COMBAT"")",
                                format ["[this, this, %1, 5, ""MOVE"", ""SAFE"", ""YELLOW"", ""NORMAL"", ""STAG COLUMN"", """", [5,10,15]] call CBA_fnc_taskPatrol;",PATROL_RANGE]
                            ];
                        },
                        [_grp,_player]
                    ] call CBA_fnc_waitUntilAndExecute;

                    INFO_1("spawning vehicle patrol at %1",_pos);
                } else {
                    _count = 4;
                    _grp = [_pos,0,_count,EGVAR(main,enemySide),2] call EFUNC(main,spawnGroup);
                    [QEGVAR(cache,disable),_grp] call CBA_fnc_serverEvent;
                    
                    [
                        {count units (_this select 0) isEqualTo (_this select 2)},
                        {
                            params ["_grp","_player","_count"];

                            // set waypoint around target player
                            _wp = _grp addWaypoint [getPosATL _player,0];
                            _wp setWaypointCompletionRadius 50;
                            _wp setWaypointBehaviour "SAFE";
                            _wp setWaypointFormation "STAG COLUMN";
                            _wp setWaypointSpeed "LIMITED";
                            _wp setWaypointStatements [
                                "!(behaviour this isEqualTo ""COMBAT"")",
                                format ["[this, this, %1, 5, ""MOVE"", ""SAFE"", ""YELLOW"", ""LIMITED"", ""STAG COLUMN"", """", [0,0,0]] call CBA_fnc_taskPatrol;",PATROL_RANGE]
                            ];
                        },
                        [_grp,_player,_count]
                    ] call CBA_fnc_waitUntilAndExecute;

                    INFO_1("spawning infantry patrol at %1",_pos);
                };
                GVAR(groups) pushBack _grp;
            };
        };
    };
};

nil