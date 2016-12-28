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
#define SAFE_DIST 8
#define GAR_COUNT ([3,10] call EFUNC(main,setStrength))
#define INF_COUNT_VILL ([10,20] call EFUNC(main,setStrength))
#define INF_COUNT_CITY ([15,30] call EFUNC(main,setStrength))
#define INF_COUNT_CAP ([20,40] call EFUNC(main,setStrength))
#define VEH_COUNT_VILL 1
#define VEH_COUNT_CITY 2
#define VEH_COUNT_CAP 2
#define AIR_COUNT_VILL 0
#define AIR_COUNT_CITY 1
#define AIR_COUNT_CAP 2

private ["_pool","_taskType","_infCount","_vehCount","_airCount"];
_this params ["_name","_center","_size","_type",["_data",nil]];

private _position = [];
private _objArray = [];
private _mrkArray = [];

// find new position in case original is on water or not empty
if !([_center,2,0] call EFUNC(main,isPosSafe)) then {
	for "_i" from 1 to _size step 2 do {
		_position = [_center,0,_i,2,0] call EFUNC(main,findPosSafe);
		if !(_position isEqualTo _center) exitWith {};
	};
} else {
	_position = _center;
};

_position = ASLtoAGL _position;

// spawn vehicle wrecks
for "_i" from 0 to (ceil random 3) do {
	_vehPos = [_position,0,_size,8,0] call EFUNC(main,findPosSafe);

	if (!(_vehPos isEqualTo _position) && {!isOnRoad _vehPos}) then {
		private _veh = createSimpleObject [selectRandom WRECKS,[0,0,0]];
		_veh setDir random 360;
		_veh setPosASL _vehPos;
		_veh setVectorUp surfaceNormal _vehPos;
		private _fx = "test_EmptyObjectForSmoke" createVehicle [0,0,0];
		_fx setPosASL (getPosWorld _veh);
		_objArray pushBack _veh;
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

GVAR(locations) pushBack [_name,_position,_size,_type]; // set as occupied location
EGVAR(civilian,blacklist) pushBack _name; // stop civilians from spawning in location

private _grid = [_center,8,_size,0,SAFE_DIST,0,false] call EFUNC(main,findPosGrid);

call {
    if (COMPARE_STR(_type,"NameCityCapital")) exitWith {
        _taskType = "Capital";
        _infCount = INF_COUNT_CAP;
        _vehCount = VEH_COUNT_CAP;
        _airCount = AIR_COUNT_CAP;
    };
    if (COMPARE_STR(_type,"NameCityCity")) exitWith {
        _taskType = "City";
        _infCount = INF_COUNT_CITY;
        _vehCount = VEH_COUNT_CITY;
        _airCount = AIR_COUNT_CITY;
    };

    _taskType = "Village";
    _infCount = INF_COUNT_VILL;
    _vehCount = VEH_COUNT_VILL;
    _airCount = AIR_COUNT_VILL;
};

if (isNil "_data") then {
    PREP_VEH(_position,_vehCount,_size,_grid);
    PREP_AIR(_position,_airCount);
    PREP_GARRISON(_position,GAR_COUNT,_size*0.5);
    PREP_STATIC(_position,3,_size,_objArray);
    PREP_SNIPER(_position,3,_size);
    PREP_INF(_position,_infCount,_size);
} else {

};

/*[true,_taskID,[format ["Enemy forces have occupied %1! Liberate the %2!",_name,tolower _taskType],format ["Liberate %1", _taskType],""],_position,false,true,"rifle"] call EFUNC(main,setTask);*/

[
    {!([_this select 1,_this select 2] call EFUNC(main,getNearPlayers) isEqualTo [])},
    {
        _this call FUNC(handleOccupied);
    },
    [_name,_position,_size,_type,_objArray,_taskID]
] call CBA_fnc_waitUntilAndExecute;

private _mrk = createMarker [format["%1_%2_debug",QUOTE(ADDON),_name],_position];
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerSize [_size,_size];
_mrk setMarkerColor ([EGVAR(main,enemySide),true] call BIS_fnc_sideColor);
_mrk setMarkerBrush "SolidBorder";
[_mrk] call EFUNC(main,setDebugMarker);

INFO_1("%1",[_name,_position,_size,_type,count _objArray]);
