/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(findLocation);
PREP(init);
PREP(handleOccupied);
PREP(setOccupied);

GVAR(location) = [];

SETTINGS_INIT;
