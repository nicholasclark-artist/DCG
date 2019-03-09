/*
Author:
Nicholas Clark (SENSEI)

Description:
handle headless client

Arguments:
0: headless client object <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

params ["_hc"];

if (_hc isEqualTo GVAR(HC)) exitWith {};

GVAR(HC) = _hc; 

INFO_1("headless client connected: %1",GVAR(HC));

nil