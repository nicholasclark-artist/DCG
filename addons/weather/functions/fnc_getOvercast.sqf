/*
Author:
Nicholas Clark (SENSEI)

Description:
get overcast value

Arguments:

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

// probability of cloud cover
private _pCloud = [GVAR(clouds) select ((date select 1) - 1), GVAR(cloudsOverride)] select (GVAR(cloudsOverride) >= 0);

if (PROBABILITY(_pCloud)) then { // mostly cloudy, overcast
    (0.7 + random 0.31) min 1
} else { // clear, partly cloudy
    random 0.55
};