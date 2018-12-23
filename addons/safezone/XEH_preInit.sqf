/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_PREINIT;

// ADDON = false;
LOG(MSG_INIT);

PREP(initSettings);
PREP(init);
PREP(inAreaAll);

GVAR(list) = [];

publicVariable QFUNC(initSettings);

SETTINGS_INIT;
