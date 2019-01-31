/*
Author:
Nicholas Clark (SENSEI)

Description:
get rain value

Arguments:

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

// probability of precipitation
private _pRain = [GVAR(precipitation) select ((date select 1) - 1), GVAR(precipitationOverride)] select (GVAR(precipitationOverride) >= 0);

if (PROBABILITY(_pRain)) then {
    // get rainfall amount from map data 
    private _rainfall = GVAR(rainfall) select ((date select 1) - 1);
    // convert rainfall data to 0-1 range 
    _rainfall = linearConversion [_rainfall select 0,_rainfall select 1,_rainfall select 2,0,1,true];
    // adjust rainfall based on current humidity
    _rainfall = _rainfall + GVAR(humidityCurrent) * 0.2;
    
    0 max _rainfall min 1
} else {
    0
};