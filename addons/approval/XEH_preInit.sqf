/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(addValue);
PREP(getValue);
PREP(getRegion);
PREP(handleLoadData);
PREP(handleKilled);
PREP(handleClient);
PREP(handleQuestion);
PREP(handleHostile);
PREP(handleHint);
PREP(handleStop);
PREP(spawnHostile);

GVAR(regions) = [];

publicVariable QFUNC(handleKilled);
publicVariable QFUNC(handleClient);

SETTINGS_INIT;
    