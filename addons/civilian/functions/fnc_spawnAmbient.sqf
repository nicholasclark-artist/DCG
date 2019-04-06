/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn ambient objects in settlement

Arguments:
0: spawn location <LOCATION>
1: ambient object type <NUMBER>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SFX_ALARM ""

params [
    ["_location",locationNull,[locationNull]],
    ["_type","",[""]]   
];

private _position = getPos _location;
private _radius = (size _location) select 0;
private _ambientList = [];

switch _type do {
    case "parked": {
        private _roads = _position nearRoads _radius;
        private _count = _location getVariable [QGVAR(vehicleCount),-1];

        // remove intersections
        _roads = _roads select {count (roadsConnectedTo _x) < 3};

        if (_roads isEqualTo []) exitWith {};

        [_roads] call EFUNC(main,shuffle);

        private ["_road","_dir","_class","_path","_temp","_veh"];

        for "_i" from 0 to (count _roads min _count) - 1 do {
            _road = _roads select _i;
            _dir = _road getRelDir ((roadsConnectedTo _road) select 0);

            _dir = _dir + (180 * round (random 1));
            _position = [((getPosATL _road) select 0) + (3.75 * sin (_dir + 90)),((getPosATL _road) select 1) + (3.75 * cos (_dir + 90)),0];

            _class = selectRandom EGVAR(main,vehiclesCiv);
            _path = getText (configfile >> "CfgVehicles" >> _class >> "model");

            if (_path select [0,1] == "\") then {
                _path = _path select [1];
            };

            if ((_path select [count _path - 4,4]) != ".p3d") then {
                _path = _path + ".p3d";
            };

            _temp = createSimpleObject [_path, DEFAULT_SPAWNPOS];
            _temp setDir _dir;

            if ([_position,_temp,0] call EFUNC(main,isPosSafe)) then {
                _veh = createVehicle [_class, DEFAULT_SPAWNPOS, [], 0, "CAN_COLLIDE"];
                _veh setDir _dir;
                _veh setPosATL _position;
                _veh setFuel (0.1 + random 0.5);

                // alarm eventhandlers
                // @todo find alarm sfx
                _veh addEventHandler ["GetIn", {
                    if (isPlayer (_this select 2) && {!((_this select 0) getVariable [QGVAR(alarm),false])}) then {
                        (_this select 0) setVariable [QGVAR(alarm),true];
                        playSound3D [SFX_ALARM,_this select 0,false,getPosASL (_this select 0),3,1,200];
                    };
                }];

                _veh addEventHandler ["Hit", {
                    if !((_this select 0) getVariable [QGVAR(alarm),false]) then {
                        (_this select 0) setVariable [QGVAR(alarm),true];
                        playSound3D [SFX_ALARM,_this select 0,false,getPosASL (_this select 0),3,1,200];
                    };
                }];

                _ambientList pushBack _veh;
            };
            deleteVehicle _temp;
        };
    };
    case "prefabs": {
        private _roads = _position nearRoads _radius * 0.75;
        private _count = _location getVariable [QGVAR(prefabCount),-1];

        // remove intersections
        _roads = _roads select {count (roadsConnectedTo _x) < 3};

        if (_roads isEqualTo []) exitWith {};

        [_roads] call EFUNC(main,shuffle);

        private ["_road","_dir","_prefab","_nodes"];

        for "_i" from 0 to (count _roads min _count) - 1 do {
            _road = _roads select _i;
            _dir = _road getRelDir ((roadsConnectedTo _road) select 0);
            _dir = _dir + (180 * round (random 1));

            _position = nil;

            // find new position until position at edge of road
            for "_i" from 3 to 10 do {
                _position = [((getPosATL _road) select 0) + (_i * sin (_dir + 90)),((getPosATL _road) select 1) + (_i * cos (_dir + 90)),0];
                
                if !(isOnRoad _position) exitWith {
                    _position = [((getPosATL _road) select 0) + ((_i - 1) * sin (_dir + 90)),((getPosATL _road) select 1) + ((_i - 1) * cos (_dir + 90)),0];
                };
            };

            if !(isNil "_position") then {
                _prefab = [_position,"prefab",0.5,_dir - 90,false] call EFUNC(main,spawnComposition);
                _location setVariable [QGVAR(prefabPositions),_prefab select 3];
                _ambientList append (_prefab select 2);
            };             
        };
    };

    default {};
};

// save reference to all ambient objects in location
_location setVariable [QGVAR(ambients),_ambientList];

nil