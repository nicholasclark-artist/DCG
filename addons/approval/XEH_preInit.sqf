/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(init);
PREP(initClient);
PREP(setValue);
PREP(getRegion);
PREP(handleKilled);
PREP(handleQuestion);
PREP(handleHint);
PREP(handleStop);

GVAR(regions) = [];

// headless client exit
if (!isServer) exitWith {};

publicVariable QFUNC(handleKilled);
publicVariable QFUNC(initClient);

SETTINGS_INIT;
