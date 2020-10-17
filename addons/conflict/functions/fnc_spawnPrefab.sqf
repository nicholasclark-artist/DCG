/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn prefabs in area, returns composition

Arguments:
0: area location <LOCATION>
1: position inside area <ARRAY>
2: prefab type <STRING>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_location",locationNull,[locationNull]],
    ["_position",DEFAULT_POS,[[]]],
    ["_type","",[""]]
];

private _ret = [];

// get road position, remove unsuitable roads
private _roads = _position nearRoads 200;
_roads = _roads select {!((roadsConnectedTo _x) isEqualTo []) && count (roadsConnectedTo _x) < 3};

if (_roads isEqualTo []) exitWith {_ret};

switch _type do {
    case "mil_cp": {
        private _road = selectRandom _roads;
        private _roadPos = getPos _road;

        private _unitCount = [4,8,GVAR(countCoef)] call EFUNC(main,getUnitCount);
        private _groups = [_location,EGVAR(main,enemySide),_unitCount] call FUNC(spawnUnit);

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

        // set groups to defend
        {
            [
                {(_this select 0) getVariable [QEGVAR(main,ready),false]},
                {
                    [_this select 0,_this select 1,15,0] call EFUNC(main,taskDefend);
                    sleep 0.2;
                    [QEGVAR(cache,enableGroup),_this select 0] call CBA_fnc_serverEvent;
                },
                [_x,_roadPos],
                _unitCount * 2
            ] call CBA_fnc_waitUntilAndExecute;

            sleep 0.2;
        } forEach (_groups select 0);

        _ret
    };

    default {_ret};
};
