/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

ADDON = false;

PREP(addValue);
PREP(getValue);
PREP(getRegion);
PREP(handleKilled);
PREP(handleHostile);
PREP(spawnHostile);
PREP(hint);
PREP(question);

publicVariable QFUNC(getRegion);
publicVariable QFUNC(addValue);
publicVariable QFUNC(question);