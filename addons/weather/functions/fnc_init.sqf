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
#define MONTH_CURRENT ((GVAR(date) select 1) - 1)

// set date
if (GVAR(month) < 0) then {GVAR(month) = ceil random 12};
if (GVAR(hour) < 0) then {GVAR(hour) = floor random 24};

GVAR(date) = [2020,GVAR(month),ceil random 27,GVAR(hour),floor random 30];

setDate GVAR(date);

// get current month data
GVAR(temperatureDay) = GVAR(temperatureDay) select MONTH_CURRENT;
GVAR(temperatureNight) = GVAR(temperatureNight) select MONTH_CURRENT;
GVAR(humidity) = GVAR(humidity) select MONTH_CURRENT;
GVAR(clouds) = GVAR(clouds) select MONTH_CURRENT;
GVAR(precipitation) = GVAR(precipitation) select MONTH_CURRENT;
GVAR(rainfall) = GVAR(rainfall) select MONTH_CURRENT;

// update measurements
[QGVAR(updateMeasurements),[]] call CBA_fnc_localEvent;

// initial weather values are out of bounds to force a new forecast
if (GVAR(overcast) < 0 || {GVAR(rain) < 0} || {GVAR(fog) < 0}) then {
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
            [QGVAR(updateMeasurements),[]] call CBA_fnc_localEvent;

            if !((date select [0,3]) isEqualTo (GVAR(date) select [0,3])) then {
                [QGVAR(updateDate),[]] call CBA_fnc_localEvent;
            };
        },300] call CBA_fnc_addPerFrameHandler;
    }
] call CBA_fnc_waitUntilAndExecute;

// start forecast handler after initial weather
[
    {nextWeatherChange < 1},
    {
        [FUNC(handleForecast),1] call CBA_fnc_addPerFrameHandler;

        if (GVAR(rain) > 0) then {
            [FUNC(handleRain),1800] call CBA_fnc_addPerFrameHandler;
        };
    }
] call CBA_fnc_waitUntilAndExecute;

nil