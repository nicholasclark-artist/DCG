/*
Author:
Nicholas Clark (SENSEI)

Description:
handle hostile unit spawns

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

private _player = call EFUNC(main,getTargetPlayer);

if (isNull _player) exitWith {
    WARNING("cannot find target player for hostile civilian");
};

// convert approval value to hostile probability
if (PROBABILITY(AP_CONVERT2(getPosATL _player))) then {
    private _ret = [_player] call FUNC(spawnHostile);

    if (GVAR(hostileHint) && {_ret}) then {
        ["Aerial recon shows hostile civilian activity in your region!",true] remoteExecCall [QEFUNC(main,displayText),allPlayers,false];
    };
};

nil