/*
Author:
Nicholas Clark (SENSEI)

Description:
get forecast array

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

switch (_this select 0) do {
    // initial forecast
    case 0: { 
        private _forecast = [];

        _forecast pushBack (call FUNC(getOvercast));
        _forecast pushBack (call FUNC(getRain));
        _forecast pushBack (call FUNC(getFog));

        _forecast
    };
    // mid mission variance
    case 1: {
       private _forecast = [];

        // overcast variance 
        private _overcastMin = GVAR(overcast) - WEATHER_OVERCAST_VARIANCE;
        private _overcastMax = GVAR(overcast) + WEATHER_OVERCAST_VARIANCE;
        private _overcast = (random (_overcastMax - _overcastMin)) + _overcastMin;
        _overcast = 0 max _overcast min 1;
        
        _forecast pushBack _overcast;

        // rain variance 
        private _rain = if (GVAR(rain) > 0 && {PROBABILITY(0.5)}) then { // add another probability check so it doesn't continuously rain
            private _rainMin = GVAR(rain) - WEATHER_RAIN_VARIANCE;
            private _rainMax = GVAR(rain) + WEATHER_RAIN_VARIANCE;
            private _rainfall = (random (_rainMax - _rainMin)) + _rainMin; 

            // adjust rainfall based on current humidity
            _rainfall = _rainfall + GVAR(humidityCurrent) * 0.2;
            
            0 max _rainfall min 1
        } else {
            0
        };

        _forecast pushBack _rain;

        // no variance, get new value every cycle, so fog is not constant
        _forecast pushBack (call FUNC(getFog));

        _forecast
    };
    default {};
};