/*
Author:
Nicholas Clark (SENSEI)

Description:
get player that satisfies specific conditions

Arguments:

Return:
object
__________________________________________________________________*/
#include "script_component.hpp"

private _players = (call CBA_fnc_players) select {
    alive _x &&
    {((getPosATL _x) select 2) < 10} &&
    {!([_x] call EFUNC(main,inSafezones))}
};

[selectRandom _players,objNull] select (_players isEqualTo [])