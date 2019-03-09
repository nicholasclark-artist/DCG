/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// headless client exit 
if (!isServer) exitWith {};

["CBA_settingsInitialized", {
    if (!EGVAR(main,enable) || {!GVAR(enable)}) exitWith {LOG(MSG_EXIT)};

    // [QEGVAR(main,debug), {
    //     _this call FUNC(handleDebug);
    // }] call CBA_fnc_addEventHandler;

    [QGVAR(dateChange), {
        INFO("date changed, set initial forecast");

        GVAR(date) = date;
        
        private _forecast = [0] call FUNC(getForecast);

        GVAR(overcast) = _forecast#0;
        GVAR(rain) = _forecast#1;
        GVAR(fog) = _forecast#2;
    }] call CBA_fnc_addEventHandler;

    [QGVAR(updateMeasurements), {
        call FUNC(getTemperature);
        call FUNC(getHumidity);

        // TRACE_2("updating climate measurements",GVAR(temperatureCurrent),GVAR(humidityCurrent));
    }] call CBA_fnc_addEventHandler;

    call FUNC(init);
}] call CBA_fnc_addEventHandler;