/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn garrison, should not be called directly

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(spawnGarrison)
#define SPAWN_DELAY 0.5
#define INF_COUNT_VILL ([10,20] call EFUNC(main,getUnitCount))*GVAR(countCoef)
#define INF_COUNT_CITY ([16,32] call EFUNC(main,getUnitCount))*GVAR(countCoef)
#define INF_COUNT_CAP ([24,50] call EFUNC(main,getUnitCount))*GVAR(countCoef)
#define VEH_COUNT_VILL 1
#define VEH_COUNT_CITY 1
#define VEH_COUNT_CAP 2
#define AIR_COUNT_VILL 0
#define AIR_COUNT_CITY 1
#define AIR_COUNT_CAP 1

// define scope to break hash loop
scopeName SCOPE;

[GVAR(garrisons),{
    private _ao = [GVAR(areas),_key] call CBA_fnc_hashGet;

    // get settlement type
    (_ao getVariable [QEGVAR(main,type),""]) call {
        if (COMPARE_STR(toLower _this,"namecitycapital")) exitWith {
            
        };
        if (COMPARE_STR(toLower _this,"namecity")) exitWith {
            
        };
        if (COMPARE_STR(toLower _this,"namevillage")) exitWith {
            
        };
    };

    // simplify outpost position 
    private _pos =+ (_value getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS]); 
    _pos resize 2;

    // set blacklists
    EGVAR(civilian,blacklist) pushBack (_ao getVariable [QEGVAR(main,name),""]);
    EGVAR(patrol,blacklist) pushBack [_pos,_value getVariable [QGVAR(radius),0]];

    // destroy buildings
    private _buildings = _pos nearObjects ["House",_value getVariable [QGVAR(radius),0]];

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

    // @todo spawn prefabs
    
    // road checkpoints

    // supply truck sites

    // stationary patrol vehicle
    
}] call CBA_fnc_hashEachPair;

nil