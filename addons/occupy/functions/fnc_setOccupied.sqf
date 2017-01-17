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
#define SAFE_DIST 10
#define GAR_COUNT ([3,10] call EFUNC(main,getUnitCount))
#define INF_COUNT_VILL ([15,25] call EFUNC(main,getUnitCount))
#define INF_COUNT_CITY ([20,35] call EFUNC(main,getUnitCount))
#define INF_COUNT_CAP ([25,45] call EFUNC(main,getUnitCount))
#define VEH_COUNT_VILL 1
#define VEH_COUNT_CITY 2
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

private _objArray = [];
private _mrkArray = [];
private _pool = [];
private _typeName = "";
private _infCount = 0;
private _vehCount = 0;
private _airCount = 0;
private _grid = [_center,16,_size,0,SAFE_DIST,0] call EFUNC(main,findPosGrid);

if (_grid isEqualTo []) exitWith {
    WARNING("Cannot occupy location, grid is empty");
    [] call FUNC(findLocation);
};

// spawn vehicle wrecks
for "_i" from 0 to (ceil random 2) do {
	private _vehPos = selectRandom _grid;

	if !(isOnRoad _vehPos) then {
		private _veh = createSimpleObject [selectRandom WRECKS,[0,0,0]];
		_veh setDir random 360;
		_veh setPosASL _vehPos;
		_veh setVectorUp surfaceNormal _vehPos;
		private _fx = "test_EmptyObjectForSmoke" createVehicle [0,0,0];
		_fx setPosASL (getPosWorld _veh);
		_objArray pushBack _veh;
        _veh setVariable [QUOTE(DOUBLES(ADDON,wreck)), true];
	};
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
        _infCount = INF_COUNT_CAP + GAR_COUNT;
        _vehCount = VEH_COUNT_CAP;
        _airCount = AIR_COUNT_CAP;
    };
    if (COMPARE_STR(_type,"NameCityCity")) exitWith {
        _typeName = "City";
        _infCount = INF_COUNT_CITY + GAR_COUNT;
        _vehCount = VEH_COUNT_CITY;
        _airCount = AIR_COUNT_CITY;
    };

    _typeName = "Village";
    _infCount = INF_COUNT_VILL + GAR_COUNT;
    _vehCount = VEH_COUNT_VILL;
    _airCount = AIR_COUNT_VILL;
};

if (isNil "_data") then {
    PREP_VEH(_center,_grid,_vehCount,_size*1.25);
    PREP_AIR(_center,_airCount);
    PREP_STATIC(_center,3,_size,_grid,_objArray);
    PREP_SNIPER(_center,3,_size);
    PREP_INF(_center,_grid,_infCount,GAR_COUNT,_size*0.63);
} else {
    PREP_VEH(_center,_grid,_data select 1,_size*1.25);
    PREP_AIR(_center,_data select 2);
    PREP_STATIC(_center,3,_size,_grid,_objArray);
    PREP_SNIPER(_center,3,_size);
    PREP_INF(_center,_grid,_data select 0,GAR_COUNT,_size*0.63);
};

private _iconPos =+ _center;
_iconPos set [1,(_iconPos select 1) - 30];
_icon = createMarker [[QUOTE(ADDON),_name] joinString "_", _iconPos];
_icon setMarkerShape "ICON";
_icon setMarkerColor ([EGVAR(main,enemySide),true] call BIS_fnc_sideColor);
_icon setMarkerText (["Liberate",_typeName] joinString " ");
_icon setMarkerType "o_installation";
_mrkArray pushBack _icon;

/*_mrk = createMarker [[QUOTE(ADDON),_name,"border"] joinString "_", _center];
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerSize [_size,_size];
_mrk setMarkerAlpha 0.7;
_mrk setMarkerColor ([EGVAR(main,enemySide),true] call BIS_fnc_sideColor);
_mrk setMarkerBrush  "DIAGGRID";
_mrkArray pushBack _mrk;*/

[
    {!([_this select 1,_this select 2] call EFUNC(main,getNearPlayers) isEqualTo [])},
    {
        _this call FUNC(handleOccupied);
    },
    [_name,_center,_size,_type,_objArray,_mrkArray]
] call CBA_fnc_waitUntilAndExecute;
