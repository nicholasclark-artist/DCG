/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define MONTH_CURRENT ((date select 1) - 1)

POSTINIT;

// headless client exit 
if (!isServer) exitWith {};

["CBA_settingsInitialized", {
    if (!EGVAR(main,enable) || {!GVAR(enable)}) exitWith {LOG(MSG_EXIT)};

    // [QEGVAR(main,debug), {
    //     _this call FUNC(handleDebug);
    // }] call CBA_fnc_addEventHandler;

    // get current month data 
    GVAR(tempDay) = GVAR(tempDay) select MONTH_CURRENT;
    GVAR(tempNight) = GVAR(tempNight) select MONTH_CURRENT;
    GVAR(humidity) = GVAR(humidity) select MONTH_CURRENT;
    GVAR(clouds) = GVAR(clouds) select MONTH_CURRENT;
    GVAR(precipitation) = GVAR(precipitation) select MONTH_CURRENT;
    GVAR(rainfall) = GVAR(rainfall) select MONTH_CURRENT;

    [QGVAR(dateChange), {
        INFO("date changed, set initial forecast");

        GVAR(date) = date;
        
        private _forecast = [0] call FUNC(getForecast);

        GVAR(overcast) = _forecast select 0;
        GVAR(rain) = _forecast select 1;
        GVAR(fog) = _forecast select 2;
    }] call CBA_fnc_addEventHandler;

    [QGVAR(updateMeasurements), {
        call FUNC(getTemperature);
        call FUNC(getHumidity);

        // TRACE_2("updating climate measurements",GVAR(temperatureCurrent),GVAR(humidityCurrent));
    }] call CBA_fnc_addEventHandler;

    call FUNC(init);
}] call CBA_fnc_addEventHandler;