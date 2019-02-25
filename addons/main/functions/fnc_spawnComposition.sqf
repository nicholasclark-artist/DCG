/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn base

Arguments:
0: center position <ARRAY>
1: base strength, number between 0 and 1 that defines how fortified the base will be <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define CONFIG configfile >> QGVARMAIN(compositions)

// @todo use parseSimpleArray instead of compile

params [
    ["_position",[],[[]]],
    ["_strength",0.5,[0]]
];

private _composition = [];
private _compList = [];
private _objects = [];
private _nodes = [];
private _strength = (_strength max 0) min 1;
private _min = 0;
private _max = 0;
private _normalized = 0;
private _diff = 1;

// normalize base data
for "_index" from 0 to (count (CONFIG)) - 1 do {
    private _cfg = (CONFIG) select _index;
    private _cfgStrength = getNumber (_cfg >> "strength");
    if (_min isEqualTo 0 || {_cfgStrength < _min}) then {
        _min = _cfgStrength;
    };
    if (_max isEqualTo 0 || {_cfgStrength > _max}) then {
        _max = _cfgStrength;
    };
};

for "_index" from 0 to (count (CONFIG)) - 1 do {
    private _cfg = (CONFIG) select _index;
    _normalized = linearConversion [_min, _max, getNumber (_cfg >> "strength"), 0, 1, true];
    _compList pushBack [_index,_normalized];
};

[_compList] call FUNC(shuffle);

// find base with strength close to passed strength
{
    if (abs ((_x select 1) - _strength) < _diff) then {
        _diff = abs ((_x select 1) - _strength);
        _composition = (CONFIG) select (_x select 0);
        _normalized = (_x select 1);
    };
    false
} count _compList;

if (_composition isEqualTo []) then {
    _composition = (CONFIG) select ((_compList select 0) select 0);
    _normalized = (CONFIG) select ((_compList select 0) select 1);
};

private _anchor = "Land_HelipadEmpty_F" createVehicle DEFAULT_SPAWNPOS;
_anchor setVectorUp [0,0,1];
_anchor setPosATL [_position select 0,_position select 1,0];

private _objData = call compile (getText (_composition >> "objects"));

for "_i" from 0 to count _objData - 1 do {
    private ["_obj","_pos"];

    (_objData select _i) params ["_type","_relPos","_relDir","_vectorUp","_snap","_simple"];

    _relDir = call compile _relDir;
    _relPos = call compile _relPos;

    _obj = if !(_simple) then {
        _type createVehicle DEFAULT_SPAWNPOS;
    } else {
        createSimpleObject [_type, DEFAULT_SPAWNPOS];
    };

    _obj setDir _relDir;
    _obj setVectorUp [0,0,1];
    _pos = getPosATL _anchor vectorAdd _relPos;

    if (_snap) then {
        _pos set [2,0];
    };

    _obj setPosATL _pos;

    if !(_vectorUp) then {
        _obj setVectorUp surfaceNormal getPosATL _obj;
    };

    _objects pushBack _obj;
    _obj enableDynamicSimulation true;
};

private _nodeData = call compile (getText (_composition >> "nodes"));

for "_i" from 0 to count _nodeData - 1 do {
    (_nodeData select _i) params ["_relPos","_range"];

    _relPos = call compile _relPos;
    _range = call compile _range;

    private _pos = getPosATL _anchor vectorAdd _relPos;

    _nodes pushBack [_pos,_range];
};

deleteVehicle _anchor;

private _ret = [
    getNumber (_composition >> "radius"),
    _normalized,
    _objects,
    _nodes
];

_ret
