/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

LOG(MSG_INIT);

PREP(initSettings);
PREP(initCivPresence);
// PREP(handleUnit);
PREP(handleVehicle);
PREP(handleAnimal);
// PREP(spawnUnit);
PREP(spawnVehicle);
PREP(spawnAnimal);
// PREP(setPatrol);

GVAR(drivers) = [];
GVAR(blacklist) = [];

SETTINGS_INIT;
   