/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn hostile unit to attack target

Arguments:
0: target player <OBJECT>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"
#define BOMBS ["R_TBG32V_F","HelicopterExploSmall"]
#define BOMB_RANGE 15
#define SOUNDPATH "A3\Sounds_F\sfx\Beep_Target.wss"
#define TYPEMAX 2
#define SAFE_DIST 50
#define REBEL_COUNT 6
#define REBEL_UNIFORMS ["U_I_C_Soldier_Bandit_3_F","U_I_C_Soldier_Bandit_5_F","U_I_C_Soldier_Bandit_2_F"]

private _player = _this select 0;
private _ret = false;
private _hostilePos = [];
private _pos = getPos _player;
private _type = floor random (TYPEMAX + 1);
private _nearPlayers = [_pos,SAFE_DIST] call EFUNC(main,getNearPlayers);

{
    if ([_x,SAFE_DIST] call EFUNC(main,getNearPlayers) isEqualTo []) exitWith {
        _hostilePos = _x;
    };
} forEach ([_pos,64,512,256,4,0] call EFUNC(main,findPosGrid));

if (_hostilePos isEqualTo []) exitWith {
    WARNING("Hostile spawn position empty");
    _ret
};

// set z height to average eyePos
_hostilePos set [2,(getTerrainHeightASL _hostilePos) + 1.5];

if ({[_hostilePos,eyePos _x] call EFUNC(main,inLOS)} count _nearPlayers > 0) exitWith {
    WARNING("Hostile position in line of sight");
    _ret
};

call {
    if (_type isEqualTo 0) exitWith {
        private _unitPool = [];
        private _tempGrp = createGroup EGVAR(main,enemySide);

        call {
            if (EGVAR(main,enemySide) isEqualTo EAST) exitWith {
                _unitPool = EGVAR(main,unitsEast);
            };
            if (EGVAR(main,enemySide) isEqualTo WEST) exitWith {
                _unitPool = EGVAR(main,unitsWest);
            };
            _unitPool = EGVAR(main,unitsInd);
        };

        (selectRandom _unitPool) createUnit [DEFAULT_SPAWNPOS, _tempGrp];
        private _vest = vest (leader _tempGrp);
        private _weapon = currentWeapon (leader _tempGrp);
        private _mags = magazines (leader _tempGrp);

        deleteVehicle (leader _tempGrp);

        private _grp = [_hostilePos,0,REBEL_COUNT,CIVILIAN,1] call EFUNC(main,spawnGroup);

        [
            {count units (_this select 0) >= REBEL_COUNT},
            {
                params ["_grp","_pos","_vest","_weapon","_mags"];

                {
                    _x addUniform (selectRandom REBEL_UNIFORMS);
                } forEach units _grp;

                _grp = [units _grp] call EFUNC(main,setSide);

                [_grp] call EFUNC(cache,disableCache);

                {
                    _y = _x;
                    _y addVest _vest;
                    _y addWeapon _weapon;
                    {_y addMagazine _x} forEach _mags;
                } forEach units _grp;

                _wp = _grp addWaypoint [_pos,0];
                _wp setWaypointBehaviour "AWARE";
                _wp setWaypointFormation "STAG COLUMN";
                _cond = "!(behaviour this isEqualTo ""COMBAT"")";
                _wp setWaypointStatements [_cond, format ["thisList call %1;",QEFUNC(main,cleanup)]];

                INFO_1("Rebels spawned at %1",getPos leader _grp);
            },
            [_grp,_pos,_vest,_weapon,_mags]
        ] call CBA_fnc_waitUntilAndExecute;

        _ret = true;
    };

    if (_type isEqualTo 1) exitWith {
        if (EGVAR(civilian,drivers) isEqualTo []) exitWith {
            WARNING("No drivers available to turn hostile");
        };

        private _driver = objNull;

        {
            if (CHECK_DIST2D(getPos _x,_pos,2000)) exitWith {
                _driver = _x;
            };
        } forEach EGVAR(civilian,drivers);

        if !(isNull _driver) then {
            {
                if !(_x isEqualTo _driver) then {
                    deleteVehicle _x;
                };
            } forEach crew (vehicle _driver);

            private _wp = [group _driver, currentWaypoint group _driver];
            _wp setWaypointPosition [getpos _driver,0];

            [
                {
                    params ["_player","_driver","_wp"];

                    deleteWaypoint _wp;

                    _driver addUniform (selectRandom REBEL_UNIFORMS);

                    _grp = [[_driver]] call EFUNC(main,setSide);

                    [_grp] call EFUNC(cache,disableCache);

                    _unit = leader _grp;
                    _unit removeAllEventHandlers "firedNear";
                    _unit addEventHandler ["Hit", {
                        "HelicopterExploSmall" createVehicle ((_this select 0) modeltoworld [0,0,0]);
                        (_this select 0) removeAllEventHandlers "Hit";
                    }];

                    _unit setBehaviour "CARELESS";
                    _unit allowfleeing 0;
                    _unit addVest "V_TacVestIR_blk";
                    _wp = (group _unit) addWaypoint [getPos _player, 0];
                    _wp setWaypointSpeed "FULL";

                    [group _unit,_wp,_player,6] call EFUNC(main,setWaypointPos);

                    [{
                        params ["_args","_idPFH"];
                        _args params ["_unit","_player"];

                        if !(alive _unit) exitWith {
                            [_idPFH] call CBA_fnc_removePerFrameHandler;
                        };
                        if ((vehicle _unit) distance _player <= BOMB_RANGE) exitWith {
                            [_idPFH] call CBA_fnc_removePerFrameHandler;
                            (selectRandom BOMBS) createVehicle (getPosATL (vehicle _unit));
                            deleteVehicle (vehicle _unit);
                        };
                    }, 0.1, [_unit,_player]] call CBA_fnc_addPerFrameHandler;

                    INFO_1("Suicide vehicle spawned at %1", getPos _unit);
                },
                [_player,_driver,_wp],
                5
            ] call CBA_fnc_waitAndExecute;

            _ret = true;
        };
    };

    if (_type isEqualTo 2) exitWith {
        private _grp = createGroup CIVILIAN;
        (selectRandom EGVAR(main,unitsCiv)) createUnit [_hostilePos, _grp];

        (leader _grp) addUniform (selectRandom REBEL_UNIFORMS);

        _grp = [[leader _grp]] call EFUNC(main,setSide);

        [_grp] call EFUNC(cache,disableCache);
        
        private _unit = leader _grp;
        _unit removeAllEventHandlers "firedNear";
        _unit addEventHandler ["Hit", {
            "HelicopterExploSmall" createVehicle ((_this select 0) modeltoworld [0,0,0]);
            (_this select 0) removeAllEventHandlers "Hit";
        }];

        _unit enableStamina false;
        _unit setBehaviour "CARELESS";
        _unit allowfleeing 0;
        _unit addVest "V_TacVestIR_blk";
        _wp = (group _unit) addWaypoint [_pos, 0];
        _wp setWaypointSpeed "FULL";

        [group _unit,_wp,_player,6] call EFUNC(main,setWaypointPos);

        [{
            params ["_args","_idPFH"];
            _args params ["_unit","_player"];

            if !(alive _unit) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
            };
            if (CHECK_DIST(_unit,_player,BOMB_RANGE)) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                (selectRandom BOMBS) createVehicle (getPosATL _unit);
                deleteVehicle _unit;
            };
        }, 0.1, [_unit,_player]] call CBA_fnc_addPerFrameHandler;

        INFO_1("Suicide bomber spawned at %1", getPos _unit);

        _ret = true;
    };
};

_ret
