/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_PREINIT;

ADDON = false;

PREP(initSettings);
PREP(handleLoadData);

GVAR(list) = [];

publicVariable QFUNC(initSettings);

INITSETTINGS;
