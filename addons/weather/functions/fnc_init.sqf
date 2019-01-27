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

// @todo add fog and PPEffects 

// run after settings init
if (!EGVAR(main,settingsInitFinished)) exitWith {
    EGVAR(main,runAtSettingsInitialized) pushBack [FUNC(init), _this];
};

private _data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);

// load saved data
if !(_data isEqualTo []) then {
    GVAR(iOvercast) = _data select 0;
    GVAR(iRain) = _data select 1;
    GVAR(iFog) = _data select 2;
    GVAR(iDate) = _data select 3;

    GVAR(iMonth) = GVAR(date) select 1;
    GVAR(iHour) = GVAR(date) select 3;
    setDate GVAR(iDate);
} else {
    if (GVAR(iMonth) isEqualTo -1) then {GVAR(iMonth) = ceil random 12};
    if (GVAR(iHour) isEqualTo -1) then {GVAR(iHour) = round random 23};

    // set date before getting forecast
    GVAR(iDate) = [2019, GVAR(iMonth), ceil random 27, GVAR(iHour), round random 30];
    setDate GVAR(iDate);

    // get initial weather values
    private _forecast = [0] call FUNC(getForecast);

    GVAR(iOvercast) = _forecast select 0;
    GVAR(iRain) = _forecast select 1;
    GVAR(iFog) = _forecast select 2;
};

[
    {CBA_missionTime > 0},
    {
        // set starting weather
        [] spawn {
            0 setOvercast GVAR(iOvercast);
            0 setFog GVAR(iFog);
            WEATHER_DELAY_RAIN setRain GVAR(iRain);

            forceWeatherChange;

            TRACE_4("Initial forecast",nextWeatherChange,GVAR(iOvercast),GVAR(iRain),GVAR(iFog));
        };
        
        // handle date changes 
        [{
            if (!((date select 0) isEqualTo (GVAR(iDate) select 0)) || {!((date select 1) isEqualTo (GVAR(iDate) select 1))}) then {
                [QGVAR(dateChange), []] call CBA_fnc_localEvent;
            };
        }, 600] call CBA_fnc_addPerFrameHandler;
    }
] call CBA_fnc_waitUntilAndExecute;

// start forecast handler after initial weather
[
    {nextWeatherChange < 1},
    {
        INFO("Handling forecast");

        [FUNC(handleForecast), 1] call CBA_fnc_addPerFrameHandler;

        if (GVAR(iRain) > 0) then {
            [FUNC(handleRain), 1800] call CBA_fnc_addPerFrameHandler;
        };
    }
] call CBA_fnc_waitUntilAndExecute;

nil