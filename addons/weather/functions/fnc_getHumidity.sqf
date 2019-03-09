/*
Author:
ACE2 Team, Nicholas Clark (SENSEI)

Description:
get current relative humidity

Arguments:

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

if (CHECK_ADDON_1(ace_weather) && {!isNil "ace_weather_currentHumidity"}) exitWith {
    GVAR(humidityCurrent) = ace_weather_currentHumidity;
    GVAR(humidityCurrent)
};

GVAR(humidityCurrent) = if (rain > 0) then {
    1
} else {
    private _temperature = call FUNC(getTemperature);
    private _month = date select 1;
    private _humidity = GVAR(humidity) select (_month - 1);
    _humidity = _humidity + (random [-0.2,0,0.2]);
    private _avgTemperature = ((GVAR(tempDay) select (_month - 1)) + (GVAR(tempNight) select (_month - 1))) / 2;
    private _pS1 = 6.112 * exp((17.62 * _avgTemperature) / (243.12 + _avgTemperature));
    private _pS2 = 6.112 * exp((17.62 * _temperature) / (243.12 + _temperature));
    _humidity = _humidity * _pS1 / _pS2;

    0 max _humidity min 1
};

GVAR(humidityCurrent)