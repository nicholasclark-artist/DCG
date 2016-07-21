/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

ADDON = false;

PREP(arsenal);
PREP(createLocation);
PREP(cleanup);
PREP(findHousePos);
PREP(replaceString);
PREP(findOverwatchPos);
PREP(findPosGrid);
PREP(findRandomPos);
PREP(findRuralPos);
PREP(getNearPlayers);
PREP(getPlayers);
PREP(saveData);
PREP(saveDataClient);
PREP(deleteDataClient);
PREP(loadData);
PREP(loadDataAddon);
PREP(loadInventory);
PREP(log);
PREP(inBuilding);
PREP(inLOS);
PREP(displayText);
PREP(removeAction);
PREP(removeParticle);
PREP(saveInventory);
PREP(setAction);
PREP(setSettings);
PREP(setSettingsFromConfig);
PREP(exportSettings);
PREP(exportObjects);
PREP(shuffle);
PREP(setOwner);
PREP(setTask);
PREP(setTaskState);
PREP(setParams);
PREP(setPatrol);
PREP(setSide);
PREP(setAnim);
PREP(setStrength);
PREP(setTimer);
PREP(setUnitDamaged);
PREP(setSurrender);
PREP(setVehDamaged);
PREP(setWaypointPos);
PREP(spawnBase);
PREP(spawnGroup);
PREP(spawnReinforcements);
PREP(spawnSniper);
PREP(spawnStatic);

GVAR(settings) = [];
GVAR(locations) = [];
GVAR(baseLocation) = locationNull;
GVAR(range) = worldSize*0.5;
GVAR(center) = [GVAR(range),GVAR(range),0];
GVAR(playerSide) = WEST;
GVAR(enemySide) = EAST;
GVAR(markerCleanup) = [];
GVAR(objectCleanup) = [];
GVAR(saveDataCurrent) = [DATA_MISSION_ID];
GVAR(actions) = [];

publicVariable QUOTE(ADDON);
publicVariable QFUNC(arsenal);
publicVariable QFUNC(createLocation);
publicVariable QFUNC(cleanup);
publicVariable QFUNC(findHousePos);
publicVariable QFUNC(replaceString);
publicVariable QFUNC(findOverwatchPos);
publicVariable QFUNC(findPosGrid);
publicVariable QFUNC(findRandomPos);
publicVariable QFUNC(findRuralPos);
publicVariable QFUNC(getNearPlayers);
publicVariable QFUNC(getPlayers);
publicVariable QFUNC(loadInventory);
publicVariable QFUNC(log);
publicVariable QFUNC(saveDataClient);
publicVariable QFUNC(deleteDataClient);
publicVariable QFUNC(displayText);
publicVariable QFUNC(removeAction);
publicVariable QFUNC(removeParticle);
publicVariable QFUNC(saveInventory);
publicVariable QFUNC(shuffle);
publicVariable QFUNC(setAction);
publicVariable QFUNC(setPatrol);
publicVariable QFUNC(setSide);
publicVariable QFUNC(setAnim);
publicVariable QFUNC(setStrength);
publicVariable QFUNC(setTimer);
publicVariable QFUNC(setUnitDamaged);
publicVariable QFUNC(setSurrender);
publicVariable QFUNC(setVehDamaged);
publicVariable QFUNC(setWaypointPos);
publicVariable QFUNC(spawnBase);
publicVariable QFUNC(spawnGroup);
publicVariable QFUNC(spawnReinforcements);
publicVariable QFUNC(spawnSniper);
publicVariable QFUNC(spawnStatic);
publicVariable QFUNC(inBuilding);
publicVariable QFUNC(inLOS);

publicVariable QGVAR(range);
publicVariable QGVAR(center);
publicVariable QGVAR(enemySide);
publicVariable QGVAR(playerSide);
publicVariable QGVAR(markerCleanup);
publicVariable QGVAR(objectCleanup);
publicVariable QGVAR(actions);

call FUNC(setSettings);
call FUNC(loadData);