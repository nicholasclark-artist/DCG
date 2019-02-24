/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Returns parabola on beachline that _checkX is over.
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params ["_rootPtr", "_lineY", "_checkX"];

private _ptr = _rootPtr;
while {!(GET_PTR(_ptr)#PARABOLA_IS_LEAF)} do {
    private _edgeX = [_ptr, _lineY] call FUNC(getXOfEdge);
    if(_edgeX > _checkX) then {
        _ptr = GET_PTR(_ptr)#PARABOLA_LEFT;
    } else {
        _ptr = GET_PTR(_ptr)#PARABOLA_RIGHT;
    };
};

#ifdef DO_DEBUG
diag_log text format ["Returned = %1", _ptr];
#endif

_ptr