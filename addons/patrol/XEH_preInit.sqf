/*
Author: Nicholas Clark (SENSEI)

Last modified: 10/30/2015

Description:
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

ADDON = false;

PREP(PFH);
PREP(debug);

GVAR(groups) = [];
GVAR(groupsDynamic) = [];