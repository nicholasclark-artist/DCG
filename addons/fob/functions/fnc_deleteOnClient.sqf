/*
Author:
Nicholas Clark (SENSEI)

Description:
send server delete eventhandler

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

[
    format ["Are you sure you want to dismantle %1?", GVAR(name)],
    TITLE,
    format ["%1 dismantled.", GVAR(name)],
    {missionNamespace setVariable [(_this select 0),true]; publicVariableServer (_this select 0);},
    [PVEH_DELETE]
] call EFUNC(main,displayGUIMessage);
