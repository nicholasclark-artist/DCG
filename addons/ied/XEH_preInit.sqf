/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(handleIED);
PREP(init);

GVAR(list) = [];

// headless client exit 
if (!isServer) exitWith {};

SETTINGS_INIT;
