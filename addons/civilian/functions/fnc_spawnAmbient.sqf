/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn ambient objects in settlement

Arguments:
0: spawn position <ARRAY>
1: radius <NUMBER>
2: ambient object count <NUMBER>
3: ambient object type <NUMBER>
4: trigger that activated function <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_position",[],[[]]],
    ["_radius",100,[0]],
    ["_count",5,[0]],
    ["_type",0,[0]],
    ["_trigger",objNull,[objNull]]
];

private _ambientList = [];

switch _type do {
    case 0: { // ambient vehicles 
        private _roads = _position nearRoads _radius;

        if (_roads isEqualTo []) exitWith {};

        [_roads] call EFUNC(main,shuffle);

        for "_i" from 0 to (count _roads min _count) - 1 do {
            private _road = _roads select _i;
            private _dir = _road getRelDir ((roadsConnectedTo _road) select 0);
            // _position = (getPosATL _road) getPos [6,0];

            _dir = _dir + (180 * round (random 1));
            _position = [((getPosATL _road) select 0) + (3.75 * sin (_dir + 90)),((getPosATL _road) select 1) + (3.75 * cos (_dir + 90)),0];

            private _class = selectRandom EGVAR(main,vehiclesCiv);
            private _path = getText (configfile >> "CfgVehicles" >> _class >> "model");

            if (_path select [0,1] == "\") then {
                _path = _path select [1];
            };

            if ((_path select [count _path - 4,4]) != ".p3d") then {
                _path = _path + ".p3d";
            };

            private _temp = createSimpleObject [_path, DEFAULT_SPAWNPOS];
            _temp setDir _dir;
            
            if ([_position,_temp,0] call EFUNC(main,isPosSafe)) then {
                _veh = createVehicle [_class, DEFAULT_SPAWNPOS, [], 0, "CAN_COLLIDE"];
                _veh setDir _dir;
                _veh setPosATL _position;
                _veh setFuel (0.1 + random 0.5);
                _ambientList pushBack _veh;
            };
            deleteVehicle _temp;
        };
    };
    default { };
};

TRACE_2("spawn ambients",_position,_ambientList);

// save reference to all ambient objects in trigger
SETVAR(_trigger,GVAR(ambient),_ambientList);

nil