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
PREP(handleKilled);
PREP(handleHostile);
PREP(spawnHostile);
PREP(hint);
PREP(question);

publicVariable QFUNC(handleKilled);