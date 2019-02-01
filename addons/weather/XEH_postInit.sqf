/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#ifdef DISABLE_COMPILE_CACHE
    #define WEATHER_DEBUG_HINT true
#else
    #define WEATHER_DEBUG_HINT false
#endif

POSTINIT;

if (WEATHER_DEBUG_HINT) then {
    [QEGVAR(main,debug), {
        _this call FUNC(handleDebug);
    }] call CBA_fnc_addEventHandler;
};

[QGVAR(dateChange), {
    INFO("date changed, adjusting initial forecast");

    GVAR(date) = date;
    
    private _forecast = [0] call FUNC(getForecast);

    GVAR(overcast) = _forecast select 0;
    GVAR(rain) = _forecast select 1;
    GVAR(fog) = _forecast select 2;
}] call CBA_fnc_addEventHandler;

[QGVAR(updateMeasurements), {
    call FUNC(getTemperature);
    call FUNC(getHumidity);

    TRACE_2("updating climate measurements",GVAR(temperatureCurrent),GVAR(humidityCurrent));
}] call CBA_fnc_addEventHandler;

call FUNC(init);