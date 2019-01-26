    /*
Author:
Nicholas Clark (SENSEI)

Description:
get overcast value from map data

Arguments:
0: world name

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

private _p = random 1;
private _cloudCover = GVAR(cloudCover) select ((date select 1) - 1);

call {
    if (_p > (_cloudCover select 0) && {_p <= (_cloudCover select 1)}) exitWith {0.25 + WEATHER_VARIANCE}; // mostly clear
    if (_p > (_cloudCover select 1) && {_p <= (_cloudCover select 2)}) exitWith {0.5 + WEATHER_VARIANCE}; // partly cloudy
    if (_p > (_cloudCover select 2) && {_p <= (_cloudCover select 3)}) exitWith {0.75 + WEATHER_VARIANCE}; // mostly 
    if (_p > (_cloudCover select 3)) exitWith {1}; // overcast

    0 + WEATHER_VARIANCE // clear
};
