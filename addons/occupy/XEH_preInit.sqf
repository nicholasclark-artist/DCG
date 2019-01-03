/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isMultiplayer && {!is3DEN}) exitWith {};

LOG(MSG_INIT);

PREP(initSettings);
PREP(findLocation);
PREP(handleLoadData);
PREP(handleOccupied);
PREP(setOccupied);

GVAR(location) = [];

SETTINGS_INIT;
