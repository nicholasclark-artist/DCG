/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_PREINIT;

ADDON = false;

PREP(initSettings);
PREP(restoreLoadout);

publicVariable QFUNC(initSettings);
publicVariable QFUNC(restoreLoadout);

INITSETTINGS;
