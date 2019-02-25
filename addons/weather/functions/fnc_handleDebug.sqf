/*
Author:
Nicholas Clark (SENSEI)

Description:
handle weather debug

Arguments:
0: debug setting <NUMBER>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

switch (_this select 0) do {
    case 0: { 
        // removeMissionEventHandler ["EachFrame", GVAR(debug)];
        removeAllMissionEventHandlers "EachFrame";
        GVAR(debug) = nil;
    };
    case 1: { 
        GVAR(debugEachFrame) = { 
            toFixed 2;
            _cycle = ["FOG","OVERCAST"] select ((GVAR(cycle) mod 2) isEqualTo 0); 
            _format = format [
                "cycle: %1 \nnextWeatherChange: %2 \novercast: %3 \novercastForecast: %4 \nfog: %5 \nfogForecast: %6 \nrain: %7",
                _cycle, 
                nextWeatherChange/60, 
                overcast, 
                overcastforecast, 
                fog, 
                fogForecast, 
                rain
            ];
            hintSilent _format;     
        };

        GVAR(debug) = addMissionEventHandler ["EachFrame",{call GVAR(debugEachFrame)}];
    };
    default { };
};

nil