/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// eventhandlers
[QGVARMAIN(settingsInitialized), {
    call FUNC(handleLoadData);
}] call CBA_fnc_addEventHandler;