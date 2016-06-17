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
PREP(hint);
PREP(onCivQuestion);

GVAR(mulitplier) = 1;