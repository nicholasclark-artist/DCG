#define COMPONENT occupy

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define UNITVAR QUOTE(DOUBLES(ADDON,unit))
#define SET_UNITVAR(OBJ) (OBJ) setVariable [UNITVAR,true]
#define GET_UNITVAR(OBJ) (OBJ) getVariable [UNITVAR,false]
#define SPAWN_DELAY 0.75
#define PATROL_UNITCOUNT 4
#define VEH_SPAWN_CHANCE 0.75

#define PREP_INF(POS,GRID,COUNT,GARRISON_COUNT,SIZE) \
    private _grp = [ASLtoAGL (selectRandom GRID),0,COUNT,EGVAR(main,enemySide),false,SPAWN_DELAY] call EFUNC(main,spawnGroup); \
    [ \
    	{count units (_this select 1) >= (_this select 3)}, \
    	{ \
            params ["_pos","_grp","_size","_strength","_garrisonCount"];  \
            _garrisonGrp = createGroup EGVAR(main,enemySide); \
            ((units _grp) select [0,_garrisonCount]) joinSilent _garrisonGrp; \
            [_garrisonGrp,_pos,_size,1,false] call CBA_fnc_taskDefend; \
            for "_i" from 0 to (count units _grp) - 1 step PATROL_UNITCOUNT do { \
                _patrolGrp = createGroup EGVAR(main,enemySide); \
                ((units _grp) select [0,PATROL_UNITCOUNT]) joinSilent _patrolGrp; \
                [_patrolGrp, _pos, _size, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "if (random 1 < 0.2) then {this spawn CBA_fnc_searchNearby}", [0,5,8]] call CBA_fnc_taskPatrol; \
            }; \
    	}, \
    	[POS,_grp,SIZE,COUNT,GARRISON_COUNT] \
    ] call CBA_fnc_waitUntilAndExecute

#define PREP_VEH(POS,GRID,COUNT,SIZE) \
    for "_i" from 0 to (COUNT) - 1 do { \
        if (GRID isEqualTo []) exitWith {}; \
        if (random 1 < VEH_SPAWN_CHANCE) then { \
            private _gridPos = ASLtoAGL (selectRandom GRID); \
            private _grp = [_gridPos,1,1,EGVAR(main,enemySide),false,SPAWN_DELAY,true] call EFUNC(main,spawnGroup); \
            GRID deleteAt (GRID find _gridPos); \
            [ \
                {{_x getVariable [ISDRIVER,false]} count units (_this select 0) >= 1}, \
                { \
                    params ["_grp","_size","_center"]; \
                    [_grp, _center, _size, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [5,10,15]] call CBA_fnc_taskPatrol; \
                    { \
                        if (_x getVariable [ISDRIVER,false]) then { \
                            SET_UNITVAR(_x); \
                        }; \
                        false \
                    } count units _grp; \
                }, \
                [_grp,SIZE,POS] \
            ] call CBA_fnc_waitUntilAndExecute; \
        }; \
    }

#define PREP_AIR(POS,COUNT) \
    for "_i" from 0 to (COUNT) - 1 do { \
        if (random 1 < VEH_SPAWN_CHANCE) then { \
            private _grp = [POS,2,1,EGVAR(main,enemySide),false,SPAWN_DELAY] call EFUNC(main,spawnGroup); \
            [ \
                {{_x getVariable [ISDRIVER,false]} count units (_this select 0) >= 1}, \
                { \
                    params ["_grp","_center"]; \
                    [_grp] call CBA_fnc_clearWaypoints; \
                    private _waypoint = _grp addWaypoint [_center,0]; \
                    _waypoint setWaypointType "LOITER"; \
                    _waypoint setWaypointLoiterRadius (500 + random 500); \
                    _waypoint setWaypointLoiterType "CIRCLE"; \
                    _waypoint setWaypointSpeed "NORMAL"; \
                    _waypoint setWaypointBehaviour "AWARE"; \
                    { \
                        if (_x getVariable [ISDRIVER,false]) then { \
                            SET_UNITVAR(_x); \
                        }; \
                        false \
                    } count units _grp; \
                }, \
                [_grp,POS] \
            ] call CBA_fnc_waitUntilAndExecute; \
        }; \
    }

#define PREP_STATIC(POS,COUNT,SIZE,GRID,ARRAY) \
    if (GVAR(static) && {!(GRID isEqualTo [])}) then { \
    	private _static = [POS, SIZE, ceil random COUNT, EGVAR(main,enemySide),GRID] call EFUNC(main,spawnStatic); \
    	ARRAY append (_static select 1); \
    }

#define PREP_SNIPER(POS,COUNT,SIZE) \
    if (GVAR(sniper)) then { \
    	[POS,ceil random COUNT,SIZE,SIZE+500] call EFUNC(main,spawnSniper); \
    }
