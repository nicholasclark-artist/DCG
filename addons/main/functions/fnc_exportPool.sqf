/*
Author:
Nicholas Clark (SENSEI)

Description:
export pool data from 3DEN selection

Arguments:

Return:
text
__________________________________________________________________*/
#include "script_component.hpp"
#define ALLOWED_TYPES ["Man","LandVehicle","Air"]
#define PRINT_MSG(MSG) \
    titleText [MSG, "PLAIN"]

private _objects = get3DENSelected "object";

if (_objects isEqualTo []) exitWith {
    PRINT_MSG("Exporting 0 classes - no objects in selection")
};

private _testObject = _objects select 0;
private _side = side _testObject;
private _kind = call {
    if (_testObject isKindOf "Man") exitWith {
        "Man"
    };
    if (_testObject isKindOf "LandVehicle") exitWith {
        "LandVehicle"
    };
    if (_testObject isKindOf "Air") exitWith {
        "Air"
    };
    ""
};

if (COMPARE_STR(_kind,"")) exitWith {
    PRINT_MSG("Exporting 0 classes - objects are not of allowed types")
};

{
    if (!(_x isKindOf _kind) || {!(side _x isEqualTo _side)}) exitWith {
        _objects = [];
    };
} forEach _objects;

if (_objects isEqualTo []) exitWith {
    PRINT_MSG("Exporting 0 classes - objects are not of same type or side")
};

_objects = _objects apply {typeOf _x}; // get classnames from objects
_objects = _objects arrayIntersect _objects; // remove duplicates

_msg = format ["Exporting %1 classes to clipboard",count _objects];
PRINT_MSG(_msg);

_objects pushBack "ALL";
reverse _objects;

private _list = str _objects;
_list = [_list,"[","{"] call FUNC(replaceString);
_list = [_list,"]","}"] call FUNC(replaceString);

copyToClipboard _list
