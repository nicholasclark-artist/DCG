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
        
        QGVAR(questionPVEH) addPublicVariableEventHandler {(_this select 1) call FUNC(handleQuestion)};
        QGVAR(hintPVEH) addPublicVariableEventHandler {[_this select 1,0] call FUNC(handleHint)};
        QGVAR(stopPVEH) addPublicVariableEventHandler {[_this select 1] spawn FUNC(handleHalt)};
        QGVAR(addPVEH) addPublicVariableEventHandler {
            (_this select 1) call FUNC(addValue);
            LOG_1("Client add AV: %1",_this);
        };

        _data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);
        [_data] call FUNC(handleLoadData);

        [{
            [FUNC(handleHostile), GVAR(hostileCooldown), []] call CBA_fnc_addPerFrameHandler;
        }, [], GVAR(hostileCooldown)] call CBA_fnc_waitAndExecute;

        [[],{
            if (hasInterface) then {
                call FUNC(handleClient);
            };
         }] remoteExecCall [QUOTE(BIS_fnc_call),0,true];
    }
] call CBA_fnc_waitUntilAndExecute;