/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn emplacements

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    "_pos",
    ["_range",100,[0]],
    ["_count",1,[0]],
    ["_side",GVAR(enemySide),[sideUnknown]],
    ["_grid",[],[[]]]
];

if (_grid isEqualTo []) then {
    _grid = [_pos,32,_range,0,12,0] call FUNC(findPosGrid);
};

private _objArray = [];
private _gunnerArray = [];
private _unit = selectRandom([_side,0] call FUNC(getPool));
private _static1 = "";
private _static2 = "";
private _static3 = "";

call {
    if (_side isEqualTo EAST) exitWith {
        _static1 = "Land_Cargo_Patrol_V1_F";
        _static2 = "O_HMG_01_high_F";
        _static3 = "O_Mortar_01_F";
    };
    if (_side isEqualTo WEST) exitWith {
        _static1 = "Land_Cargo_Patrol_V1_F";
        _static2 = "B_HMG_01_high_F";
        _static3 = "B_Mortar_01_F";
    };
    if (_side isEqualTo INDEPENDENT) exitWith {
        _static1 = "Land_Cargo_Patrol_V1_F";
        _static2 = "I_HMG_01_high_F";
        _static3 = "I_Mortar_01_F";
    };
};

{
    if (count _gunnerArray isEqualTo _count) exitWith {};

    private _posGrid = ASLToAGL _x;

    if !(isOnRoad _posGrid) then {
        private _type = ceil random 3;

        if (_type isEqualTo 1) exitWith { // tower
            private _tower = _static1 createVehicle DEFAULT_SPAWNPOS;
            _tower setdir ([_tower, _pos] call BIS_fnc_DirTo) + 180;
            _tower setvectorup [0,0,1];
            _tower setPos _posGrid;
            private _gunner = (createGroup _side) createUnit [_unit, DEFAULT_SPAWNPOS, [], 0, "NONE"];
            _gunner setFormDir (getDir _tower);
            _gunner setDir (getDir _tower);
            _gunner setPosATL (_tower buildingpos 1);
            _gunner disableAI "PATH";
            _gunner setSkill ["spotDistance",0.90];
            _gunnerArray pushBack _gunner;
            _objArray pushBack _tower;
        };

        if (_type isEqualTo 2) exitWith { // bunkered static
            private _roads = _posGrid nearRoads 100;
            if (_roads isEqualTo []) exitWith {};
            private _road = selectRandom _roads;
            private _roadConnectedTo = (roadsConnectedTo _road);
            if (_roadConnectedTo isEqualTo [] || {!(_road inArea [_pos, _range, _range, 0, false, -1])}) exitWith {};
            _roadConnectedTo = _roadConnectedTo select 0;
            private _staticPos = _road modelToWorld [-11,0,0];
            _staticPos resize 2;
            if ((_staticPos isFlatEmpty [2, -1, 0.4, 3, -1]) isEqualTo [] || {isOnRoad _staticPos}) exitWith {};
            _staticPos set [2,-0.02];
            private _bunker = "Land_BagBunker_Small_F" createVehicle _staticPos;
            _bunker setDir ([_road, _roadConnectedTo] call BIS_fnc_DirTo) + 180;
            _bunker setVectorUp surfaceNormal position _bunker;

            if (count (lineIntersectsObjs [[(getposasl _bunker) select 0,(getposasl _bunker) select 1,((getposasl _bunker) select 2) + 1], ATLToASL(_bunker modelToWorld [0,30,1])]) > 0) exitWith {
                deleteVehicle _bunker
            };

            private _static = createVehicle [_static2, DEFAULT_SPAWNPOS, [], 0, "CAN COLLIDE"];
            _static setPos (_bunker modelToWorld [0,0,-0.8]);
            private _gunner = (createGroup _side) createUnit [_unit, DEFAULT_SPAWNPOS, [], 0, "NONE"];
            _gunner moveInGunner _static;
            _gunner doWatch (_bunker modelToWorld [0,-40,1]);
            _gunnerArray pushBack _gunner;
            _objArray pushBack _bunker;
            _objArray pushBack _static;
        };

        if !(_posGrid isFlatEmpty [2, -1, 0.4, 3, -1] isEqualTo []) then { // mortar
            private _static = _static3 createVehicle DEFAULT_SPAWNPOS;
            _static setVectorUp surfaceNormal _posGrid;
            _static setPos _posGrid;
            _objArray pushBack _static;

            {
                private _fort = "Land_BagFence_Round_F" createVehicle DEFAULT_SPAWNPOS;
                private _fortPos = (_static modelToWorld _x);
                _fortPos resize 2;
                _fort setPos _fortPos;
                _fort setDir ([_fort, _static] call BIS_fnc_DirTo);
                _fort setVectorUp surfaceNormal (getPos _fort);
                _objArray pushBack _fort;
            } forEach [
                [0,2.3,0],
                [0,-2.3,0],
                [-2.3,0,0]
            ];

            private _gunner = (createGroup _side) createUnit [_unit, DEFAULT_SPAWNPOS, [], 0, "NONE"];
            _gunner moveInGunner _static;
            _gunnerArray pushBack _gunner;
        };
    };
} forEach _grid;

{
    _mrk = createMarker [[QUOTE(PREFIX),_x] joinString "_",getpos _x];
    _mrk setMarkerType "o_installation";
    _mrk setMarkerColor ([side _x,true] call BIS_fnc_sideColor);
    _mrk setMarkerSize [0.7,0.7];
    [_mrk] call EFUNC(main,setDebugMarker);
} forEach _gunnerArray;

[_gunnerArray,_objArray]
