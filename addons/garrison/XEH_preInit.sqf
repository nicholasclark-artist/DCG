/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(handleArea);
PREP(setArea);
PREP(removeArea);
PREP(setOutpost);
PREP(spawnOutpost);

// headless client exit 
if (!isServer) exitWith {};

SETTINGS_INIT;
