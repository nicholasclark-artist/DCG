/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(restoreLoadout);
PREP(handleClient);

GVAR(handleDisconnectID) = -1;

publicVariable QFUNC(restoreLoadout);
publicVariable QFUNC(handleClient);

SETTINGS_INIT;
