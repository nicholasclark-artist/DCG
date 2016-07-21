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
PREP(handlerHostile);
PREP(spawnHostile);
PREP(hint);
PREP(canQuestion);
PREP(question);

publicVariable QFUNC(addValue);
publicVariable QFUNC(canQuestion);