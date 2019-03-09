/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize settings via CBA framework

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

[
    QGVAR(enable),
    "CHECKBOX",
    format ["Enable %1", COMPONENT_NAME],
    COMPONENT_NAME,
    true,
    true,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(time),
    "SLIDER",
    ["Respawn Delay","Time in seconds that the player must wait before respawn."],
    COMPONENT_NAME,
    [
        0,
        3600,
        10,
        0
    ],
    true,
    {
        if (!hasInterface) exitWith {};
        
        setPlayerRespawnTime _this;
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(deleteOnDisconnect),
    "CHECKBOX",
    "Delete Player Corpses on Disconnect",
    COMPONENT_NAME,
    false,
    true,
    {
        if (!isServer) exitWith {};

        switch (_this) do {
            case true: {
                if (GVAR(handleDisconnectID) < 0) then {
                    GVAR(handleDisconnectID) = addMissionEventHandler ["HandleDisconnect",{
                        deleteVehicle (_this select 0);
                        false
                    }];
                }
            };
            case false: {
                if (GVAR(handleDisconnectID) >= 0) then {
                    removeMissionEventHandler ["HandleDisconnect", GVAR(handleDisconnectID)];
                };
            };
            default {};
        };
    },
    true
] call CBA_Settings_fnc_init;