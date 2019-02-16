/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(init);
PREP(initClient);
PREP(handleAssign);
PREP(handleCreate);
PREP(handleDelete);
PREP(handleTransfer);
PREP(handleLoadData);
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

// headless client exit 
if (!isServer) exitWith {};

publicVariable QFUNC(getKeybind);
publicVariable QFUNC(getChildren);
publicVariable QFUNC(getCuratorCost);
publicVariable QFUNC(isAllowedOwner);
publicVariable QFUNC(curatorEH);
publicVariable QFUNC(initClient);

publicVariable QGVAR(location);

SETTINGS_INIT;
