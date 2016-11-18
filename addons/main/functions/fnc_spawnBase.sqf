/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn base

Arguments:
0: center position AGL <ARRAY>
1: base strength, number between 0 and 1 that defines how fortified the base will be <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define CONFIG configfile >> QUOTE(DOUBLES(PREFIX,bases))
#define ANCHOR "Land_HelipadEmpty_F"

params ["_position",["_strength",0.5]];

private _base = [];
private _bases = [];
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
    _bases pushBack [_index,_normalized];
};

private _bases = [_bases,count _bases] call FUNC(shuffle);

// find base with strength close to passed strength
{
    if (abs ((_x select 1) - _strength) < _diff) then {
        _diff = abs ((_x select 1) - _strength);
        _base = (CONFIG) select (_x select 0);
        _normalized = (_x select 1);
    };
    false
} count _bases;

if (_base isEqualTo []) then {
    _base = (CONFIG) select ((_bases select 0) select 0);
    _normalized = (CONFIG) select ((_bases select 0) select 1);
};

private _anchor = ANCHOR createVehicle [0,0,0];
_anchor setPos _position;
_anchor setDir random 360;
_anchor setPos [(getpos _anchor) select 0,(getpos _anchor) select 1,0];
_anchor setVectorUp surfaceNormal getPos _anchor;

private _objData = call compile (getText (_base >> "objects"));

for "_i" from 0 to count _objData - 1 do {
    private ["_obj","_pos"];

    (_objData select _i) params ["_type","_relPos","_relDir","_vector","_snap"];

    _relDir = call compile _relDir;
    _relPos = call compile _relPos;

    _obj = _type createVehicle [0,0,0];
    _obj setDir (getDir _anchor + _relDir);
    _pos = _anchor modelToWorld _relPos;

    if (_snap > 0) then {
        _pos set [2,0];
    };

    _obj setpos _pos;

    if (_vector > 0) then {
        _obj setVectorUp [0,0,1];
    } else {
        _obj setVectorUp surfaceNormal getPos _obj;
    };

    _objects pushBack _obj;
};

private _nodeData = call compile (getText (_base >> "nodes"));

for "_i" from 0 to count _nodeData - 1 do {
    private ["_pos"];

    (_nodeData select _i) params ["_relPos","_range"];

    _relPos = call compile _relPos;
    _range = call compile _range;

    _pos = _anchor modelToWorld _relPos;

    _nodes pushBack [_pos,_range];
};

private _ret = [
    getNumber (_base >> "radius"),
    _normalized,
    _objects,
    _nodes
];

_ret
