/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Return the first predecessor in the beachline tree that is in the given direction (left/right)
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params ["_pPtr", ["_left", true]];

private _parentPtr = GET_PTR(_pPtr)#PARABOLA_PARENT;
if(PTR_IS_NULL(_parentPtr)) exitWith { PTR_NULL };

private _lastPtr = _pPtr;
private _childPtr = GET_PTR(_parentPtr)#([PARABOLA_RIGHT, PARABOLA_LEFT] select _left);
while { _childPtr == _lastPtr} do {
    private _nextParent = GET_PTR(_parentPtr)#PARABOLA_PARENT;
    if(PTR_IS_NULL(_nextParent)) exitWith {
        _parentPtr = PTR_NULL;
    };

    _lastPtr = _parentPtr;
    _parentPtr = _nextParent;
    _childPtr = GET_PTR(_parentPtr)#([PARABOLA_RIGHT, PARABOLA_LEFT] select _left);
};

#ifdef DO_DEBUG
diag_log text format ["Returning parent = %1", _parentPtr];
#endif

_parentPtr