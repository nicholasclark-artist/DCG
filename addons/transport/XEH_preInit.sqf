/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

ADDON = false;

PREP(handleRequest);
PREP(request);
PREP(getChildren);
PREP(canCallTransport);

GVAR(ready) = 1;
GVAR(count) = 0;
GVAR(wait) = false;
GVAR(exfil) = [];
GVAR(infil) = [];

publicVariable QFUNC(handleRequest);
publicVariable QFUNC(request);
publicVariable QFUNC(canCallTransport);
publicVariable QFUNC(getChildren);
publicVariable QGVAR(ready);
publicVariable QGVAR(count);
publicVariable QGVAR(wait);
publicVariable QGVAR(exfil);
publicVariable QGVAR(infil);