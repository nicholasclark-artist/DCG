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
#define THRESHOLD 0.18
#define CONFIG configfile >> "dcg_bases"
#define ANCHOR "Land_HelipadEmpty_F"

private ["_position","_strength","_base","_ret","_normalized","_min","_max","_index","_cfg","_cfgStrength","_objects","_anchor"];
params ["_position",["_strength",0.5]];

_base = [];
_ret = [];
_normalized = [];

_strength = (_strength max 0) min 1;
_min = 0;
_max = 0;

// normalize base data
for "_index" from 0 to (count (CONFIG)) - 1 do {
    _cfg = (CONFIG) select _index;
    _cfgStrength = getNumber (_cfg >> "strength");
    if (_min isEqualTo 0 || {_cfgStrength < _min}) then {
        _min = _cfgStrength;
    };
    if (_max isEqualTo 0 || {_cfgStrength > _max}) then {
        _max = _cfgStrength;
    };
};

for "_index" from 0 to (count (CONFIG)) - 1 do {
    _cfg = (CONFIG) select _index;
    _normalized pushBack [_index,linearConversion [_min, _max, getNumber (_cfg >> "strength"), 0, 1, true]];
};

_normalized = [_normalized,1] call FUNC(shuffle);

// find base with strength close to passed strength
{
    if (abs ((_x select 1) - _strength) < THRESHOLD) exitWith {
        _base = (CONFIG) select (_x select 0);
    };
    _base = (CONFIG) select (random ((count (CONFIG)) - 1));
    false
} count _normalized;

_ret pushBack _normalized;
_objects = call compile (getText (_base >> "objects"));
_anchor = ANCHOR createVehicle _position;
_anchor setDir random 360;
_anchor setPos [(getpos _anchor) select 0,(getpos _anchor) select 1,0];
_anchor setVectorUp surfaceNormal getPos _anchor;

for "_i" from 0 to count _objects - 1 do {
    private ["_obj","_pos"];
    (_objects select _i) params ["_type","_relPos","_relDir","_vector","_snap"];

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

    _ret pushBack _obj;
};

_ret