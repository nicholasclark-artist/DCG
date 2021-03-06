/*
Author:
Nicholas Clark (SENSEI)

Description:
checks if positionAGL is safe

Arguments:
0: positionAGL <ARRAY>
1: search radius, minimum distance from objects or object used to calculate search radius <NUMBER,OBJECT>
2: allow water <NUMBER>
3: max gradient <NUMBER>
4: object to ignore <OBJECT>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"
#define CHECK_COEF 3
#define BBR_HEIGHT_MIN 0.55

params [
    ["_pos",[],[[]]],
    ["_check",5,[0,objNull]],
    ["_water",-1,[0]],
    ["_gradient",-1,[0]],
    ["_ignore",objNull,[objNull]]
];

// convert to position3D for surface and bounding box checks
if (count _pos isEqualTo 2) then {
    _pos =+ _pos;
    _pos pushBack 0;
};

private _bbObj = objNull;

if (_check isEqualType objNull) then {
    _bbObj = _check;
    private _bb = 0 boundingBoxReal _bbObj;

    // get radius from object bounding box
    _check = CHECK_COEF * (([_bbObj] call FUNC(getObjectSize)) select 0);
};

// cap radius at 50m
_check = _check min 50; 

// check gradient and water, water accepts -1,0 or 2
if (_pos isFlatEmpty [-1,-1,_gradient,10 max (_check * 0.1),_water,false,_ignore] isEqualTo []) exitWith {false};

// skip distance checks if min distance is 0
if (_check <= 0) exitWith {true};

// in order for an object to be detected by nearObjects and nearestTerrainObjects, the object's pivot (not bounding box) must be in search radius

// get near entities and filter ignored objects and game logics
private _objs = _pos nearObjects ["All",_check];
_objs = _objs select {
    !(_x isEqualTo _ignore) &&
    {!(_x isKindOf "Logic")} &&
    {getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "scope") > 1}
};

// get terrain objects, 2d search radius
_objs append (nearestTerrainObjects [_pos,[],_check,false,true]);

// filter out thin objects that should not realistically harm position safety, not ideal solution
_objs = _objs select {
    (abs (((0 boundingBoxReal _x) select 1 select 2) - ((0 boundingBoxReal _x) select 0 select 2))) >= BBR_HEIGHT_MIN
};

// check if under surface
private _insBegin = (AGLToASL _pos) vectorAdd [0,0,0.1];
private _insEnd = (AGLToASL _pos) vectorAdd [0,0,([_bbObj] call FUNC(getObjectSize)) select 1];
private _z = lineIntersectsSurfaces [_insBegin,_insEnd,_ignore,objNull,true,1,"GEOM","NONE"] isEqualTo [];

if (isNull _bbObj) exitWith {_z && {_objs isEqualTo []}};

// _classes = _objs apply {typeOf _x};
// _ins = lineIntersectsSurfaces [_insBegin,_insEnd,_ignore,objNull,true,1,"GEOM","NONE"];
// TRACE_2("",_classes,_ins);

// check bounding box intersections if object provided
_z && {_objs findIf {[[_bbObj,_pos],_x] call FUNC(inBoundingBox)} < 0}