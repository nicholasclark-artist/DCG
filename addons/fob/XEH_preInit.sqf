/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

ADDON = false;

PREP(handleCreate);
PREP(handleDelete);
PREP(handleTransfer);
PREP(handleLoadData);
PREP(handleClient);
PREP(getKeybind);
PREP(getChildren);
PREP(getCuratorCost);
PREP(canCreate);
PREP(canAddAction);
PREP(curatorEH);
PREP(recon);
PREP(createOnClient);
PREP(deleteOnClient);

GVAR(location) = locationNull;
GVAR(respawnPos) = [];
GVAR(anchor) = objNull;
GVAR(side) = createCenter sideLogic;
GVAR(group) = createGroup GVAR(side);

GVAR(curator) = GVAR(group) createUnit ["ModuleCurator_F",[0,0,0], [], 0, "FORM"];
GVAR(curator) setVariable ["showNotification", false, true];
GVAR(curator) setVariable ["birdType", "", true];
GVAR(curator) setVariable ["Owner", "", true];
GVAR(curator) setVariable ["Addons", 3, true];
GVAR(curator) setVariable ["Forced", 0, true];

INFO_1("Init curator %1",GVAR(curator));

publicVariable QFUNC(getKeybind);
publicVariable QFUNC(getChildren);
publicVariable QFUNC(getCuratorCost);
publicVariable QFUNC(canCreate);
publicVariable QFUNC(canAddAction);
publicVariable QFUNC(curatorEH);
publicVariable QFUNC(createOnClient);
publicVariable QFUNC(deleteOnClient);
publicVariable QFUNC(handleClient);

publicVariable QGVAR(location);
publicVariable QGVAR(side);
publicVariable QGVAR(group);
publicVariable QGVAR(curator);
