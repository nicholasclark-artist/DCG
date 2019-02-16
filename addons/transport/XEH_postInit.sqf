/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// headless client exit 
if (!isServer) exitWith {};

// eventhandlers
[QGVAR(request), {_this call FUNC(handleRequest)}] call CBA_fnc_addEventHandler;

// setup client
remoteExecCall [QFUNC(initClient), 0, true];