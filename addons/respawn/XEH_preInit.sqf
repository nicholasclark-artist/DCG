/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_PREINIT;

// ADDON = false;
LOG(MSG_INIT);

PREP(initSettings);
PREP(restoreLoadout);

publicVariable QFUNC(initSettings);
publicVariable QFUNC(restoreLoadout);

SETTINGS_INIT;
