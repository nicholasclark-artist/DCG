    /*
Author:
Nicholas Clark (SENSEI)

Description:
get rainfall value from map data

Arguments:
0: world name

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

private _p = GVAR(precipitation) select ((date select 1) - 1);

if (PROBABILITY(_p)) then {
    private _rainfall = GVAR(rainfall) select ((date select 1) - 1);

    // convert rainfall data to 0-1 range 
    ((linearConversion [_rainfall select 1,_rainfall select 2,_rainfall select 0,0,1,true]) + random 0.1) min 1;
} else {
    0
};