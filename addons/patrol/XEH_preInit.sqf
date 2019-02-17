/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(handlePatrol);

GVAR(groups) = [];

// headless client exit 
if (!isServer) exitWith {};

SETTINGS_INIT;
