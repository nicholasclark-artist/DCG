/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

ADDON = false;

PREP(getGroups);
PREP(handler);
PREP(cache);
PREP(uncache);
PREP(leaderEH);

GVAR(groups) = [];