/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

ADDON = false;

PREP(deploy);
PREP(delete);
PREP(request);
PREP(handleRequest);
PREP(setup);
PREP(getChildren);
PREP(getCuratorCost);
PREP(canDeploy);
PREP(curatorEH);
PREP(recon);

GVAR(location) = locationNull;
GVAR(UID) = "";
GVAR(response) = -1;
GVAR(anchor) = objNull;
GVAR(side) = createCenter sideLogic;
GVAR(group) = createGroup GVAR(side);
GVAR(curator) = GVAR(group) createUnit ["ModuleCurator_F",[0,0,0], [], 0, "FORM"];
//GVAR(AVBonus) = 0;

GVAR(curator) setVariable ["showNotification", false, true];
GVAR(curator) setVariable ["birdType", "", true];
GVAR(curator) setVariable ["Owner", "", true];
//GVAR(curator) setVariable ["Addons", 3, true];
GVAR(curator) setVariable ["Forced", 0, true];

LOG_DEBUG_1("Creating curator %1.",GVAR(curator));

publicVariable QFUNC(request);
publicVariable QFUNC(getChildren);
publicVariable QFUNC(getCuratorCost);
publicVariable QFUNC(deploy);
publicVariable QFUNC(delete);
publicVariable QFUNC(canDeploy);
publicVariable QFUNC(curatorEH);

publicVariable QGVAR(location);
publicVariable QGVAR(UID);
publicVariable QGVAR(response);
publicVariable QGVAR(side);
publicVariable QGVAR(group);
publicVariable QGVAR(curator);
//publicVariable QGVAR(AVBonus);