/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Sets the given parabola (pointer) to be the left or right child of the given parent. 
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params [
    "_parentPtr",
    "_childPtr",
    ["_left", true]
];

private _return = PTR_NULL;
if(!PTR_IS_NULL(_parentPtr)) then {
    private _parent = GET_PTR(_parentPtr);
    private _child = GET_PTR(_childPtr);
    _parent set [ [PARABOLA_RIGHT, PARABOLA_LEFT] select _left, _childPtr];
    _child set [PARABOLA_PARENT, _parentPtr];
} else {
    ["Invalid parent provided, parent points to null."] call BIS_fnc_error;
};