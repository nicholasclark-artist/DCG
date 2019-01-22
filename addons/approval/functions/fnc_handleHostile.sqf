/*
Author:
Nicholas Clark (SENSEI)

Description:
handle hostile unit spawns

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private _players = call CBA_fnc_players;

if !(_players isEqualTo []) then {
    private _player = selectRandom _players;
    private _pos = getPos _player;

    if (!([_pos] call EFUNC(main,inSafezones)) && {alive _player} && {((getPos player) select 2) < 10}) then {
        if (random 1 > AP_CONVERT2(_pos)) then {
            _ret = [_player] call FUNC(spawnHostile);

            if (GVAR(hostileHint) && {_ret}) then {
                ["Aerial recon shows hostile civilian activity in your region!", true] remoteExecCall [QEFUNC(main,displayText), allPlayers, false];
            };
        };
    };
};

