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

private _players = call CBA_fnc_players;

if !(_players isEqualTo []) then {
    private _player = selectRandom _players;
    private _pos = getPos _player;

    if (alive _player && {(_pos select 2) < 10} && {!([_pos] call EFUNC(main,inSafezones))}) then {
        // convert approval value to hostile probability
        if (PROBABILITY(AP_CONVERT2(_pos))) then {
            private _ret = [_player] call FUNC(spawnHostile);

            if (GVAR(hostileHint) && {_ret}) then {
                ["Aerial recon shows hostile civilian activity in your region!", true] remoteExecCall [QEFUNC(main,displayText), allPlayers, false];
            };
        };
    };
};

nil