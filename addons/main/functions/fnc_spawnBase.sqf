/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn base

Arguments:
0: base strength, number between 0 and 1 that defines how fortified the base will be <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#include "\d\dcg\addons\main\DCG_Bases.hpp"
#define THRESHOLD 0.15

private ["_base","_ret","_anchor","_obj","_anchorData"];
params ["_position",["_strength",0.5]];

_base = [];
_ret = [];

_strength = _strength max 0;

if (_strength > 1) then {
    _strength = 1/_strength;
};

_data = [_data,1] call FUNC(shuffle);

// find base with strength close to passed strength
{
    if ((abs ((_x select 0) - _strength)) < THRESHOLD) exitWith {
        _base = _x;
    };

    _base = selectRandom _data;

    false
} count _data;

// remove strength number
_base deleteAt 0;

_anchorData = _base select 0;
_anchor = (_anchorData select 0) createVehicle _position;
_anchor setDir (call compile (_anchorData select 2));

if ((_anchorData select 4) > 0) then {
    _anchor setPos [(getpos _anchor) select 0,(getpos _anchor) select 1,0];
};

if ((_anchorData select 3) > 0) then {
    _anchor setVectorUp [0,0,1];
} else {
    _anchor setVectorUp surfaceNormal getPos _anchor;
};

_ret pushBack _anchor;

for "_i" from 1 to count _base - 1 do {
    (_base select _i) params ["_type","_relPos","_dir","_vector","_snap"];

    _relPos = call compile _relPos;
    _dir = call compile _dir;

    _obj = _type createVehicle [0,0,0];
    _obj setDir _dir;
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