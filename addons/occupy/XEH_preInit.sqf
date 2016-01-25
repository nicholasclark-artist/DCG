/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

ADDON = false;

PREP(findLocation);
PREP(PFH);
PREP(setOccupied);
PREP(addIntel);

GVAR(locations) = [];