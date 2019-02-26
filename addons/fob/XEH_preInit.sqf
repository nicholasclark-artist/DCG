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

GVAR(respawnPos) = [];
GVAR(anchor) = objNull;
GVAR(curatorExternal) = objNull;
GVAR(placeCoef) = -0.025;
GVAR(deleteCoef) = 0.025;

// headless client exit 
if (!isServer) exitWith {};

// define location via remoteExec instead of publicVariable to avoid SimpleSerialization warning
[[],{
    GVAR(location) = locationNull;
}] remoteExecCall [QUOTE(BIS_fnc_call),0];

publicVariable QFUNC(getKeybind);
publicVariable QFUNC(getChildren);
publicVariable QFUNC(getCuratorCost);
publicVariable QFUNC(isAllowedOwner);
publicVariable QFUNC(curatorEH);
publicVariable QFUNC(initClient);

SETTINGS_INIT;
