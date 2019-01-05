/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

LOG(MSG_INIT);

PREP(initSettings);
PREP(init);
PREP(handleAssign);
PREP(handleCreate);
PREP(handleDelete);
PREP(handleTransfer);
PREP(handleLoadData);
PREP(handleClient);
PREP(handleRecon);
PREP(getKeybind);
PREP(getChildren);
PREP(getCuratorCost);
PREP(isAllowedOwner);
PREP(curatorEH);

GVAR(location) = locationNull;
GVAR(respawnPos) = [];
GVAR(anchor) = objNull;
GVAR(curatorExternal) = objNull;
GVAR(placeCoef) = -0.025;
GVAR(deleteCoef) = 0.025;

publicVariable QFUNC(getKeybind);
publicVariable QFUNC(getChildren);
publicVariable QFUNC(getCuratorCost);
publicVariable QFUNC(isAllowedOwner);
publicVariable QFUNC(curatorEH);
publicVariable QFUNC(handleClient);

publicVariable QGVAR(location);

SETTINGS_INIT;
