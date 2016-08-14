/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

ADDON = false;

PREP(restoreLoadout);

publicVariable QFUNC(restoreLoadout);