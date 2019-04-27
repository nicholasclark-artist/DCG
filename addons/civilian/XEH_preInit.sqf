/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(parseLocations);
PREP(handleLocation);
PREP(handleVehicle);
PREP(handleAnimal);
PREP(handlePatrol);
PREP(spawnUnit);
PREP(spawnVehicle);
PREP(spawnAmbient);
PREP(setPanic);
PREP(commandeer);

GVAR(locations) = [];
GVAR(drivers) = [];
GVAR(animalCount) = 0;

// headless client exit 
if (!isServer) exitWith {};

SETTINGS_INIT;
   