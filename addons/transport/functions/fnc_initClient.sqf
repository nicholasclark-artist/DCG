/*
Author:
Nicholas Clark (SENSEI)

Description:
handle client setup

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if (!hasInterface) exitWith {};

{
    _x call EFUNC(main,setAction);
} forEach [
    [QUOTE(ADDON),QUOTE(COMPONENT_PRETTY),{},{true}],
    [QGVAR(request),TR_REQUEST_NAME,{},{TR_REQUEST_COND},{TR_REQUEST_CHILD},[],player,1,ACTIONPATH],
    [QGVAR(signal),TR_SIGNAL_NAME,{TR_SIGNAL_STATEMENT},{TR_SIGNAL_COND},{},[],player,1,ACTIONPATH]
];
