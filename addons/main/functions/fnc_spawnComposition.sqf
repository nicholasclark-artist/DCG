/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn composition

Arguments:
0: center position <ARRAY>
1: composition type <STRING>
2: base strength, number between 0 and 1 that defines how fortified the base will be <NUMBER>
3: base direction <NUMBER>
4: clear position before spawning composition, this param requires function call from server <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define CONFIG (configfile >> QGVARMAIN(compositions) >> _type)
#define DIR_OFFSET(OFFSET) (getDir _anchor + OFFSET)
#define POS_RELATIVE(RELPOS) (_anchor modelToWorld RELPOS)

params [
    ["_position",[],[[]]],
    ["_type","base",[""]],
    ["_strength",0.5,[0]],
    ["_dir",-1,[0]],
    ["_clear",false,[false]]
];

if !(isClass CONFIG) exitWith {
    WARNING("config type does not exist");
    []
};

_position =+ _position;
_position set [2,0];

if (_dir < 0) then {
    _dir = random 360;
};

private _composition = [];
private _compList = [];
private _objects = [];
private _nodes = [];
private _strength = 0 max _strength min 1;
private _cfgStrength = [];
private _normalized = 0;
private _diff = 1;

private ["_cfg"];

// normalize base data
for "_index" from 0 to (count CONFIG) - 1 do {
    _cfg = CONFIG select _index;
    _cfgStrength pushBack (getNumber (_cfg >> "strength"));
};

for "_index" from 0 to (count CONFIG) - 1 do {
    _cfg = CONFIG select _index;
    _normalized = linearConversion [selectMin _cfgStrength, selectMax _cfgStrength, getNumber (_cfg >> "strength"), 0, 1, true];
    _compList pushBack [_index,_normalized];
};

[_compList] call FUNC(shuffle);

// find base with strength close to passed strength
{
    if (abs ((_x select 1) - _strength) < _diff) then {
        _diff = abs ((_x select 1) - _strength);
        _composition = CONFIG select (_x select 0);
        _normalized = (_x select 1);
    };
} forEach _compList;

if (_composition isEqualTo []) then {
    _composition = CONFIG select ((_compList select 0) select 0);
    _normalized = CONFIG select ((_compList select 0) select 1);
};

// spawn anchor
private _anchor = createVehicle ["Land_HelipadEmpty_F", DEFAULT_SPAWNPOS, [], 0, "CAN_COLLIDE"];
_anchor setVectorUp [0,0,1];
_anchor setDir _dir;
_anchor setPosATL _position;
_anchor allowDamage false;

// anchor is always first object
_objects pushBack _anchor;

// clear terrain objects within composition radius
if (_clear && {isServer}) then {
    private _objectsTerrain = nearestTerrainObjects [_position, [], getNumber (_composition >> "radius"), false, true];

    {
        _x hideObjectGlobal true;
        _x allowDamage false;
    } forEach _objectsTerrain;

    // save reference to terrain objects in anchor 
    _anchor setVariable ["objectsTerrain",_objectsTerrain];

    // restore objects when anchor deleted
    _anchor addEventHandler ["Deleted", {
        {
            _x hideObjectGlobal false;
            _x allowDamage true;
        } forEach ((_this select 0) getVariable ["objectsTerrain",[]]);
    }];  
};

// spawn objects
private ["_obj","_pos"];

private _objData = parseSimpleArray (getText (_composition >> "objects"));

for "_i" from 0 to count _objData - 1 do {
    (_objData select _i) params ["_type","_relPos","_z","_dirOffset","_vectorUp","_simple"];

    _relPos = parseSimpleArray _relPos;
    _dirOffset = parseNumber _dirOffset;
    _z = parseNumber _z;
    
    _obj = if (_simple < 1) then {
        createVehicle [_type, DEFAULT_SPAWNPOS, [], 0, "CAN_COLLIDE"];
    } else {
        createSimpleObject [_type, DEFAULT_SPAWNPOS];
    };

    _obj setDir DIR_OFFSET(_dirOffset);
    _pos = POS_RELATIVE(_relPos);

    // set height above terrain
    _pos set [2,_z];

    _obj setPosATL _pos;

    if (_vectorUp < 1) then {
        _obj setVectorUp surfaceNormal getPosATL _obj;
    };

    _objects pushBack _obj;
    _obj enableDynamicSimulation true;
};

// get node data
private _nodeData = parseSimpleArray (getText (_composition >> "nodes"));

for "_i" from 0 to count _nodeData - 1 do {
    (_nodeData select _i) params ["_relPos","_z","_range"];

    _relPos = parseSimpleArray _relPos;
    _range = parseNumber _range;

    _pos = POS_RELATIVE(_relPos);
    
    // set height above terrain
    _pos set [2,_z];

    _nodes pushBack [_pos,_range];
};

[getNumber (_composition >> "radius"),_normalized,_objects,_nodes]