/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: 
        If _left function returns the rightmost leaf in left subtree of the given node.
        If !_left function returns the leftmost leaf in right the subtree of the given node.
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params ["_pPtr", ["_left", true]];

if(PTR_IS_NULL(_pPtr)) exitWith { 
#ifdef DO_DEBUG
    diag_log text format ["Returning child = %1", PTR_NULL];
#endif
    PTR_NULL 
};

private _childPtr = GET_PTR(_pPtr)#([PARABOLA_RIGHT, PARABOLA_LEFT] select _left);
private _dir = [PARABOLA_LEFT, PARABOLA_RIGHT] select _left;
while { !(GET_PTR(_childPtr)#PARABOLA_IS_LEAF) } do {
    _childPtr = GET_PTR(_childPtr)#_dir;
};

#ifdef DO_DEBUG
diag_log text format ["Returning child = %1", _childPtr];
#endif

_childPtr