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
    // initial
    case 0: { 
        private _forecast = [];

        // overcast
        // get overcast value based on cloud cover data 
        private _pCloud = GVAR(cloudCover) select ((date select 1) - 1);
        private _overcast = if (PROBABILITY(_pCloud)) then { // clear, partly cloudy
            random 0.55;
        } else { // mostly cloudy, overcast
            (0.7 + random 0.31) min 1;
        };

        _forecast pushBack _overcast;

        // rain 
        // get map PoP or use override 
        private _pRain = [GVAR(precipitation) select ((date select 1) - 1), GVAR(precipitationOverride)] select (GVAR(precipitationOverride) >= 0);
        private _rain = if (PROBABILITY(_pRain)) then { // probability of precipitation
            // get rainfall amount from map data 
            private _rainfall = GVAR(rainfall) select ((date select 1) - 1);
            // convert rainfall data to 0-1 range 
            _rainfall = linearConversion [_rainfall select 1,_rainfall select 2,_rainfall select 0,0,1,true];
            // adjust rainfall based on current overcast
            _rainfall = ((_rainfall + ((linearConversion [0,1,overcast,-1,1,true]) * 0.5)) max 0) min 1;

            _rainfall
        } else {
            0
        };   

        _forecast pushBack _rain;

        // fog
        private _fog = random 1;

        _forecast pushBack _fog;

        _forecast
    };
    // mid mission variance
    case 1: {
       private _forecast = [];

        // overcast variance 
        private _overcastMin = GVAR(iOvercast) - WEATHER_OVERCAST_VARIANCE;
        private _overcastMax = GVAR(iOvercast) + WEATHER_OVERCAST_VARIANCE;
        private _overcast = (((random (_overcastMax - _overcastMin)) + _overcastMin) max 0) min 1;

        _forecast pushBack _overcast;

        private _rain = if (GVAR(iRain) > 0) then {
            // rain variance 
            private _rainMin = GVAR(iRain) - WEATHER_RAIN_VARIANCE;
            private _rainMax = GVAR(iRain) + WEATHER_RAIN_VARIANCE;
            private _rainfall = (((random (_rainMax - _rainMin)) + _rainMin) max 0) min 1;  
            // adjust rainfall based on current overcast
            _rainfall = ((_rainfall + ((linearConversion [0,1,overcast,-1,1,true]) * 0.5)) max 0) min 1;

            _rainfall
        } else {
            0
        };

        _forecast pushBack _rain;

        // fog variance 
        private _fogMin = GVAR(iFog) - WEATHER_FOG_VARIANCE;
        private _fogMax = GVAR(iFog) + WEATHER_FOG_VARIANCE;
        private _fog = (((random (_fogMax - _fogMin)) + _fogMin) max 0) min 1;

        _forecast pushBack _fog;

        _forecast
    };
    default {};
};