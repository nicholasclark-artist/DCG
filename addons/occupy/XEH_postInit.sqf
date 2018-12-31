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
       
        _data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);
        [_data] call FUNC(handleLoadData);
    }
] call CBA_fnc_waitUntilAndExecute;