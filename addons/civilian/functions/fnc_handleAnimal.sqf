/*
Author:
Nicholas Clark (SENSEI)

Description:
handles animal unit spawns

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define ANIMAL_SPAWNDIST 120

if (GVAR(animalCount) >= 32) exitWith {};

private _animals = [];
private _places = [];
private _expressions = [
    [EX_HOUSES, ["Alsatian_Random_F","Fin_random_F"]],
    [EX_HOUSES + "* (1 - rain * 3)", ["Cock_random_F","Hen_random_F"]],
    [EX_MEADOW, ["Sheep_random_F"]],
    [EX_HILL + "* (1 - houses * 2)", ["Goat_random_F"]]
];

// get player to spawn animals around
private _player = selectRandom (call CBA_fnc_players);

if (isNil "_player") exitWith {};

if ([_player] call EFUNC(main,inSafezones)) exitWith {};

private _position = getPosATL _player;

// find all places for given expression
private ["_place"];

{
    _place = selectBestPlaces [_position,ANIMAL_SPAWNDIST,_x select 0,50,1];
    if !(_place isEqualTo []) then {
        _places pushBack [_place select 0, _x select 1];
    };
} forEach _expressions;

// get place with highest value
_place = [[[],0],[]];

{   
    if (_x select 0 select 1 > _place select 0 select 1) then {
        _place = _x;
    };
} forEach _places;

if ((_place select 0 select 0) isEqualTo []) exitWith {};

// spawn animals
for "_i" from 1 to 4 do {
    _agent = createAgent [selectRandom (_place select 1),_place select 0 select 0,[],ANIMAL_SPAWNDIST,"CAN_COLLIDE"];
    _animals pushBack _agent;
    GVAR(animalCount) = GVAR(animalCount) + 1;
};

// cleanup when players leave area
[{
    params ["_args","_idPFH"];
    _args params ["_position","_animals"];

    if (([_position,ANIMAL_SPAWNDIST,CIV_ZDIST] call EFUNC(main,getNearPlayers)) isEqualTo []) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        GVAR(animalCount) = GVAR(animalCount) - (count _animals);
        [QEGVAR(main,cleanup),_animals] call CBA_fnc_serverEvent;
    };
}, 60, [_position,_animals]] call CBA_fnc_addPerFrameHandler;