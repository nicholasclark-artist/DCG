/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// headless client exit 
if (!isServer) exitWith {};

// setup clients
remoteExecCall [QFUNC(handleClient),0,true];