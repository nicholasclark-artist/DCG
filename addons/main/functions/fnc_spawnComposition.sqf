/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn composition

Arguments:
0: center position <ARRAY>
1: composition type <STRING>
3: base direction <NUMBER>
4: clear position before spawning composition, this param requires function call from server <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define CONFIG (configfile >> QGVARMAIN(compositions) >> _type)
#define DIR_OFFSET(OFFSET) (getDir _pivot + OFFSET)
#define POS_RELATIVE(RELPOS) (_pivot modelToWorld RELPOS)

params [
    ["_position",DEFAULT_POS,[[]]],
    ["_type","",[""]],
    ["_dir",-1,[0]],
    ["_clear",false,[false]]
];

if (!isClass CONFIG || {count CONFIG isEqualTo 0}) exitWith {
    WARNING("config type is empty");
    []
};

_position =+ _position;
_position set [2,0];

if (_dir < 0) then {
    _dir = random 360;
};

private _composition = CONFIG select (floor random count CONFIG);
private _objects = [];
private _nodes = [];
private _intersects = [];

private ["_cfg"];

// spawn pivot
private _pivot = createVehicle ["Land_HelipadEmpty_F",DEFAULT_SPAWNPOS,[],0,"CAN_COLLIDE"];
_pivot setDir _dir;
_pivot setPosATL _position;
_pivot setVectorUp [0,0,1];
_pivot allowDamage false;

// pivot is always first object
_objects pushBack _pivot;

// clear terrain objects within composition radius
if (_clear && {isServer}) then {
    private _objectsTerrain = nearestTerrainObjects [_position,[],getNumber (_composition >> "radius"),false,true];

    {
        _x hideObjectGlobal true;
        _x allowDamage false;
    } forEach _objectsTerrain;

    // save reference to terrain objects in pivot
    _pivot setVariable [QGVARMAIN(objectsTerrain),_objectsTerrain];

    // restore objects when pivot deleted
    _pivot addEventHandler ["Deleted",{
        {
            _x hideObjectGlobal false;
            _x allowDamage true;
        } forEach ((_this select 0) getVariable [QGVARMAIN(objectsTerrain),[]]);
    }];
};

// spawn objects
private ["_obj","_pos"];

private _objData = parseSimpleArray (getText (_composition >> "objects"));

for "_i" from 0 to count _objData - 1 do {
    (_objData select _i) params ["_type","_relPos","_z","_ins","_dirOffset","_vectorUp","_simple"];

    _relPos = parseSimpleArray _relPos;
    _dirOffset = parseNumber _dirOffset;

    _obj = if (_simple < 1) then {
        createVehicle [_type,DEFAULT_SPAWNPOS,[],0,"CAN_COLLIDE"];
    } else {
        createSimpleObject [_type,DEFAULT_SPAWNPOS];
    };

    // get world position and set to ASL terrain height plus z offset
    _pos = POS_RELATIVE(_relPos);
    _pos set [2,(getTerrainHeightASL _pos) + (parseNumber _z)];

    // setup objects that will be snapped to another object's surface
    if !(_ins isEqualTo "") then {
        _intersects pushBack [_obj,_ins];
    };

    _obj setDir DIR_OFFSET(_dirOffset);
    _obj setPosASL _pos;

    // if default up vector is not forced,align to terrain normal
    if (_vectorUp < 1) then {
        _obj setVectorUp surfaceNormal getPosASL _obj;
    };

    _objects pushBack _obj;
    _obj enableDynamicSimulation true;
};

// handle surface objects
{
    _x params ["_obj","_ins"];

    // find intersection object
    // @todo align intersection vector to terrain normal?
        // _obj modelToWorldWorld ((surfaceNormal getPosASL _obj) vectorMultiply 10)
    private _intersect = lineIntersectsSurfaces [(getPosASL _obj) vectorAdd [0,0,10],getPosASL _obj,_obj,objNull,false,5,"GEOM","NONE"];

    {
        if (typeOf (_x select 2) isEqualTo _ins) exitWith {
            // adjust height based on intersection object's height
            private _pos = getPosASL _obj;
            _pos set [2,(_x select 0) select 2];

            _obj setPosASL _pos;
            _obj setVectorUp (_x select 1);

            // TRACE_1("intersection",_x);
        };
    } forEach _intersect;
} forEach _intersects;

// get node data
private _nodeData = parseSimpleArray (getText (_composition >> "nodes"));
// private "_bp";

for "_i" from 0 to count _nodeData - 1 do {
    (_nodeData select _i) params ["_relPos","_z","_radius"];

    _relPos = parseSimpleArray _relPos;
    _radius = parseNumber _radius;

    _pos = POS_RELATIVE(_relPos);

    // set height above terrain
    _pos set [2,parseNumber _z];

    // make node compatible with CBA building positions
    // _bp = createVehicle ["CBA_buildingPos",_pos,[],0,"CAN_COLLIDE"];
    // _objects pushBack _bp;

    _nodes pushBack [_pos,_radius];
};

[configName _composition,getNumber (_composition >> "radius"),_objects,_nodes]