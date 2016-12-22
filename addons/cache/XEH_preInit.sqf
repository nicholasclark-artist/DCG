/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_PREINIT;

ADDON = false;

PREP(initSettings);
PREP(cache);
PREP(uncache);
PREP(canCache);
PREP(canUncache);
PREP(handleCache);
PREP(addEventhandler);

GVAR(groups) = [];

publicVariable QFUNC(initSettings);

INITSETTINGS;
