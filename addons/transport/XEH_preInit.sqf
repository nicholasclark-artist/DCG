/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

LOG(MSG_INIT);

PREP(initSettings);
PREP(handleClient);
PREP(handleRequest);
PREP(request);
PREP(getChildren);
PREP(canCallTransport);

GVAR(status) = TR_STATE_READY;
GVAR(count) = 0;

publicVariable QFUNC(request);
publicVariable QFUNC(handleClient);
publicVariable QFUNC(canCallTransport);
publicVariable QFUNC(getChildren);

publicVariable QGVAR(status);
publicVariable QGVAR(count);

SETTINGS_INIT;
