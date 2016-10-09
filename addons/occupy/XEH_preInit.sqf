/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

ADDON = false;

PREP(findLocation);
PREP(handleLoadData);
PREP(handleOccupied);
PREP(setOccupied);

GVAR(locations) = [];