/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_PREINIT;

// ADDON = false;
LOG(MSG_INIT);

PREP(initSettings);
PREP(findLocation);
PREP(handleLoadData);
PREP(handleOccupied);
PREP(setOccupied);

GVAR(location) = [];

publicVariable QFUNC(initSettings);

SETTINGS_INIT;
