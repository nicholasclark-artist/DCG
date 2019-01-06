/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(isMultiplayer) exitWith {};



[
    {MAIN_ADDON && {CHECK_POSTBRIEFING}},
    {
        if (!(EGVAR(main,enable)) || {!(GVAR(enable))}) exitWith {};
        
        QGVAR(requestPVEH) addPublicVariableEventHandler {
            (_this select 1) call FUNC(handleRequest);
        };
        
        [[],{
            if (hasInterface) then {call FUNC(handleClient)};
        }] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];
    }
] call CBA_fnc_waitUntilAndExecute;