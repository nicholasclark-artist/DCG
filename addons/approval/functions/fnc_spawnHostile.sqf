/*
Author:
Nicholas Clark (SENSEI)

Description:
send hostile unit to attack target

Arguments:
0: target player <OBJECT>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"
#define BOMBS ["R_TBG32V_F","HelicopterExploSmall"]
#define BOMB_RANGE 15
#define SAFE_DIST 50
#define REBEL_COUNT 6
#define REBEL_UNIFORMS ["U_I_C_Soldier_Bandit_3_F","U_I_C_Soldier_Bandit_5_F","U_I_C_Soldier_Bandit_2_F"]

private _player = _this select 0;
private _pos = getPos _player;
private _isPosGood = true;
private _hostilePos = selectRandom (([_pos,64,512,256,4,0] call EFUNC(main,findPosGrid)) select {[_x,SAFE_DIST] call EFUNC(main,getNearPlayers) isEqualTo []});
private _nearPlayers = [_pos,SAFE_DIST] call EFUNC(main,getNearPlayers);

// check if hostile position found, check if hostile position in line of sight (at average eye height)
_isPosGood = if (isNil "_hostilePos" || {(_nearPlayers findIf {[_hostilePos vectorAdd [0,0,1.5],eyePos _x] call EFUNC(main,inLOS)}) > -1}) then {
    false
};

switch (floor random 3) do {
    case 0: { // rebels
        if (!_isPosGood) exitWith {
            WARNING("cannot find suitable rebel spawn position");
            false
        };

        // get loadout from temp unit
        private _tempGrp = createGroup EGVAR(main,enemySide);
        (selectRandom ([EGVAR(main,enemySide),0] call EFUNC(main,getPool))) createUnit [DEFAULT_SPAWNPOS, _tempGrp];
        private _vest = vest (leader _tempGrp);
        private _weapon = currentWeapon (leader _tempGrp);
        private _mags = magazines (leader _tempGrp);

        deleteVehicle (leader _tempGrp);

        // spawn civs
        private _grp = [_hostilePos,0,REBEL_COUNT,CIVILIAN,1] call EFUNC(main,spawnGroup);

        [
            {count units (_this select 0) >= REBEL_COUNT},
            {
                params ["_grp","_pos","_vest","_weapon","_mags"];

                // equip rebel uniforms
                {
                    _x addUniform (selectRandom REBEL_UNIFORMS);
                } forEach units _grp;

                // set enemy side
                _grp = [units _grp] call EFUNC(main,setSide);
                [QEGVAR(cache,disableGroup),_grp] call CBA_fnc_serverEvent;

                // equip civs with enemy loadout
                {
                    _y = _x;
                    _y addVest _vest;
                    _y addWeapon _weapon;
                    {_y addMagazine _x} forEach _mags;
                } forEach units _grp;

                // send to target
                _wp = _grp addWaypoint [_pos,0];
                _wp setWaypointBehaviour "AWARE";
                _wp setWaypointFormation "STAG COLUMN";
                _wp setWaypointStatements ["!(behaviour this isEqualTo ""COMBAT"")", format ["['%1',thisList] call CBA_fnc_serverEvent",QEGVAR(main,cleanup)]];
                
                INFO_1("rebels spawned at %1",getPos leader _grp);
            },
            [_grp,_pos,_vest,_weapon,_mags]
        ] call CBA_fnc_waitUntilAndExecute;

        true
    };
    case 1: { // hostile vehicle
        // get civ driver
        private _drivers = (allUnits select {side _x isEqualTo CIVILIAN}) select {!isNull (objectParent _x)};
        private _driver = _drivers findIf {CHECK_DIST2D(getPosATL _x,_pos,2000) && {!(CHECK_DIST2D(getPosATL _x,_pos,50))}};

        if (_driver < 0) exitWith {
            WARNING("cannot find suitable vehicle to turn hostile");
            false
        };

        _driver = _drivers select _driver;

        // check locality
        if !(local _driver) exitWith {
            WARNING("hostile vehicle not local");
            false
        };

        // check for players in vehicle
        if (crew (objectParent _driver) findIf {isPlayer _x} > -1) exitWith {
            WARNING("player in hostile vehicle");
            false
        };

        // remove other units in vehicle
        {
            if !(_x isEqualTo _driver) then {
                (objectParent _driver) deleteVehicleCrew _x;
            };
        } forEach crew (objectParent _driver);

        // stop driver
        private _wp = [group _driver, currentWaypoint group _driver];
        _wp setWaypointPosition [getpos _driver,0];

        [
            {
                params ["_player","_driver","_wp"];

                deleteWaypoint _wp;

                // turn hostile
                _grp = [[_driver]] call EFUNC(main,setSide);
                [QEGVAR(cache,disableGroup),_grp] call CBA_fnc_serverEvent;
                _driver = leader _grp;

                // set loadout
                _driver addUniform (selectRandom REBEL_UNIFORMS);
                _driver addVest "V_TacVestIR_blk";

                // eventhandlers
                _driver removeAllEventHandlers "firedNear";

                // event to detonate prematurely if hit
                (objectParent _driver) addEventHandler ["Hit", { 
                    if (PROBABILITY(0.1)) then {
                        "HelicopterExploSmall" createVehicle ((_this select 0) modeltoworld [0,0,0]);
                        (_this select 0) removeAllEventHandlers "Hit";
                    };
                }];
                
                // set behaviors
                _driver setBehaviour "CARELESS";
                _driver disableAI "FSM";
                _driver allowFleeing 0;
                (objectParent _driver) allowCrewInImmobile true;
                
                // send to target
                _wp = (group _driver) addWaypoint [getPos _player, 0];
                _wp setWaypointSpeed "FULL";
                _wp setWaypointStatements ["true", format ["['%1',this] call CBA_fnc_serverEvent",QEGVAR(main,cleanup)]];
                
                // follow player
                [{
                    params ["_args","_idPFH"];
                    _args params ["_grp","_wp","_player"];

                    if (isNull _grp || {isNil "_player"}) exitWith {
                        [_idPFH] call CBA_fnc_removePerFrameHandler;
                    };
                    _wp setWaypointPosition [getPosASL _player, -1];
                }, 5, [group _driver,_wp,_player]] call CBA_fnc_addPerFrameHandler;

                // detonate hostile if close to target
                [
                    {CHECK_DIST(_this select 0,_this select 1,BOMB_RANGE)},
                    {
                        (selectRandom BOMBS) createVehicle (getPosATL (_this select 0));
                        (_this select 0) setDamage [1,false];
                    },
                    [objectParent _driver,_player],
                    600,
                    {
                        (_this select 0) call CBA_fnc_deleteEntity;
                        
                        INFO_1("hostile vehicle failed to reach target %1",_this select 1);
                    }
                ] call CBA_fnc_waitUntilAndExecute;

                INFO_1("hostile vehicle spawned at %1", getPos _driver);
            },
            [_player,_driver,_wp],
            5
        ] call CBA_fnc_waitAndExecute;

        true
    };
    
    case 2: { // hostile unit
        if (!_isPosGood) exitWith {
            WARNING("cannot find suitable hostile unit spawn position");
            false
        };

        // set hostile
        private _grp = createGroup CIVILIAN;
        (selectRandom EGVAR(main,unitsCiv)) createUnit [_hostilePos, _grp];
        _grp = [[leader _grp]] call EFUNC(main,setSide);
        [QEGVAR(cache,disableGroup),_grp] call CBA_fnc_serverEvent;
        
        private _unit = leader _grp;

        // set loadout
        _unit addUniform (selectRandom REBEL_UNIFORMS);
        _unit addVest "V_TacVestIR_blk";

        // eventhandlers
        _unit removeAllEventHandlers "firedNear";

        // event to detonate prematurely if hit
        _unit addEventHandler ["Hit", { 
            if (PROBABILITY(0.333)) then {
                "HelicopterExploSmall" createVehicle ((_this select 0) modeltoworld [0,0,0]);
                (_this select 0) removeAllEventHandlers "Hit";
            };
        }];

        // set behaviors 
        _unit enableStamina false;
        _unit setBehaviour "CARELESS";
        _unit allowFleeing 0;
        
        // send to target
        _wp = (group _unit) addWaypoint [_pos, 0];
        _wp setWaypointSpeed "FULL";
        _wp setWaypointStatements ["true", format ["['%1',this] call CBA_fnc_serverEvent",QEGVAR(main,cleanup)]];

        // follow player
        [{
            params ["_args","_idPFH"];
            _args params ["_grp","_wp","_player"];

            if (isNull _grp || {isNil "_player"}) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
            };
            _wp setWaypointPosition [getPosASL _player, -1];
        }, 5, [group _unit,_wp,_player]] call CBA_fnc_addPerFrameHandler;

        // detonate hostile if close to target
        [
            {CHECK_DIST(_this select 0,_this select 1,BOMB_RANGE)},
            {
                (selectRandom BOMBS) createVehicle (getPosATL (_this select 0));
                (_this select 0) call CBA_fnc_deleteEntity;
            },
            [_unit,_player],
            600,
            {
                (_this select 0) call CBA_fnc_deleteEntity;
                INFO_1("hostile unit failed to reach target %1",_this select 1);
            }
        ] call CBA_fnc_waitUntilAndExecute;

        INFO_1("hostile unit spawned at %1", getPos _unit);

        true
    };

    default {false};
};
