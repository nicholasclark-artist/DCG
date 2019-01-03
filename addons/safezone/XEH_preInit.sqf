/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isMultiplayer && {!is3DEN}) exitWith {};

LOG(MSG_INIT);

PREP(initSettings);
PREP(init);
PREP(inAreaAll);

GVAR(list) = [];
GVAR(markers) = [];

SETTINGS_INIT;
