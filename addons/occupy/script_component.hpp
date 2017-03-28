#define COMPONENT occupy
#define COMPONENT_PRETTY Occupy

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define UNITVAR QUOTE(DOUBLES(ADDON,unit))
#define SET_UNITVAR(OBJ) (OBJ) setVariable [UNITVAR,true]
#define GET_UNITVAR(OBJ) (OBJ) getVariable [UNITVAR,false]
#define SPAWN_DELAY 1
#define PATROL_UNITCOUNT 2
#define ITERATIONS 3000

#define PREP_INF(CENTER,COUNT,SIZE) \
    [CENTER,COUNT,SIZE] spawn { \
        params ["_center","_count","_size"]; \
        _pos = []; \
        _time = diag_tickTime; \
        if !([_center,4,0] call EFUNC(main,isPosSafe)) then { \
            for "_i" from 0 to ITERATIONS do { \
                _pos = [_center,0,_size,4,0] call EFUNC(main,findPosSafe); \
                if !(_pos isEqualTo _center) exitWith {INFO("Safe infantry position found")}; \
                sleep 0.1; \
            }; \
        } else { \
            _pos = _center; \
        }; \
        private _grp = [ASLtoAGL _pos,0,_count,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup); \
        waitUntil {count units _grp >= _count || diag_tickTime > _time + ((SPAWN_DELAY * _count) * 2)}; \
        if (count units _grp < _count) then { WARNING_2("Infantry count is low (%1 - %2)",_count,count units _grp) }; \
        { SET_UNITVAR(_x); false } count units _grp; \
        [ \
            _grp, \
            PATROL_UNITCOUNT, \
            {[_this select 0, _this select 1, _this select 2, 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "if (random 1 < 0.15) then {this spawn CBA_fnc_searchNearby}", [0,10,15]] call CBA_fnc_taskPatrol}, \
            [_center,_size], \
            0, \
            0.1 \
        ] call EFUNC(main,splitGroup); \
        INFO("Prep infantry finished"); \
    }

#define PREP_VEH(CENTER,COUNT,SIZE) \
    [CENTER,COUNT,SIZE] spawn { \
        params ["_center","_count","_size"]; \
        _posArray = []; \
        for "_i" from 0 to ITERATIONS do { \
            _pos = [_center,0,_size,SAFE_DIST,0] call EFUNC(main,findPosSafe); \
            if !(_pos isEqualTo _center) then { _posArray pushBack _pos }; \
            if (count _posArray >= _count) exitWith {}; \
            sleep 0.1; \
        }; \
        if (_posArray isEqualTo []) then { WARNING("Cannot find suitable positions for vehicles") }; \
        { \
            _grp = [ASLtoAGL _x,1,1,EGVAR(main,enemySide),SPAWN_DELAY,true] call EFUNC(main,spawnGroup); \
            waitUntil {{_x getVariable [ISDRIVER,false]} count units _grp >= 1}; \
            (objectParent leader _grp) addEventHandler ["Fuel",{if !(_this select 1) then {(_this select 0) setFuel 1}}]; \
            SET_UNITVAR(leader _grp); \
            [_grp, _center, _size, 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [10,20,30]] call CBA_fnc_taskPatrol; \
            sleep 0.1; \
        } forEach _posArray; \
        INFO("Prep land vehicles finished"); \
    }

#define PREP_AIR(CENTER,COUNT) \
    [CENTER,COUNT] spawn { \
        params ["_center","_count"]; \
        for "_i" from 1 to _count do { \
            _grp = [ASLtoAGL _center,2,1,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup); \
            waitUntil {{_x getVariable [ISDRIVER,false]} count units _grp >= 1}; \
            (objectParent leader _grp) addEventHandler ["Fuel",{if !(_this select 1) then {(_this select 0) setFuel 1}}]; \
            SET_UNITVAR(leader _grp); \
            _wp = _grp addWaypoint [_center, 0]; \
            _wp setWaypointType "LOITER"; \
            _wp setWaypointLoiterType "CIRCLE_L"; \
            _wp setWaypointLoiterRadius (500 + random 500); \
            sleep 1; \
        }; \
        INFO("Prep air vehicles finished"); \
    }

#define PREP_STATIC(CENTER,COUNT,SIZE,ARRAY) \
    if (GVAR(static)) then { \
        _static = [CENTER,SIZE,ceil random COUNT,EGVAR(main,enemySide)] call EFUNC(main,spawnStatic); \
        ARRAY append (_static select 1); \
        INFO("Prep statics finished"); \
    }

#define PREP_SNIPER(POS,COUNT,SIZE) \
    if (GVAR(sniper)) then { \
    	[POS,ceil random COUNT,SIZE,SIZE+500] call EFUNC(main,spawnSniper); \
        INFO("Prep snipers finished"); \
    }
