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
PREP(commandeer);

GVAR(drivers) = [];
GVAR(animalCount) = 0;

// headless client exit 
if (!isServer) exitWith {};

SETTINGS_INIT;
   