/*
Author:
Nicholas Clark (SENSEI)

Description:
runs when players enter occupied location

Arguments:
0: location data <ARRAY>
1: enemy count at the time player enters location <NUMBER>
2: vfx objects <ARRAY>
3: officer unit <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define INTERVAL 30
#define SURRENDER_VAR(SURNAME) [QUOTE(ADDON),SURNAME] joinString "_"
#define SURRENDER_CHANCE 0.3
#define REINFORCE_CHANCE 0.1
#define ENTITY ["CAManBase","LandVehicle","Air","Ship"]
#define ENEMYMAX_MULTIPLIER 0.5

params ["_name","_center","_size","_type","_objArray","_mrkArray"];

missionNamespace setVariable [SURRENDER_VAR(_name),false];

private _maxCount = 0;

{
    if (GET_UNITVAR(driver _x)) then {
        _maxCount = _maxCount + 1;
    };
    false
} count (_center nearEntities [ENTITY, _size]);

[{
    params ["_args","_idPFH"];
    _args params ["_name","_center"];

    // exit if enemy surrenders
    if (missionNamespace getVariable [SURRENDER_VAR(_name),false]) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (random 1 < REINFORCE_CHANCE) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        [_center,EGVAR(main,enemySide)] spawn EFUNC(main,spawnReinforcements);
    };
}, 60, [_name,_center]] call CBA_fnc_addPerFrameHandler;

[{
    params ["_args","_idPFH"];
    _args params ["_name","_center","_size","_type","_objArray","_mrkArray","_maxCount"];

    _entities = _center nearEntities [ENTITY, _size];
    _count = count (_entities select {side _x isEqualTo EGVAR(main,enemySide)});

    // if enemy has lost a certain amount of units, move to next phase
    if (_count <= _maxCount*ENEMYMAX_MULTIPLIER) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        ["TaskUpdated",["",format ["The enemy is losing control of %1! Keep up the fight and they may surrender!",_name]]] remoteExecCall [QUOTE(BIS_fnc_showNotification), allPlayers, false];
        EGVAR(patrol,blacklist) pushBack [_center,_size]; // stop patrols from spawning in town

        [{
            params ["_args","_idPFH"];
            _args params ["_name","_center","_size","_type","_objArray","_mrkArray","_maxCount"];

            // start scores at 1 to avoid zero divisor
            _friendlyScore = 1;
            _enemyScore = 1;

            // get scores for all units in town
            _entities = _center nearEntities [ENTITY, _size];
            _friendlies = _entities select {side _x isEqualTo EGVAR(main,playerSide)};
            _enemies = _entities select {side _x isEqualTo EGVAR(main,enemySide)};

            _friendlyScore = _friendlyScore + count (_friendlies select {isNull (objectParent _x)}); // add infantry score
            _friendlyScore = _friendlyScore + (count (_friendlies select {!(isNull (objectParent _x))})) * 2; // add vehicle score

            _enemyScore = _enemyScore + count (_enemies select {isNull (objectParent _x)});
            _enemyScore = _enemyScore + (count (_enemies select {!(isNull (objectParent _x))})) * 2;

            // get chance for enemies to surrender, surrender chance is capped
            _chanceSurrender = (_friendlyScore/_enemyScore) min SURRENDER_CHANCE;
            LOG_4("E_Score: %1, F_Score: %2, E_Count: %3, S_Chance: %4",_enemyScore,_friendlyScore,count _enemies,_chanceSurrender);

            if (count _enemies isEqualTo 0 || {_enemyScore <= _friendlyScore && (random 1 < _chanceSurrender)}) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                missionNamespace setVariable [SURRENDER_VAR(_name),true];
                ["TaskSucceeded",["",format ["%1 Liberated!",_name]]] remoteExecCall [QUOTE(BIS_fnc_showNotification), allPlayers, false];

                {
                    if !(typeOf (vehicle _x) isKindOf "AIR") then {
                        [vehicle _x] call EFUNC(main,setSurrender);
                        _x call EFUNC(main,cleanup);
                    } else {
                        _x setBehaviour "CARELESS";
                        (vehicle _x) call EFUNC(main,cleanup);
                    };
                } forEach _enemies;

                if (CHECK_ADDON_2(approval)) then {
                    if (_type isEqualTo "NameCityCapital") exitWith {
                        [_center,AP_CAPITAL] call EFUNC(approval,addValue);
                    };
                    if (_type isEqualTo "NameCity") exitWith {
                        [_center,AP_CITY] call EFUNC(approval,addValue);
                    };
                    [_center,AP_VILLAGE] call EFUNC(approval,addValue);
                };

                {
                    if (_x getVariable [QUOTE(DOUBLES(ADDON,wreck)),false]) then {
                        [getPos _x] call EFUNC(main,removeParticle);
                    };
                    deleteVehicle _x;
                } forEach _objArray;
                _mrkArray call CBA_fnc_deleteEntity;

                GVAR(location) = [];
                EGVAR(patrol,blacklist) deleteAt (EGVAR(patrol,blacklist) find [_center,_size]);
                [{
                    EGVAR(civilian,blacklist) deleteAt (EGVAR(civilian,blacklist) find _this);
                }, _name, 300] call CBA_fnc_waitAndExecute;

                // setup next occupied location
                [FUNC(findLocation), [], GVAR(cooldown)] call CBA_fnc_waitAndExecute;
            };
        }, INTERVAL, _args] call CBA_fnc_addPerFrameHandler;
    };
}, INTERVAL, [_name,_center,_size,_type,_objArray,_mrkArray,_maxCount]] call CBA_fnc_addPerFrameHandler;
