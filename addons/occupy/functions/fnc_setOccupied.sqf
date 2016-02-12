/*
Author:
Nicholas Clark (SENSEI)

Description:
occupy locations

Arguments:
0: location name <STRING>
1: location position <ARRAY>
2: location size <NUMBER>
3: location type <STRING>
4: saved location data <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define CHANCE_VEH_CAP 1
#define CHANCE_AIR_CAP 0.5
#define SNIPER_CAP 3
#define STATIC_CAP 2
#define CHANCE_VEH_CITY 0.5
#define CHANCE_AIR_CITY 0.25
#define SNIPER_CITY 2
#define STATIC_CITY 2
#define CHANCE_VEH_VILLAGE 0.15
#define CHANCE_AIR_VILLAGE 0.10
#define SNIPER_VILLAGE 1
#define STATIC_VILLAGE 1
#define SETVAR_UNIT(UNIT) UNIT setVariable [format ["occupyUnit_%1", _name],true]
#define TASK_ID(TASKNAME) format ["lib_%1", TASKNAME]
#define TASK_TITLE(TASKTYPE) format ["Liberate %1", TASKTYPE]
#define TASK_DESC(TASKNAME) format ["Enemy forces have occupied %1! Liberate the settlement!",TASKNAME]
#define WRECKS ["Land_Wreck_Truck_dropside_F","Land_Wreck_Truck_F","Land_Wreck_UAZ_F","Land_Wreck_Ural_F","Land_Wreck_Van_F","Land_Wreck_Skodovka_F","Land_Wreck_CarDismantled_F","Land_Wreck_Car3_F","Land_Wreck_Car_F"]
#define PREP_INF(COUNT_INF) \
	_grp = [[_position,0,30,0.5] call EFUNC(main,findRandomPos),0,COUNT_INF,EGVAR(main,enemySide),false,1.5] call EFUNC(main,spawnGroup); \
	[units _grp,_size*0.5] call EFUNC(main,setPatrol); \
	{ \
		SETVAR_UNIT(_x); \
		_count = _count + 1; \
		false \
	} count units _grp
#define PREP_VEH(CHANCE,COUNT_VEH) \
	if (random 1 < CHANCE) then { \
		_posArray = [_position,50,_size,0,8,false,false] call EFUNC(main,findPosGrid); \
		if !(_posArray isEqualTo []) then { \
			_vehArray = [selectRandom _posArray,1,COUNT_VEH,EGVAR(main,enemySide),false,1] call EFUNC(main,spawnGroup); \
			[_vehArray,_size*2] call EFUNC(main,setPatrol); \
			{ \
				SETVAR_UNIT(_x); \
				_count = _count + (count units group _x); \
				false \
			} count _vehArray; \
		}; \
	}
#define PREP_AIR(CHANCE,COUNT_AIR) \
	if (random 1 < CHANCE) then { \
		_airArray = [_position,2,COUNT_AIR,EGVAR(main,enemySide),false,1] call EFUNC(main,spawnGroup); \
		[_airArray,2000] call EFUNC(main,setPatrol); \
		{ \
			SETVAR_UNIT(_x); \
			_count = _count + (count units group _x); \
			false \
		} count _airArray; \
	}
#define PREP_SNIPER(MAX_COUNT) \
	[_position,ceil random MAX_COUNT,_size,_size+1000] call EFUNC(main,spawnSniper)
#define PREP_STATIC(COUNT_STATIC) \
	_static = [_position, _size, COUNT_STATIC] call EFUNC(main,spawnStatic); \
	{ \
		SETVAR_UNIT(_x); \
		_count = _count + 1; \
		false \
	} count (_static select 0); \
	_objArray append (_static select 1)
#define PREP_GARRISON(MAX_COUNT) \
	_houses = _position nearObjects ["House", _size]; \
	for "_i" from 1 to MAX_COUNT do { \
		_posArray = (selectRandom _houses) buildingPos -1; \
		if !(_posArray isEqualTo []) then { \
			_grp = [[0,0,0],0,1,EGVAR(main,enemySide),false,1.5] call EFUNC(main,spawnGroup); \
			(leader _grp) setDir random 360; \
			(leader _grp) setPosATL (selectRandom _posArray); \
			(leader _grp) disableAI "MOVE"; \
			(leader _grp) disableAI "COVER"; \
			_count = _count + 1; \
		}; \
	}

private ["_grp","_count","_posArray","_vehArray","_airArray","_static","_objArray","_houses","_taskType","_officer","_vehPos","_fx","_veh","_town","_mrk"];
_this params ["_name","_position","_size","_type",["_data",nil]];

_objArray = [];
_count = 0;
_taskType = "";
_officer = objNull;

call {
	if (_type isEqualTo "NameCityCapital") exitWith {
		_taskType = "Capital";
		if (isNil "_data") then {
			PREP_INF(ceil GVAR(infCountCapital));
			PREP_VEH(CHANCE_VEH_CAP,ceil GVAR(vehCountCapital));
			PREP_AIR(CHANCE_AIR_CAP,ceil GVAR(airCountCapital));
			PREP_SNIPER(SNIPER_CAP);
			PREP_STATIC(STATIC_CAP);
		} else {
			PREP_INF(ceil (_data select 0));
			PREP_VEH(CHANCE_VEH_CAP,ceil (_data select 1));
			PREP_AIR(CHANCE_AIR_CAP,ceil (_data select 2));
			PREP_SNIPER(SNIPER_CAP);
			PREP_STATIC(STATIC_CAP);
		};
		PREP_GARRISON(15);
	};

	if (_type isEqualTo "NameCity") exitWith {
		_taskType = "City";
		if (isNil "_data") then {
			PREP_INF(ceil GVAR(infCountCity));
			PREP_VEH(CHANCE_VEH_CITY,ceil GVAR(vehCountCity));
			PREP_AIR(CHANCE_AIR_CITY,ceil GVAR(airCountCity));
			PREP_SNIPER(SNIPER_CITY);
			PREP_STATIC(STATIC_CITY);
		} else {
			PREP_INF(ceil (_data select 0));
			PREP_VEH(CHANCE_VEH_CITY,ceil (_data select 1));
			PREP_AIR(CHANCE_AIR_CITY,ceil (_data select 2));
			PREP_SNIPER(SNIPER_CITY);
			PREP_STATIC(STATIC_CITY);
		};
		PREP_GARRISON(10);
	};

	_taskType = "Village";
	if (isNil "_data") then {
		PREP_INF(ceil GVAR(infCountVillage));
		PREP_VEH(CHANCE_VEH_VILLAGE,ceil GVAR(vehCountVillage));
		PREP_AIR(CHANCE_AIR_VILLAGE,ceil GVAR(airCountVillage));
		PREP_SNIPER(SNIPER_VILLAGE);
		PREP_STATIC(STATIC_VILLAGE);
	} else {
		PREP_INF(ceil (_data select 0));
		PREP_VEH(CHANCE_VEH_VILLAGE,ceil (_data select 1));
		PREP_AIR(CHANCE_AIR_VILLAGE,ceil (_data select 2));
		PREP_SNIPER(SNIPER_VILLAGE);
		PREP_STATIC(STATIC_VILLAGE);
	};
	PREP_GARRISON(5);
};

call {
	_grp = createGroup EGVAR(main,enemySide);
	if (EGVAR(main,enemySide) isEqualTo EAST) exitWith {
		_officer = _grp createUnit [selectRandom EGVAR(main,officerPoolEast), ASLtoAGL _position, [], 0, "NONE"];
	};
	if (EGVAR(main,enemySide) isEqualTo WEST) exitWith {
		_officer = _grp createUnit [selectRandom EGVAR(main,officerPoolWest), ASLtoAGL _position, [], 0, "NONE"];
	};
	_officer = _grp createUnit [selectRandom EGVAR(main,officerPoolInd), ASLtoAGL _position, [], 0, "NONE"];
};
_count = _count + 1;
_officer setVariable [QUOTE(DOUBLES(ADDON,officer)),true,true];
removeFromRemainsCollector [_officer];
[[_officer],_size*0.5] call EFUNC(main,setPatrol);
// TODO call FUNC(addIntel) on officer

// create wrecks
for "_i" from 0 to (ceil random 3) do {
	_vehPos = [_position,0,_size,4] call EFUNC(main,findRandomPos);
	if (!(_vehPos isEqualTo _position) && {!isOnRoad _vehPos} && {!surfaceIsWater _vehPos}) then {
		private ["_fx","_veh"];
		_veh = (selectRandom WRECKS) createVehicle _vehPos;
		_veh setDir random 360;
		_veh setVectorUp surfaceNormal position _veh;
		_fx = "test_EmptyObjectForSmoke" createVehicle getposATL _veh;
		_fx attachTo [_veh,[0,0,0]];
		_objArray pushBack _veh;
	};
};

// pushBack location to array and set task
GVAR(locations) pushBack _this;
[true,TASK_ID(_name),[TASK_DESC(_name),TASK_TITLE(_taskType),""],ASLtoAGL _position,false,true,"Attack"] call EFUNC(main,setTask);

[{ // check for player PFH
	params ["_args","_idPFH"];
	_args params ["_town","_count","_objArray","_officer"];

	if !(([ASLToAGL(_town select 1),_town select 2] call EFUNC(main,getNearPlayers)) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		_args call FUNC(handler);
	};
}, 10, [_this,_count,_objArray,_officer]] call CBA_fnc_addPerFrameHandler;

if (CHECK_DEBUG) then {
	_mrk = createMarker [format["%1_%2_debug",QUOTE(ADDON),_name],_position];
	_mrk setMarkerShape "ELLIPSE";
	_mrk setMarkerSize [_size,_size];
	_mrk setMarkerColor format ["Color%1", EGVAR(main,enemySide)];
	_mrk setMarkerBrush "SolidBorder";
};

LOG_DEBUG_4("Location occupied: ",[_this,_count,_objArray,_officer]);