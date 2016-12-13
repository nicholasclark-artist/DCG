#define COMPONENT occupy

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define UNITVAR QUOTE(DOUBLES(ADDON,unit))
#define SET_UNITVAR(OBJ) (OBJ) setVariable [UNITVAR,true]
#define GET_UNITVAR(OBJ) (OBJ) getVariable [UNITVAR,false]
#define SPAWN_DELAY 0.5

#define PREP_INF(POS,UNIT_COUNT,SIZE) \
	_grp = [POS,0,UNIT_COUNT,EGVAR(main,enemySide),false,SPAWN_DELAY] call EFUNC(main,spawnGroup); \
	[ \
		{count units (_this select 0) >= (_this select 1)}, \
		{ \
			params ["_grp","_count","_size"]; \
			[_grp,_size] call EFUNC(main,setPatrol); \
			{ \
				SET_UNITVAR(_x); \
				false \
			} count units _grp; \
		}, \
		[_grp,UNIT_COUNT,SIZE] \
	] call CBA_fnc_waitUntilAndExecute

#define PREP_VEH(POS,UNIT_COUNT,SIZE,CHANCE) \
	if (random 1 < CHANCE) then { \
		_grid = [POS,25,150,0,8,false,false] call EFUNC(main,findPosGrid); \
		if !(_grid isEqualTo []) then { \
			_grp = [ASLtoAGL (selectRandom _grid),1,UNIT_COUNT,EGVAR(main,enemySide),false,SPAWN_DELAY,true] call EFUNC(main,spawnGroup); \
			[ \
				{{_x getVariable [ISDRIVER,false]} count units (_this select 0) >= (_this select 1)}, \
				{ \
					params ["_grp","_count","_size"]; \
					{ \
						if (_x getVariable [ISDRIVER,false]) then { \
							SET_UNITVAR(_x); \
						}; \
						false \
					} count (units _grp); \
					[_grp,_size*2] call EFUNC(main,setPatrol); \
				}, \
				[_grp,UNIT_COUNT,SIZE] \
			] call CBA_fnc_waitUntilAndExecute; \
		}; \
	}

#define PREP_AIR(POS,UNIT_COUNT,CHANCE) \
	if (random 1 < CHANCE) then { \
		_grp = [POS,2,UNIT_COUNT,EGVAR(main,enemySide),false,SPAWN_DELAY] call EFUNC(main,spawnGroup); \
		[ \
			{{_x getVariable [ISDRIVER,false]} count units (_this select 0) >= (_this select 1)}, \
			{ \
				params ["_grp"]; \
				{ \
					if (_x getVariable [ISDRIVER,false]) then { \
						SET_UNITVAR(_x); \
					}; \
					false \
				} count (units _grp); \
				[_grp,1000] call EFUNC(main,setPatrol); \
			}, \
			[_grp,UNIT_COUNT] \
		] call CBA_fnc_waitUntilAndExecute; \
	}

#define PREP_GARRISON(POS,MAX_COUNT,SIZE,POOL) \
    _houses = []; \
    _tempHouses = POS nearObjects ["House", SIZE]; \
    { \
        if !((_x buildingPos -1) isEqualTo []) then { \
            _houses pushBack _x; \
        }; \
    } forEach _tempHouses; \
    _grp = [POS,0,count _houses min MAX_COUNT,EGVAR(main,enemySide),true,SPAWN_DELAY] call EFUNC(main,spawnGroup); \
    [ \
        {count units (_this select 0) >= (_this select 2)}, \
        { \
            params ["_grp","_houses"]; \
            { \
                _posArray = (selectRandom _houses) buildingPos -1; \
                _x setDir random 360; \
                _x setPosATL (selectRandom _posArray); \
                _x disableAI "PATH"; \
            } forEach (units _grp); \
        }, \
        [_grp,_houses,count _houses min MAX_COUNT] \
    ] call CBA_fnc_waitUntilAndExecute

#define PREP_STATIC(POS,COUNT,SIZE,ARRAY) \
	_static = [POS, SIZE, COUNT] call EFUNC(main,spawnStatic); \
	ARRAY append (_static select 1)

#define PREP_SNIPER(POS,MAX_COUNT,SIZE) \
	[POS,ceil random MAX_COUNT,SIZE,SIZE+700] call EFUNC(main,spawnSniper)
