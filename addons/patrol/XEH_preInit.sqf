/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"


LOG(MSG_INIT);

PREP(initSettings);
PREP(handlePatrol);

GVAR(groups) = [];
GVAR(blacklist) = [];

SETTINGS_INIT;
