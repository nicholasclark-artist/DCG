/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_INIT;

ADDON = false;

PREP(handleRequest);
PREP(request);
PREP(getChildren);
PREP(canCallTransport);

GVAR(ready) = 1;
GVAR(count) = 0;
GVAR(wait) = false;

publicVariable QFUNC(request);
publicVariable QFUNC(canCallTransport);
publicVariable QFUNC(getChildren);
publicVariable QGVAR(ready);
publicVariable QGVAR(count);
publicVariable QGVAR(wait);
