/*
Author:
Nicholas Clark (SENSEI)

Description:
checks if positionAGL is safe

Arguments:
0: position <ARRAY>
1: search radius, minimum distance from objects or object used to calculate search radius <NUMBER, OBJECT>
2: allow water <NUMBER>
3: max gradient <NUMBER>
4: object to ignore <OBJECT>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"
#define CHECK_MULTIPLIER 2
#define BBR_HEIGHT_MIN 1.5

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

private _bbCheck = objNull;

if (_check isEqualType objNull) then {
    _bbCheck = _check;
    private _bb = boundingBoxReal _check;
    private _maxWidth = abs ((_bb select 1 select 0) - (_bb select 0 select 0));
    private _maxLength = abs ((_bb select 1 select 1) - (_bb select 0 select 1));

    // get radius from object bounding box
    _check = (_maxWidth max _maxLength) * CHECK_MULTIPLIER;
};

// cap radius at 50m
_check = _check min 50; 

// check gradient and water, water accepts -1, 0 or 2
if (_pos isFlatEmpty [-1, -1, _gradient, 1 max _check * 0.1, _water, false, _ignore] isEqualTo []) exitWith {false};

// in order for an object to be detected by nearObjects and nearestTerrainObjects, the object's pivot (not bounding box) must be in search radius

// get near entities and filter ignored objects and game logics
private _objs = _pos nearObjects ["All", _check];
_objs = _objs select {
    !(_x isEqualTo _ignore) &&
    {!(_x isKindOf "Logic")} &&
    {getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "scope") > 1}
};

// get terrain objects, 2d search radius
_objs append (nearestTerrainObjects [_pos, [], _check, false, true]);

// filter out thin objects that should not realistically harm position safety, not ideal
_objs = _objs select {
    (abs (((boundingBoxReal _x) select 1 select 2) - ((boundingBoxReal _x) select 0 select 2))) >= BBR_HEIGHT_MIN
};

// check if under surface
private _z = lineIntersectsSurfaces [AGLToASL _pos, (AGLToASL _pos) vectorAdd [0, 0, 50], _ignore, objNull, false, 1, "GEOM", "NONE"] isEqualTo [];

if (isNull _bbCheck) exitWith {_z && {_objs isEqualTo []}};

// check bounding box intersections if object provided
_z && {_objs findIf {[[_bbCheck,_pos],_x] call FUNC(inBoundingBox)} < 0}