/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(init);
PREP(initSettings);
PREP(handleIntel);
PREP(handlePatrol);
PREP(setArea);
PREP(setGarrison);
PREP(setOutpost);
PREP(setComm);
PREP(setTask);
PREP(getName);
PREP(removeOutpost);
PREP(removeArea);
PREP(spawnArea);
PREP(spawnGarrison);
PREP(spawnOutpost);
PREP(spawnComm);
PREP(spawnPrefab);
PREP(spawnUnit);
PREP(taskOPORD);

// headless client exit
if (!isServer) exitWith {};

GVAR(aliasBlacklist) = [];
GVAR(intel) = objNull;
GVAR(patrolGroups) = [];

SETTINGS_INIT;
