/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(initClient);
PREP(handleRequest);
PREP(request);
PREP(getChildren);
PREP(canCallTransport);

GVAR(status) = TR_STATE_READY;
GVAR(count) = 0;

// headless client exit 
if (!isServer) exitWith {};

publicVariable QFUNC(request);
publicVariable QFUNC(initClient);
publicVariable QFUNC(canCallTransport);
publicVariable QFUNC(getChildren);

publicVariable QGVAR(status);
publicVariable QGVAR(count);

SETTINGS_INIT;
