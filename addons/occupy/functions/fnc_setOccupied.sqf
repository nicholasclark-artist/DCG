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

INFO_1("%1",_this);

private _objArray = [];
private _mrkArray = [];
private _pool = [];
private _typeName = "";
private _infCount = 0;
private _vehCount = 0;
private _airCount = 0;

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

call {
    if (COMPARE_STR(_type,"NameCityCapital")) exitWith {
        _typeName = "Capital";
    };
    if (COMPARE_STR(_type,"NameCity")) exitWith {
        _typeName = "City";
    };
    _typeName = "Village";
};

if (isNil "_data") then {
    if (COMPARE_STR(_type,"NameCityCapital")) exitWith {
        _infCount = INF_COUNT_CAP;
        _vehCount = VEH_COUNT_CAP;
        _airCount = AIR_COUNT_CAP;
    };
    if (COMPARE_STR(_type,"NameCity")) exitWith {
        _infCount = INF_COUNT_CITY;
        _vehCount = VEH_COUNT_CITY;
        _airCount = AIR_COUNT_CITY;
    };
    _infCount = INF_COUNT_VILL;
    _vehCount = VEH_COUNT_VILL;
    _airCount = AIR_COUNT_VILL;
} else {
    _infCount = _data select 0;
    _vehCount = _data select 1;
    _airCount = _data select 2;
};

PREP_STATIC(_center,2,_size,_objArray);
PREP_VEH(_center,_vehCount,_size*1.25);
PREP_AIR(_center,_airCount);
PREP_INF(_center,_infCount,_size*0.68);
PREP_SNIPER(_center,2,_size);

// destroy buildings
private _buildings = _center nearObjects ["House", _size];

if !(_buildings isEqualTo []) then {
    private _count = ceil random 4;

    for "_i" from 1 to (_count min (count _buildings)) do {
        private _house = selectRandom _buildings;
        _buildings deleteAt (_buildings find _house);
        if !((_house buildingPos -1) isEqualTo []) then {
            _house setDamage [1, false];
            private _fx = "test_EmptyObjectForSmoke" createVehicle [0,0,0];
            _fx setPosWorld (getPosWorld _house);
        };
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

GVAR(location) = [_name,_center,_size,_type]; // set as occupied location
EGVAR(civilian,blacklist) pushBack _name; // stop civilians from spawning in location

[
    {!([_this select 1,_this select 2] call EFUNC(main,getNearPlayers) isEqualTo [])},
    {
        _this call FUNC(handleOccupied);
    },
    [_name,_center,_size,_type,_objArray,_mrkArray]
] call CBA_fnc_waitUntilAndExecute;
