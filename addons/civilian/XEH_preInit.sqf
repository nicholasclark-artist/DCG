/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

ADDON = false;

PREP(handleUnit);
PREP(handleVehicle);
PREP(handleAnimal);
PREP(spawnUnit);
PREP(spawnVehicle);
PREP(spawnAnimal);

GVAR(drivers) = [];
GVAR(blacklist) = [];