/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_PREINIT;

ADDON = false;

PREP(initSettings);
PREP(handleLoadData);
PREP(handleIED);

GVAR(list) = [];

publicVariable QFUNC(initSettings);

SETTINGS_INIT;
