/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

LOG(MSG_INIT);

PREP(initSettings);
PREP(handleUnit);
PREP(handleVehicle);
PREP(handleAnimal);
PREP(spawnVehicle);
PREP(spawnAnimal);

GVAR(drivers) = [];
GVAR(blacklist) = [];

SETTINGS_INIT;
   