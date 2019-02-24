/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Returns a new parabola
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

if(_this isEqualTo []) then {
    [POINT_NULL, false, PTR_NULL, EVENT_NULL, PTR_NULL, PTR_NULL, PTR_NULL]
} else {
    [_this, true, PTR_NULL, EVENT_NULL, PTR_NULL, PTR_NULL, PTR_NULL]
};