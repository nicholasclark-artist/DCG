/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(handleUnit);
PREP(handleVehicle);
PREP(handleAnimal);
PREP(spawnVehicle);
PREP(spawnAmbient);

GVAR(drivers) = [];
GVAR(ambient) = [];
GVAR(animalCount) = 0;

SETTINGS_INIT;
   