/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn garrison, should not be called directly and should run in scheduled environment

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(spawnGarrison)
#define VEH_COUNT_VILL 1
#define VEH_COUNT_CITY 1
#define VEH_COUNT_CAP 2
#define AIR_COUNT_VILL 0
#define AIR_COUNT_CITY 1
#define AIR_COUNT_CAP 1

scopeName SCOPE;

[GVAR(garrisons),{
    private _ao = [GVAR(areas),_key] call CBA_fnc_hashGet;

    private _radius = _value getVariable [QGVAR(radius),0];
    private _prefabCount = 0;
    private _prefabObjects = [];

    // update garrison settings based on type
    (_ao getVariable [QEGVAR(main,type),""]) call {
        if (COMPARE_STR(toLower _this,"namecitycapital")) exitWith {
            _prefabCount = 4;
        };
        if (COMPARE_STR(toLower _this,"namecity")) exitWith {
            _prefabCount = 4;
        };
        if (COMPARE_STR(toLower _this,"namevillage")) exitWith {
            _prefabCount = 2;
        };
    };

    private _pos =+ (_value getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS]);
    _pos resize 2;

    // set blacklists
    EGVAR(civilian,blacklist) pushBack (_ao getVariable [QEGVAR(main,name),""]);
    EGVAR(patrol,blacklist) pushBack [_pos,_radius];

    // make area look destroyed
    private _buildings = _pos nearObjects ["House",_radius];

    if !(_buildings isEqualTo []) then {
        private _count = ceil random 4;

        for "_i" from 1 to (_count min (count _buildings)) do {
            private _house = selectRandom _buildings;
            _buildings deleteAt (_buildings find _house);
            if !((_house buildingPos -1) isEqualTo []) then {
                _house setDamage [1,false];
                private _fx = "test_EmptyObjectForSmoke" createVehicle DEFAULT_SPAWNPOS;
                _fx setPosWorld (getPosWorld _house);
            };
        };
    };

    // get prefab positions
    private _roads = _pos nearRoads _radius * 0.75;

    // remove unsuitable roads
    _roads = _roads select {!((roadsConnectedTo _x) isEqualTo []) && count (roadsConnectedTo _x) < 3};

    if !(_roads isEqualTo []) then {
        _roads = _roads call BIS_fnc_arrayShuffle;

        private ["_road","_prefab","_nodes"];

        for "_i" from 0 to (count _roads min _prefabCount) - 1 do {
            _road = _roads select _i;
            private _pos = [_road] call EFUNC(main,findPosRoadside);

            // spawn supply vehicle prefabs
            if !(_pos isEqualTo []) then {
                _prefab = [_pos,"sup_vehicle",_road getRelDir ((roadsConnectedTo _road) select 0),true] call EFUNC(main,spawnComposition);
                _prefabObjects append (_prefab select 2);
            };
        };
    };

    _value setVariable [QGVAR(prefabs),_prefabObjects];

    // [_value,_ao] call FUNC(spawnUnit);
}] call CBA_fnc_hashEachPair;

nil