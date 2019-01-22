/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

[[],{
    call FUNC(handleLoadout);
    call FUNC(setRadioSettings);

    INFO("Radio setup finished");
}] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];
