/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(handleGroups);
PREP(enable);
PREP(disable);

// headless client exit 
if (!isServer) exitWith {};

SETTINGS_INIT;
