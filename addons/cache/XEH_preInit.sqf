/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

ADDON = false;

PREP(cache);
PREP(uncache);
PREP(canCache);
PREP(canUncache);
PREP(addEventhandler);

GVAR(groups) = [];