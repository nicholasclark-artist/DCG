/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(handleCache);
PREP(disableCache);

// headless client exit 
if (!isServer) exitWith {};

SETTINGS_INIT;
