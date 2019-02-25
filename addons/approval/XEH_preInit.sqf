/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(init);
PREP(initClient);
PREP(addValue);
PREP(getRegion);
PREP(handleKilled);
PREP(handleQuestion);
PREP(handleHostile);
PREP(handleHint);
PREP(handleStop);
PREP(spawnHostile);

GVAR(regions) = [];

// headless client exit 
if (!isServer) exitWith {};

publicVariable QFUNC(handleKilled);
publicVariable QFUNC(initClient);

SETTINGS_INIT;
    