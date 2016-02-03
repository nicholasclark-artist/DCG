/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

ADDON = false;

PREP(deploy);
PREP(delete);
PREP(request);
PREP(requestAnswer);
PREP(requestReceive);
PREP(requestHandler);
PREP(setup);
PREP(getChildren);
PREP(canDeploy);
PREP(curatorEH);

GVAR(location) = locationNull;
GVAR(UID) = "";
GVAR(response) = -1;
GVAR(flag) = objNull;

publicVariable QFUNC(request);
publicVariable QFUNC(requestReceive);
publicVariable QFUNC(requestAnswer);
publicVariable QFUNC(getChildren);
publicVariable QFUNC(deploy);
publicVariable QFUNC(canDeploy);
publicVariable QFUNC(curatorEH);
publicVariable QGVAR(location);
publicVariable QGVAR(UID);
publicVariable QGVAR(response);