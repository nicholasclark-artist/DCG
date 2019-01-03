/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isMultiplayer && {!is3DEN}) exitWith {};

LOG(MSG_INIT);

PREP(initSettings);
PREP(handleLoadData);
PREP(handleIED);

GVAR(list) = [];

SETTINGS_INIT;
