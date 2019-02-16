/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// headless client exit 
if (!isServer) exitWith {};

[[],{
    call FUNC(handleLoadout);
    call FUNC(setRadioSettings);

    INFO("Radio setup finished");
}] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];
