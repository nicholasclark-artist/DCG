/*
Author:
Nicholas Clark (SENSEI)

Description:
handle rain and associated effects 

Arguments:

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

private _currentRain = rain; 
GVAR(rainForecast) = ([1] call FUNC(getForecast)) select 1;

WEATHER_DELAY_RAIN setRain GVAR(rainForecast);

TRACE_5("",_currentRain,GVAR(rainForecast),overcast,lightnings,rainbow);