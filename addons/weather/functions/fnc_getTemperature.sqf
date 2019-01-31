/*
Author:
ACE2 Team, Nicholas Clark (SENSEI)

Description:
get current temperature

Arguments:

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

if (CHECK_ADDON_1(ace_weather) && {!isNil "ace_weather_currentTemperature"}) exitWith {
    GVAR(temperatureCurrent) = ace_weather_currentTemperature;
    GVAR(temperatureCurrent)
};

private _month = date select 1;
private _timeRatio = abs(daytime - 12) / 12;

private _temperature = (GVAR(tempDay) select (_month - 1)) * (1 - _timeRatio) + (GVAR(tempNight) select (_month - 1)) * _timeRatio;
private _tempRandom = random [-4,0,4];
private _weatherRandom = random [0,9,5];

_temperature = _temperature + _tempRandom - _weatherRandom * overcast; 

GVAR(temperatureCurrent) = round(_temperature * 10) / 10;

GVAR(temperatureCurrent)