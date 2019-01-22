/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(initClient);
PREP(addValue);
PREP(getValue);
PREP(getRegion);
PREP(handleLoadData);
PREP(handleKilled);
PREP(handleQuestion);
PREP(handleHostile);
PREP(handleHint);
PREP(handleStop);
PREP(spawnHostile);

GVAR(regions) = [];

publicVariable QFUNC(handleKilled);
publicVariable QFUNC(initClient);

SETTINGS_INIT;
    