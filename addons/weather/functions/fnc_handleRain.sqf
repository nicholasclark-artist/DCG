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
GVAR(mRain) = ([1] call FUNC(getForecast)) select 1;

WEATHER_DELAY_RAIN setRain GVAR(mRain);

TRACE_5("",GVAR(mRain),_currentRain,overcast,lightnings,rainbow);