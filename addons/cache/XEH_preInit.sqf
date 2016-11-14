/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_INIT;

ADDON = false;

PREP(cache);
PREP(uncache);
PREP(canCache);
PREP(canUncache);
PREP(handleCache);
PREP(addEventhandler);

GVAR(groups) = [];