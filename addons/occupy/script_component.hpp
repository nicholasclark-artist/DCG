#define COMPONENT occupy

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_mod.hpp"
#include "\d\dcg\addons\main\script_macros.hpp"

#define UNITVAR QUOTE(DOUBLES(ADDON,unit))
#define SET_UNITVAR(OBJ) (OBJ) setVariable [QUOTE(DOUBLES(ADDON,unit)),true]
#define GET_UNITVAR(OBJ) (OBJ) getVariable [QUOTE(DOUBLES(ADDON,unit)),false]
#define SPAWN_DELAY 1.5

#define PREP_INF(POS,UNIT_COUNT,SIZE) \
	_grp = [POS,0,UNIT_COUNT,EGVAR(main,enemySide),false,SPAWN_DELAY] call EFUNC(main,spawnGroup); \
	[ \
		{count units (_this select 0) >= (_this select 1)}, \
		{ \
			params ["_grp"]; \
			[units _grp,SIZE] call EFUNC(main,setPatrol); \
			{ \
				SET_UNITVAR(_x); \
				false \
			} count units _grp; \
		}, \
		[_grp,UNIT_COUNT] \
	] call CBA_fnc_waitUntilAndExecute

#define PREP_VEH(POS,UNIT_COUNT,SIZE,CHANCE) \
	if (random 1 < CHANCE) then { \
		_grid = [POS,25,100,0,8,false,false] call EFUNC(main,findPosGrid); \
		if !(_grid isEqualTo []) then { \
			_grp = [selectRandom _grid,1,UNIT_COUNT,EGVAR(main,enemySide),false,SPAWN_DELAY,true] call EFUNC(main,spawnGroup); \
			[ \
				{{_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]} count units (_this select 0) >= (_this select 1)}, \
				{ \
					params ["_grp"]; \
					_drivers = []; \
					{ \
						if (_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]) then { \
							_drivers pushBack _x; \
							SET_UNITVAR(_x); \
						}; \
						false \
					} count (units _grp); \
					[_drivers,SIZE*2] call EFUNC(main,setPatrol); \
				}, \
				[_grp,UNIT_COUNT] \
			] call CBA_fnc_waitUntilAndExecute; \
		}; \
	}

#define PREP_AIR(POS,UNIT_COUNT,CHANCE) \
	if (random 1 < CHANCE) then { \
		_grp = [POS,2,UNIT_COUNT,EGVAR(main,enemySide),false,SPAWN_DELAY] call EFUNC(main,spawnGroup); \
		[ \
			{{_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]} count units (_this select 0) >= (_this select 1)}, \
			{ \
				params ["_grp"]; \
				_drivers = []; \
				{ \
					if (_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]) then { \
						_drivers pushBack _x; \
						SET_UNITVAR(_x); \
					}; \
					false \
				} count (units _grp); \
				[_drivers,2000] call EFUNC(main,setPatrol); \
			}, \
			[_grp,UNIT_COUNT] \
		] call CBA_fnc_waitUntilAndExecute; \
	}

#define PREP_GARRISON(POS,MAX_COUNT,SIZE,POOL) \
	_houses = POS nearObjects ["House", SIZE]; \
	if !(_houses isEqualTo []) then { \
		_grp = createGroup EGVAR(main,enemySide); \
		CACHE_DISABLE(_grp,true); \
		for "_i" from 1 to MAX_COUNT do { \
			_posArray = (selectRandom _houses) buildingPos -1; \
			if !(_posArray isEqualTo []) then { \
				_unit = _grp createUnit [(selectRandom POOL), POS, [], 0, "NONE"]; \
				_unit setDir random 360; \
				_unit setPosATL (selectRandom _posArray); \
				_unit disableAI "PATH"; \
			}; \
		}; \
	}

#define PREP_STATIC(POS,COUNT,SIZE,ARRAY) \
	_static = [POS, SIZE, COUNT] call EFUNC(main,spawnStatic); \
	ARRAY append (_static select 1)

#define PREP_SNIPER(POS,MAX_COUNT,SIZE) \
	[POS,ceil random MAX_COUNT,SIZE,SIZE+700] call EFUNC(main,spawnSniper)