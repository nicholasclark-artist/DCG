/*
Author:
Nicholas Clark (SENSEI)

Description:
init weather addon

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

private _data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);

// load saved data
if !(_data isEqualTo []) then {
    GVAR(overcast) = _data select 0;
    GVAR(rain) = _data select 1;
    GVAR(fog) = _data select 2;
    GVAR(date) = _data select 3;

    GVAR(month) = GVAR(date) select 1;
    GVAR(hour) = GVAR(date) select 3;
    setDate GVAR(date);

    // update measurements 
    [QGVAR(updateMeasurements), []] call CBA_fnc_localEvent;
} else {
    if (GVAR(month) < 0) then {GVAR(month) = ceil random 12};
    if (GVAR(hour) < 0) then {GVAR(hour) = floor random 24};

    // set date before getting forecast
    GVAR(date) = [2019, GVAR(month), ceil random 27, GVAR(hour), floor random 30];
    setDate GVAR(date);

    // update measurements 
    [QGVAR(updateMeasurements), []] call CBA_fnc_localEvent;

    // get initial weather values
    private _forecast = [0] call FUNC(getForecast);

    GVAR(overcast) = _forecast select 0;
    GVAR(rain) = _forecast select 1;
    GVAR(fog) = _forecast select 2;
};

[
    {CBA_missionTime > 0},
    {
        // set initial weather
        [] spawn {
            0 setOvercast GVAR(overcast);
            0 setFog GVAR(fog);
            WEATHER_DELAY_RAIN setRain GVAR(rain);

            forceWeatherChange;

            TRACE_5("initial forecast",nextWeatherChange,GVAR(overcast),GVAR(rain),GVAR(fog),date);
        };
        
        // handle date changes and measurement updates
        [{
            [QGVAR(updateMeasurements), []] call CBA_fnc_localEvent;

            if !((date select [0,3]) isEqualTo (GVAR(date) select [0,3])) then {
                [QGVAR(dateChange), []] call CBA_fnc_localEvent;
            };
        }, 300] call CBA_fnc_addPerFrameHandler;
    }
] call CBA_fnc_waitUntilAndExecute;

// start forecast handler after initial weather
[
    {nextWeatherChange < 1},
    {
        [FUNC(handleForecast), 1] call CBA_fnc_addPerFrameHandler;

        if (GVAR(rain) > 0) then {
            [FUNC(handleRain), 1800] call CBA_fnc_addPerFrameHandler;
        };
    }
] call CBA_fnc_waitUntilAndExecute;

nil