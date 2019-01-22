/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// setup clients
remoteExecCall [QFUNC(handleClient),0,true];