/*
Author:
Nicholas Clark (SENSEI)

Description:
occupy locations

Arguments:
__________________________________________________________________*/
#include "script_component.hpp"
#define SETVAR_UNIT(UNIT) UNIT setVariable [format ["occupyUnit_%1", _name],true]
#define TASK_ID format ["lib_%1", _name]
#define TASK_TITLE format ["Liberate %1", _taskType]
#define TASK_DESC format ["Enemy forces have occupied %1! Liberate the settlement!",_name]
#define WRECKS ["Land_Wreck_Truck_dropside_F","Land_Wreck_Truck_F","Land_Wreck_UAZ_F","Land_Wreck_Ural_F","Land_Wreck_Van_F","Land_Wreck_Skodovka_F","Land_Wreck_CarDismantled_F","Land_Wreck_Car3_F","Land_Wreck_Car_F"]
#define PREP_INF(COUNT_INF) \
	_grp = [[_position,0,30,0.5] call EFUNC(main,findRandomPos),0,COUNT_INF,EGVAR(main,enemySide),false,0.5] call EFUNC(main,spawnGroup); \
	[units _grp,_size] call EFUNC(main,setPatrol); \
	{ \
		SETVAR_UNIT(_x); \
		_count = _count + 1; \
		false \
	} count units _grp
#define PREP_VEH(CHANCE,COUNT_VEH) \
	if (random 1 < CHANCE) then { \
		_posArray = [_position,50,_size,0,8,false,false] call EFUNC(main,findPosGrid); \
		if !(_posArray isEqualTo []) then { \
			_vehArray = [selectRandom _posArray,1,COUNT_VEH,EGVAR(main,enemySide),false,0.1] call EFUNC(main,spawnGroup); \
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
		_airArray = [_position,2,COUNT_AIR,EGVAR(main,enemySide),false,0.1] call EFUNC(main,spawnGroup); \
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

private ["_taskType","_grp","_count","_posArray","_vehArray","_airArray","_static","_objArray","_officer","_vehPos","_fx","_veh","_town","_mrk"];
_this params ["_name","_position","_size","_type",["_data",nil]];

_objArray = [];
_count = 0;
_taskType = "";

call {
	if (_type isEqualTo "NameCityCapital") exitWith {
		_taskType = "Capital";
		if (isNil "_data") then {
			PREP_INF(ceil GVAR(infCount));
			PREP_VEH(1,ceil GVAR(vehCount));
			PREP_AIR(0.5,ceil GVAR(airCount));
			PREP_SNIPER(ceil GVAR(sniperCount));
			PREP_STATIC(ceil GVAR(staticCount));
		} else {
			PREP_INF(ceil (_data select 0));
			PREP_VEH(1,ceil (_data select 1));
			PREP_AIR(0.5,ceil (_data select 2));
			PREP_SNIPER(ceil GVAR(sniperCount));
			PREP_STATIC(ceil GVAR(staticCount));
		};
	};

	if (_type isEqualTo "NameCity") exitWith {
		_taskType = "City";
		if (isNil "_data") then {
			PREP_INF(ceil (GVAR(infCount)*GVAR(cityMultiplier)));
			PREP_VEH(0.7,ceil (GVAR(vehCount)*GVAR(cityMultiplier)));
			PREP_AIR(0.25,ceil (GVAR(airCount)*GVAR(cityMultiplier)));
			PREP_SNIPER(ceil (GVAR(sniperCount)*GVAR(cityMultiplier)));
			PREP_STATIC(ceil (GVAR(staticCount)*GVAR(cityMultiplier)));
		} else {
			PREP_INF(ceil (_data select 0));
			PREP_VEH(0.7,ceil (_data select 1));
			PREP_AIR(0.25,ceil (_data select 2));
			PREP_SNIPER(ceil GVAR(sniperCount));
			PREP_STATIC(ceil GVAR(staticCount));
		};
	};

	_taskType = "Town";
	if (isNil "_data") then {
		PREP_INF(ceil (GVAR(infCount)*GVAR(townMultiplier)));
		PREP_VEH(0.3,ceil (GVAR(vehCount)*GVAR(townMultiplier)));
		PREP_SNIPER(ceil (GVAR(sniperCount)*GVAR(townMultiplier)));
		PREP_STATIC(ceil (GVAR(staticCount)*GVAR(townMultiplier)));
	} else {
		PREP_INF(ceil (_data select 0));
		PREP_VEH(0.3,ceil (_data select 1));
		PREP_SNIPER(ceil GVAR(sniperCount));
		PREP_STATIC(ceil GVAR(staticCount));
	};
};

_officer = objNull;

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
_officer setVariable [QUOTE(DOUBLES(ADDON,officer)),true];
removeFromRemainsCollector [_officer];
_count = _count + 1;
// TODO call FUNC(addIntel) on officer
[[_officer],_size*0.5] call EFUNC(main,setPatrol);

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
[true,TASK_ID,[TASK_DESC,TASK_TITLE,""],ASLtoAGL _position,false,true,"Attack"] call EFUNC(main,setTask);

[{ // check for player PFH
	params ["_args","_idPFH"];
	_args params ["_town","_count","_objArray","_officer"];

	if !(([ASLToAGL(_town select 1),_town select 2] call EFUNC(main,getNearPlayers)) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		_args call FUNC(PFH);
	};
}, 10, [_this,_count,_objArray,_officer]] call CBA_fnc_addPerFrameHandler;

if (CHECK_DEBUG) then {
	_mrk = createMarker [format["%1_%2_debug",QUOTE(ADDON),_name],_position];
	_mrk setMarkerShape "ELLIPSE";
	_mrk setMarkerSize [_size,_size];
	_mrk setMarkerColor format ["Color%1", EGVAR(main,enemySide)];
	_mrk setMarkerBrush "SolidBorder";
};

LOG_DEBUG_4("Location occupied: ",_this);