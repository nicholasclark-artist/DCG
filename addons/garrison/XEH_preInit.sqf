/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(init);
PREP(initSettings);
PREP(handleArea);
PREP(setArea);
PREP(setGarrison);
PREP(setOutpost);
PREP(setTask);
PREP(removeArea);
PREP(spawnOutpost);
PREP(taskOPORD);

// headless client exit 
if (!isServer) exitWith {};

GVAR(score) = 0;

SETTINGS_INIT;
