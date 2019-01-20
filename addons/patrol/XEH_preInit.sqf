/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(handlePatrol);

GVAR(groups) = [];
GVAR(blacklist) = [];

SETTINGS_INIT;
