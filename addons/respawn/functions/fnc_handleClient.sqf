/*
Author:
Nicholas Clark (SENSEI)

Description:
handle client respawns

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (!hasInterface) exitWith {};

if (isNil "ace_respawn_savePreDeathGear" || {!ace_respawn_savePreDeathGear}) then {
INFO("Handling gear on respawn");

    player addEventHandler ["Killed",{
        player setVariable [QGVAR(unitGear), getUnitLoadout player];
        player setVariable [QGVAR(unitWeapon), [currentWeapon player, currentMuzzle player, currentWeaponMode player]];
    }];

    player addEventHandler ["Respawn",{
        [player, player getVariable QGVAR(unitGear), player getVariable QGVAR(unitWeapon)] call FUNC(restoreLoadout);
    }];
};

nil