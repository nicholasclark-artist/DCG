/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isMultiplayer && {!is3DEN}) exitWith {};

LOG(MSG_INIT);

PREP(initSettings);
PREP(handleUnit);
PREP(handleVehicle);
PREP(handleAnimal);
PREP(spawnUnit);
PREP(spawnVehicle);
PREP(spawnAnimal);
PREP(setPatrol);

GVAR(drivers) = [];
GVAR(blacklist) = [];

SETTINGS_INIT;
