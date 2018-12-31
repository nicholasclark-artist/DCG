/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(isMultiplayer) exitWith {};

[
    {MAIN_ADDON && {CHECK_POSTBRIEFING} && {time > 0}},
    {
        if (!(EGVAR(main,enable)) || {!(GVAR(enable))}) exitWith {};
        
        _data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);
        [_data] call FUNC(handleLoadData);

        [] spawn {
            setDate GVAR(date);
            0 setOvercast GVAR(overcast);
            forceWeatherChange; // causes big bad lag
        };
    }
] call CBA_fnc_waitUntilAndExecute;