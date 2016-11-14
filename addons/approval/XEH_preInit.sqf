/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

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
