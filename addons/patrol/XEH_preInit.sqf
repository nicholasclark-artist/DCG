/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

ADDON = false;

PREP(PFH);
PREP(debug);

GVAR(groups) = [];
GVAR(groupsDynamic) = [];