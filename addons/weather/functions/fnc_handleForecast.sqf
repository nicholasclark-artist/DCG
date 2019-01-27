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
    GVAR(mOvercast) = _forecast select 0;
    WEATHER_DELAY_OVERCAST setOvercast GVAR(mOvercast);

    GVAR(waiting) = true;

    [{
        // if overcast reaches forecast
        if (abs (overcast - GVAR(mOvercast)) <= WEATHER_DEVIATION) exitWith {
            [_this select 1] call CBA_fnc_removePerFrameHandler;

            GVAR(waiting) = false;
            GVAR(cycle) = GVAR(cycle) + 1;

            TRACE_3("",overcast,overcastForecast,GVAR(mOvercast));
        };

        // set forecast again if engine tries to interfere
        if !(overcastForecast isEqualTo GVAR(mOvercast)) then {
            WARNING("engine interference: overcast not trending towards desired value");
            WEATHER_DELAY_OVERCAST setOvercast GVAR(mOvercast);
        };
    }, 1] call CBA_fnc_addPerFrameHandler;
} else { // fog cycle
    GVAR(mFog) = _forecast select 2;
    WEATHER_DELAY_FOG setFog GVAR(mFog);

    GVAR(waiting) = true;
    
    [{
        // if fog reaches forecast
        if (abs (fog - GVAR(mFog)) <= WEATHER_DEVIATION) exitWith {
            [_this select 1] call CBA_fnc_removePerFrameHandler;

            GVAR(waiting) = false;
            GVAR(cycle) = GVAR(cycle) + 1;

            TRACE_3("",fog,fogForecast,GVAR(mFog));
        };

        // set forecast again if engine tries to interfere
        if !(fogForecast isEqualTo GVAR(mFog)) then {
            WARNING("engine interference: fog not trending towards desired value");
            WEATHER_DELAY_FOG setFog GVAR(mFog);
        };
    }, 1] call CBA_fnc_addPerFrameHandler;
};