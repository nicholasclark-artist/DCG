/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(isMultiplayer) exitWith {};

[
    {MAIN_ADDON && {CHECK_POSTBRIEFING}},
    {
        if (!(EGVAR(main,enable)) || {!(GVAR(enable))}) exitWith {LOG(MSG_EXIT)};
        
        [[],{
            if (hasInterface) then {
                 if (isNil "ace_respawn_savePreDeathGear" || {!ace_respawn_savePreDeathGear}) then {
                    INFO("Handling gear on respawn");

                     player addEventHandler ["Killed",{
                         player setVariable [UNITGEAR, getUnitLoadout player];
                            player setVariable [UNITWEAPON, [currentWeapon player, currentMuzzle player, currentWeaponMode player]];
                     }];
                     player addEventHandler ["Respawn",{
                         [player,player getVariable UNITGEAR,player getVariable UNITWEAPON] call FUNC(restoreLoadout);
                     }];
                 };
            };
         }] remoteExecCall [QUOTE(BIS_fnc_call),0,true];
    }
] call CBA_fnc_waitUntilAndExecute;