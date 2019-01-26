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

if (nextWeatherChange < 1) then {
    // if weather close to forecast value, find new value
    if (abs (overcast - GVAR(overcast)) <= WEATHER_THRESOLD) then {
        GVAR(overcast) = call FUNC(getOvercast);
    };

    if (abs (rain - GVAR(rain)) <= WEATHER_THRESOLD) then {
        GVAR(rain) = call FUNC(getRain);
    };

    if (abs ((fogParams select 0) - GVAR(fog)) <= WEATHER_THRESOLD) then {
        // GVAR(fog) = call FUNC(getFog);
    };

    if (GVAR(cycle) mod 2 isEqualTo 0) then { // overcast and fog cannot be set in same cycle
        WEATHER_DELAY setOvercast GVAR(overcast);
        WEATHER_DELAY setRain GVAR(rain);
    } else {
        (WEATHER_DELAY)*0.5 setFog GVAR(fog); // fog time param actually works, so set it quicker
        WEATHER_DELAY setRain GVAR(rain);
    };

    TRACE_4("",GVAR(cycle),GVAR(overcast),GVAR(rain),GVAR(fog));
    TRACE_6("",nextWeatherChange,overcast,overcastForecast,fogParams,fogForecast,rain);

    GVAR(cycle) = GVAR(cycle) + 1;
};