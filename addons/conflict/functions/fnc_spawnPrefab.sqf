/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn prefabs in area like roadside check points

Arguments:
0: center position <ARRAY>
1: prefab type <STRING>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_position",DEFAULT_POS,[[]]],
    ["_type","",[""]]
];

private _ret = [];

// get road position, remove unsuitable roads and intersections
private _roads = _position nearRoads 200;
_roads = _roads select {!((roadsConnectedTo _x) isEqualTo []) && count (roadsConnectedTo _x) < 3};

if (_roads isEqualTo []) exitWith {_ret};

switch _type do {
    case "mil_cp": {
        private _road = selectRandom _roads;
        private _roadPos = getPos _road;

        private _unitCount = [4,12,GVAR(countCoef)] call EFUNC(main,getUnitCount);
        private _grp = [_roadPos getPos [10,random 360],0,_unitCount,EGVAR(main,enemySide),1,false,true] call EFUNC(main,spawnGroup);

        // spawn composition after units so units are aware of buildings
        private _dir = _road getRelDir ((roadsConnectedTo _road) select 0);
        _dir = _dir + (180 * round (random 1));

        _ret = [_roadPos,_type,_dir,true] call EFUNC(main,spawnComposition);

        // set CBA building positions so units find node positions
        private "_bp";
        {
            _bp = createVehicle ["CBA_buildingPos",_x select 0,[],0,"CAN_COLLIDE"];
            (_ret select 2) pushBack _bp;
        } forEach (_ret select 3);

        // set group to defend
        [
            {(_this select 0) getVariable [QEGVAR(main,ready),false]},
            {
                [_this select 0,_this select 1,15,0] call EFUNC(main,taskDefend);
                [QEGVAR(cache,enableGroup),_this select 0] call CBA_fnc_serverEvent;
            },
            [_grp,_roadPos],
            _unitCount * 2
        ] call CBA_fnc_waitUntilAndExecute;

        _ret
    };

    default {_ret};
};
