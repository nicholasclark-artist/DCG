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
GVAR(side) = createCenter sideLogic;
GVAR(group) = createGroup GVAR(side);
GVAR(curator) = GVAR(group) createUnit ["ModuleCurator_F",[0,0,0], [], 0, "FORM"];

GVAR(curator) setVariable ["showNotification", false, true];
GVAR(curator) setVariable ["birdType", "", true];
GVAR(curator) setVariable ["Owner", "", true];
GVAR(curator) setVariable ["Addons", 3, true];
GVAR(curator) setVariable ["Forced", 0, true];

LOG_DEBUG_1("Creating curator %1.",GVAR(curator));

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
publicVariable QGVAR(side);
publicVariable QGVAR(group);
publicVariable QGVAR(curator);