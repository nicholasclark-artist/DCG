/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

ADDON = false;

PREP(handlerUnit);
PREP(handlerVeh);
PREP(handlerAnimal);
PREP(spawnUnit);
PREP(spawnVeh);
PREP(spawnAnimal);
PREP(setHostile);

GVAR(vehicles) = [];