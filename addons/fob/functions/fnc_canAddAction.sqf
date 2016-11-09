/*
Author:
Nicholas Clark (SENSEI)

Description:
check if player should receive actions

Arguments:
0: player to check

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private _player = _this select 0;

COMPARE_STR(GVAR(whitelist) select 0,"all") || {{COMPARE_STR(_x,str _player) || COMPARE_STR(_x,getPlayerUID _player)} count GVAR(whitelist) > 0}
