/*
Author:
Nicholas Clark (SENSEI)

Description:
handle weather

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (GVAR(waiting)) exitWith {};

private _forecast = [1] call FUNC(getForecast);

if (GVAR(cycle) mod 2 isEqualTo 0) then { // overcast cycle
    INFO("overcast cycle");
    GVAR(overcastForecast) = _forecast select 0;
    WEATHER_DELAY_OVERCAST setOvercast GVAR(overcastForecast);

    GVAR(waiting) = true;

    [{
        // if overcast reaches forecast
        if (abs (overcast - GVAR(overcastForecast)) <= WEATHER_DEVIATION) exitWith {
            [_this select 1] call CBA_fnc_removePerFrameHandler;

            GVAR(waiting) = false;
            GVAR(cycle) = GVAR(cycle) + 1;

            TRACE_2("overcast cycle finished",overcast,GVAR(overcastForecast));
        };

        // set forecast again if cycle disrupted
        if !(overcastForecast isEqualTo GVAR(overcastForecast)) then {
            WARNING("external interference: overcast not trending towards desired forecast");
            WEATHER_DELAY_OVERCAST setOvercast GVAR(overcastForecast);
        };
    }, 1] call CBA_fnc_addPerFrameHandler;
} else { // fog cycle
    INFO("fog cycle");
    GVAR(fogForecast) = _forecast select 2;
    WEATHER_DELAY_FOG setFog GVAR(fogForecast);

    GVAR(waiting) = true;
    
    [{
        // if fog reaches forecast
        if (abs ((fogParams select 0) - (GVAR(fogForecast) select 0)) <= WEATHER_DEVIATION) exitWith {
            [_this select 1] call CBA_fnc_removePerFrameHandler;

            GVAR(waiting) = false;
            GVAR(cycle) = GVAR(cycle) + 1;

            TRACE_2("fog cycle finished",fogParams,GVAR(fogForecast));
        };

        // set forecast again if cycle disrupted
        if !(fogForecast isEqualTo (GVAR(fogForecast) select 0)) then {
            WARNING("external interference: fog not trending towards desired forecast");
            WEATHER_DELAY_FOG setFog GVAR(fogForecast);
        };
    }, 1] call CBA_fnc_addPerFrameHandler;
};

nil