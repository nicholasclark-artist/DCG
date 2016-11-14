/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_INIT;

ADDON = false;

PREP(addValue);
PREP(getValue);
PREP(getRegion);
PREP(handleLoadData);
PREP(handleKilled);
PREP(handleClient);
PREP(handleQuestion);
PREP(handleHostile);
PREP(handleHint);
PREP(spawnHostile);

publicVariable QFUNC(handleKilled);
publicVariable QFUNC(handleClient);
