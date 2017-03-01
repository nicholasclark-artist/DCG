#define COMPONENT occupy

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define UNITVAR QUOTE(DOUBLES(ADDON,unit))
#define SET_UNITVAR(OBJ) (OBJ) setVariable [UNITVAR,true]
#define GET_UNITVAR(OBJ) (OBJ) getVariable [UNITVAR,false]
#define SPAWN_DELAY 1
#define PATROL_UNITCOUNT 2
#define VEH_SPAWN_CHANCE 0.5

#define PREP_INF(POS,GRID,COUNT,SIZE) \
    private _grp = [ASLtoAGL (selectRandom GRID),0,COUNT,EGVAR(main,enemySide),true,SPAWN_DELAY] call EFUNC(main,spawnGroup); \
    [ \
    	{count units (_this select 1) >= (_this select 3)}, \
    	{ \
            params ["_pos","_grp","_size"];  \
            { \
                SET_UNITVAR(_x); \
                false \
            } count units _grp; \
            [ \
                _grp, \
                PATROL_UNITCOUNT, \
                {[_this select 0, _this select 1, _this select 2, 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "if (random 1 < 0.15) then {this spawn CBA_fnc_searchNearby}", [0,10,15]] call CBA_fnc_taskPatrol}, \
                [_pos,_size], \
                0, \
                0.1 \
            ] call EFUNC(main,splitGroup); \
    	}, \
    	[POS,_grp,SIZE,COUNT] \
    ] call CBA_fnc_waitUntilAndExecute

#define PREP_VEH(POS,GRID,COUNT,SIZE) \
    private _check = []; \
    [{ \
        params ["_args","_idPFH"]; \
        _args params ["_pos","_grid","_count","_size","_check"]; \
        if (_grid isEqualTo [] || {count _check >= _count}) exitWith { \
            [_idPFH] call CBA_fnc_removePerFrameHandler; \
        }; \
        private _gridPos = ASLtoAGL (selectRandom _grid); \
        private _grp = [_gridPos,1,1,EGVAR(main,enemySide),false,SPAWN_DELAY,true] call EFUNC(main,spawnGroup); \
        _grid deleteAt (_grid find _gridPos); \
        [ \
            {{_x getVariable [ISDRIVER,false]} count units (_this select 0) >= 1}, \
            { \
                params ["_grp","_size","_pos"]; \
                (vehicle leader _grp) addEventHandler ["Fuel",{if !(_this select 1) then {(_this select 0) setFuel 1}}]; \
                SET_UNITVAR(leader _grp); \
                [_grp, _pos, _size, 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [10,20,30]] call CBA_fnc_taskPatrol; \
            }, \
            [_grp,_size,_pos] \
        ] call CBA_fnc_waitUntilAndExecute; \
        _check pushBack 0; \
    }, SPAWN_DELAY, [POS,GRID,COUNT,SIZE,_check]] call CBA_fnc_addPerFrameHandler

#define PREP_AIR(POS,COUNT) \
    private _check = []; \
    [{ \
        params ["_args","_idPFH"]; \
        _args params ["_pos","_count","_check"]; \
        if (count _check >= _count) exitWith { \
            [_idPFH] call CBA_fnc_removePerFrameHandler; \
        }; \
        private _grp = [_pos,2,1,EGVAR(main,enemySide),false,SPAWN_DELAY] call EFUNC(main,spawnGroup); \
        [ \
            {{_x getVariable [ISDRIVER,false]} count units (_this select 0) >= 1}, \
            { \
                params ["_grp","_pos"]; \
                SET_UNITVAR(leader _grp); \
                [_grp, _pos, 1000, 4, "MOVE", "SAFE", "YELLOW", "NORMAL", "STAG COLUMN", "", [0,0,0]] call CBA_fnc_taskPatrol; \
            }, \
            [_grp,_pos] \
        ] call CBA_fnc_waitUntilAndExecute; \
        _check pushBack 0; \
    }, SPAWN_DELAY, [POS,COUNT,_check]] call CBA_fnc_addPerFrameHandler

#define PREP_STATIC(POS,COUNT,SIZE,GRID,ARRAY) \
    if (GVAR(static) && {!(GRID isEqualTo [])}) then { \
    	private _static = [POS, SIZE, ceil random COUNT, EGVAR(main,enemySide),GRID] call EFUNC(main,spawnStatic); \
    	ARRAY append (_static select 1); \
    }

#define PREP_SNIPER(POS,COUNT,SIZE) \
    if (GVAR(sniper)) then { \
    	[POS,ceil random COUNT,SIZE,SIZE+500] call EFUNC(main,spawnSniper); \
    }
