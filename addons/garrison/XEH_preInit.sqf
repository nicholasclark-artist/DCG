/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(handleOutpost);
PREP(setArea);
PREP(setOutpost);
PREP(spawnOutpost);

GVAR(garrison) = locationNull;
GVAR(commsArray) = locationNull;
GVAR(task) = 0;
// GVAR(cleared) = -1;

// headless client exit 
if (!isServer) exitWith {};

SETTINGS_INIT;
