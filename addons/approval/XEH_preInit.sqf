/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

ADDON = false;

PREP(setValue);
PREP(getValue);
PREP(getRegion);
PREP(handleKilled);

GVAR(mulitplier) = 1;