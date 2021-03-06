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
#define SFX_ALARM "A3\Sounds_F\sfx\alarmCar.wss"

params [
    ["_location",locationNull,[locationNull]],
    ["_type","",[""]]
];

private _position = _location getVariable [QEGVAR(main,positionASL),DEFAULT_SPAWNPOS];
private _radius = _location getVariable [QEGVAR(main,radius),0];
private _ambientList = [];

switch _type do {
    case "parked": {
        private _roads = _position nearRoads _radius;
        private _count = _location getVariable [QGVAR(vehicleCount),-1];

        // remove unsuitable roads
        _roads = _roads select {!((roadsConnectedTo _x) isEqualTo []) && count (roadsConnectedTo _x) < 3};

        if (_roads isEqualTo []) exitWith {};

        _roads = _roads call BIS_fnc_arrayShuffle;

        for "_i" from 0 to (count _roads min _count) - 1 do {
            private _road = _roads select _i;

            private _dir = _road getRelDir ((roadsConnectedTo _road) select 0);
            _dir = _dir + (180 * round (random 1));

            _position = [_road] call FUNC(findPosRoadside);

            private _class = selectRandom EGVAR(main,vehiclesCiv);
            private _path = getText (configfile >> "CfgVehicles" >> _class >> "model");

            if (_path select [0,1] == "\") then {
                _path = _path select [1];
            };

            if ((_path select [count _path - 4,4]) != ".p3d") then {
                _path = _path + ".p3d";
            };

            private _temp = createSimpleObject [_path,DEFAULT_SPAWNPOS,true];
            _temp setDir _dir;

            if ([_position,_temp,0] call EFUNC(main,isPosSafe)) then {
                private _veh = createVehicle [_class,DEFAULT_SPAWNPOS,[],0,"CAN_COLLIDE"];
                _veh setDir _dir;
                _veh setPosATL _position;
                _veh setFuel (0.1 + random 0.5);

                // alarm eventhandlers
                _veh addEventHandler ["GetIn",{
                    if (isPlayer (_this select 2) && {!((_this select 0) getVariable [QGVAR(alarm),false])}) then {
                        (_this select 0) setVariable [QGVAR(alarm),true];
                        playSound3D [SFX_ALARM,_this select 0,false,getPosASL (_this select 0),3,1,200];
                    };
                }];

                _veh addEventHandler ["Hit",{
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

        // remove unsuitable roads
        _roads = _roads select {!((roadsConnectedTo _x) isEqualTo []) && count (roadsConnectedTo _x) < 3};

        if (_roads isEqualTo []) exitWith {};

        _roads = _roads call BIS_fnc_arrayShuffle;

        private ["_road","_prefab","_nodes"];

        for "_i" from 0 to (count _roads min _count) - 1 do {
            private _road = _roads select _i;
            private _position = [_road] call EFUNC(main,findPosRoadside);

            if !(_position isEqualTo []) then {
                _prefab = [_position,"civ_cache",(_road getRelDir ((roadsConnectedTo _road) select 0)) - 90,false] call EFUNC(main,spawnComposition);
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