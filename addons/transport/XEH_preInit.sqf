/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_PREINIT;

ADDON = false;

PREP(initSettings);
PREP(handleRequest);
PREP(request);
PREP(getChildren);
PREP(canCallTransport);

GVAR(status) = TR_READY;
GVAR(count) = 0;

publicVariable QFUNC(request);
publicVariable QFUNC(handleRequest);
publicVariable QFUNC(canCallTransport);
publicVariable QFUNC(getChildren);

publicVariable QGVAR(status);
publicVariable QGVAR(count);
publicVariable QGVAR(initSettings);

INITSETTINGS;
