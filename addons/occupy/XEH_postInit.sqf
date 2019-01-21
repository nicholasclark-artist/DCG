/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

[
    {MAIN_ADDON && {CHECK_INGAME}},
    {
        if (!(EGVAR(main,enable)) || {!(GVAR(enable))}) exitWith {
            LOG(MSG_EXIT);
        };

        call FUNC(handleLoadData);
    }
] call CBA_fnc_waitUntilAndExecute;