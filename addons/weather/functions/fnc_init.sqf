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
    GVAR(date) = _data select 0;
    GVAR(overcast) = _data select 1;
    GVAR(rain) = _data select 2;
    GVAR(fog) = _data select 3;
} else {
    // get starting date
    if (GVAR(month) isEqualTo -1) then {GVAR(month) = ceil random 12};
    if (GVAR(time) isEqualTo -1) then {GVAR(time) = round random 23};

    [
        {CBA_missionTime > 0},
        {
            GVAR(date) = [missionStart select 0, GVAR(month), ceil random 27, GVAR(time), round random 30];

            // set starting weather
            [] spawn {
                // must set date before getting weather values
                setDate GVAR(date);

                // get weather values
                GVAR(overcast) = call FUNC(getOvercast);
                GVAR(rain) = call FUNC(getRain);

                0 setOvercast GVAR(overcast);
                0 setRain GVAR(rain);
                // 0 setFog GVAR(fog);

                forceWeatherChange;

                TRACE_4("",GVAR(cycle),GVAR(overcast),GVAR(rain),GVAR(fog));
                TRACE_6("",nextWeatherChange,overcast,overcastForecast,fogParams,fogForecast,rain);
               
                GVAR(cycle) = GVAR(cycle) + 1;
            };
        }
    ] call CBA_fnc_waitUntilAndExecute;
    
    // start forecast handler after starting weather set
    [
        {GVAR(cycle) > 0},
        {
            // handle further weather cycles
            [FUNC(handleForecast), 1] call CBA_fnc_addPerFrameHandler;
        }
    ] call CBA_fnc_waitUntilAndExecute;
};

nil