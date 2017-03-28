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

{
    _x call EFUNC(main,setAction);
} forEach [
    [QUOTE(ADDON),QUOTE(COMPONENT_PRETTY),{},{true}],
    [REQUEST_ID,REQUEST_NAME,{},{REQUEST_COND},{REQUEST_CHILD},[],player,1,ACTIONPATH],
    [SIGNAL_ID,SIGNAL_NAME,{SIGNAL_STATEMENT},{SIGNAL_COND},{},[],player,1,ACTIONPATH]
];
