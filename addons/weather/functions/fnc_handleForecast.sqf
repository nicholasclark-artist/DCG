/*
Author:
Nicholas Clark (SENSEI)

Description:
handle weather

Arguments:

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

if (GVAR(waiting)) exitWith {};

private _forecast = [1] call FUNC(getForecast);

if (GVAR(cycle) mod 2 isEqualTo 0) then { // overcast cycle
    GVAR(overcastForecast) = _forecast select 0;
    WEATHER_DELAY_OVERCAST setOvercast GVAR(overcastForecast);

    GVAR(waiting) = true;

    [{
        // if overcast reaches forecast
        if (abs (overcast - GVAR(overcastForecast)) <= WEATHER_DEVIATION) exitWith {
            [_this select 1] call CBA_fnc_removePerFrameHandler;

            GVAR(waiting) = false;
            GVAR(cycle) = GVAR(cycle) + 1;

            TRACE_3("",overcast,GVAR(overcastForecast),overcastForecast);
        };

        // set forecast again if engine tries to interfere
        if !(overcastForecast isEqualTo GVAR(overcastForecast)) then {
            WARNING("engine interference: overcast not trending towards desired forecast");
            WEATHER_DELAY_OVERCAST setOvercast GVAR(overcastForecast);
        };
    }, 1] call CBA_fnc_addPerFrameHandler;
} else { // fog cycle
    GVAR(fogForecast) = _forecast select 2;
    WEATHER_DELAY_FOG setFog GVAR(fogForecast);

    GVAR(waiting) = true;
    
    [{
        // if fog reaches forecast
        if (abs ((fogParams select 0) - (GVAR(fogForecast) select 0)) <= WEATHER_DEVIATION) exitWith {
            [_this select 1] call CBA_fnc_removePerFrameHandler;

            GVAR(waiting) = false;
            GVAR(cycle) = GVAR(cycle) + 1;

            TRACE_3("",fogParams,GVAR(fogForecast),fogForecast);
        };

        // set forecast again if engine tries to interfere
        if !(fogForecast isEqualTo (GVAR(fogForecast) select 0)) then {
            WARNING("engine interference: fog not trending towards desired forecast");
            WEATHER_DELAY_FOG setFog GVAR(fogForecast);
        };
    }, 1] call CBA_fnc_addPerFrameHandler;
};