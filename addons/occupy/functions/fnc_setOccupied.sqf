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
#define WRECKS \
    ["a3\structures_f\wrecks\Wreck_Car2_F.p3d","a3\structures_f\wrecks\Wreck_Car3_F.p3d","a3\structures_f\wrecks\Wreck_Car_F.p3d","a3\structures_f\wrecks\Wreck_Offroad2_F.p3d","a3\structures_f\wrecks\Wreck_Offroad_F.p3d","a3\structures_f\wrecks\Wreck_Truck_dropside_F.p3d","a3\structures_f\wrecks\Wreck_Truck_F.p3d","a3\structures_f\wrecks\Wreck_UAZ_F.p3d","a3\structures_f\wrecks\Wreck_Van_F.p3d","a3\structures_f\wrecks\Wreck_Ural_F.p3d"]
#define SAFE_DIST 12
#define INF_COUNT_VILL ([15,30] call EFUNC(main,getUnitCount))
#define INF_COUNT_CITY ([25,40] call EFUNC(main,getUnitCount))
#define INF_COUNT_CAP ([30,50] call EFUNC(main,getUnitCount))
#define VEH_COUNT_VILL 1
#define VEH_COUNT_CITY 1
#define VEH_COUNT_CAP 2
#define AIR_COUNT_VILL 0
#define AIR_COUNT_CITY 1
#define AIR_COUNT_CAP 2

params [
    ["_name","",[""]],
    ["_center",[0,0,0],[[]]],
    ["_size",0,[0]],
    ["_type","",[""]],
    ["_data",nil,[[]]]
];

INFO_1("Occupying %1",_name);

private _objArray = [];
private _mrkArray = [];
private _pool = [];
private _typeName = "";
private _infCount = 0;
private _vehCount = 0;
private _airCount = 0;
private _grid = [_center,32,_size,0,SAFE_DIST,0] call EFUNC(main,findPosGrid);

if (_grid isEqualTo []) exitWith {
    WARNING("Cannot occupy location, grid is empty");
    [] call FUNC(findLocation);
};

call {
	if (EGVAR(main,enemySide) isEqualTo EAST) exitWith {
		_pool = EGVAR(main,unitPoolEast);
	};
	if (EGVAR(main,enemySide) isEqualTo WEST) exitWith {
		_pool = EGVAR(main,unitPoolWest);
	};
    if (EGVAR(main,enemySide) isEqualTo RESISTANCE) exitWith {
    	_pool = EGVAR(main,unitPoolInd);
    };
};

if (_pool isEqualTo []) exitWith {
    WARNING("Cannot occupy location, unit pool empty")
};

GVAR(locations) pushBack [_name,_center,_size,_type]; // set as occupied location
EGVAR(civilian,blacklist) pushBack _name; // stop civilians from spawning in location

call {
    if (COMPARE_STR(_type,"NameCityCapital")) exitWith {
        _typeName = "Capital";
        _infCount = INF_COUNT_CAP;
        _vehCount = VEH_COUNT_CAP;
        _airCount = AIR_COUNT_CAP;
    };
    if (COMPARE_STR(_type,"NameCity")) exitWith {
        _typeName = "City";
        _infCount = INF_COUNT_CITY;
        _vehCount = VEH_COUNT_CITY;
        _airCount = AIR_COUNT_CITY;
    };

    _typeName = "Village";
    _infCount = INF_COUNT_VILL;
    _vehCount = VEH_COUNT_VILL;
    _airCount = AIR_COUNT_VILL;
};

if (isNil "_data") then {
    PREP_VEH(_center,_grid,_vehCount,_size*1.25);
    PREP_AIR(_center,_airCount);
    PREP_STATIC(_center,2,_size,_grid,_objArray);
    PREP_SNIPER(_center,2,_size);
    PREP_INF(_center,_grid,_infCount,_size*0.68);
} else {
    PREP_VEH(_center,_grid,_data select 1,_size*1.25);
    PREP_AIR(_center,_data select 2);
    PREP_STATIC(_center,2,_size,_grid,_objArray);
    PREP_SNIPER(_center,2,_size);
    PREP_INF(_center,_grid,_data select 0,_size*0.68);
};

// spawn vehicle wrecks
for "_i" from 0 to (ceil random 2) do {
    if (_grid isEqualTo []) exitWith {};

	private _vehPos = selectRandom _grid;
    _grid deleteAt (_grid find _vehPos);

	if ([_vehPos,8] call EFUNC(main,isPosSafe)) then {
		private _veh = createSimpleObject [selectRandom WRECKS,[0,0,0]];
		_veh setDir random 360;
		_veh setPosASL _vehPos;
		_veh setVectorUp surfaceNormal _vehPos;
		private _fx = "test_EmptyObjectForSmoke" createVehicle [0,0,0];
		_fx setPosWorld (getPosWorld _veh);
		_objArray pushBack _veh;
        _veh setVariable [QUOTE(DOUBLES(ADDON,wreck)), true];
	};
};

private _iconPos =+ _center;
_iconPos set [1,(_iconPos select 1) - 40];
_icon = createMarker [[QUOTE(ADDON),_name] joinString "_", _iconPos];
_icon setMarkerShape "ICON";
_icon setMarkerColor ([EGVAR(main,enemySide),true] call BIS_fnc_sideColor);
_icon setMarkerText (["Liberate",_typeName] joinString " ");
_icon setMarkerType "o_installation";
_mrkArray pushBack _icon;

[
    {!([_this select 1,_this select 2] call EFUNC(main,getNearPlayers) isEqualTo [])},
    {
        _this call FUNC(handleOccupied);
    },
    [_name,_center,_size,_type,_objArray,_mrkArray]
] call CBA_fnc_waitUntilAndExecute;
