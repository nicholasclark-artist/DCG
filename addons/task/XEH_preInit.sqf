/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

ADDON = false;

PREP(select);
PREP(cancel);

PREP(pVip);
PREP(pCache);
PREP(pOfficer);
PREP(pDefend);
PREP(sDeliver);
PREP(sRepair);

GVAR(primary) = [];
GVAR(secondary) = [];

publicVariable QFUNC(cancel);
publicVariable QGVAR(primary);
publicVariable QGVAR(secondary);