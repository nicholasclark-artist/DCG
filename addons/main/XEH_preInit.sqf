/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

ADDON = false;

PREP(arsenal);
PREP(cleanup);
PREP(findHousePos);
PREP(replaceString);
PREP(findOverwatchPos);
PREP(findPosGrid);
PREP(findRandomPos);
PREP(findRuralFlatPos);
PREP(findRuralHousePos);
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
PREP(displayText);
PREP(removeAction);
PREP(removeParticle);
PREP(saveInventory);
PREP(setAction);
PREP(setSettings);
PREP(setSettingsFromConfig);
PREP(exportSettings);
PREP(setOwner);
PREP(setTask);
PREP(setTaskState);
PREP(setParams);
PREP(setPatrol);
PREP(setSide);
PREP(setStrength);
PREP(setTime);
PREP(setUnitDamaged);
PREP(setSurrender);
PREP(setVehDamaged);
PREP(setWaypointPos);
PREP(spawnBase);
PREP(spawnBaseSmall);
PREP(spawnGroup);
PREP(spawnReinforcements);
PREP(spawnSniper);
PREP(spawnSquad);
PREP(spawnStatic);

GVAR(settings) = [];
GVAR(locations) = [];
GVAR(mobLocation) = locationNull;
GVAR(range) = worldSize*0.5;
GVAR(center) = [GVAR(range),GVAR(range),0];
GVAR(enemySide) = EAST;
GVAR(markerCleanup) = [];
GVAR(objectCleanup) = [];
GVAR(saveDataCurrent) = [DATA_MISSION_ID];

publicVariable QUOTE(ADDON);
publicVariable QFUNC(arsenal);
publicVariable QFUNC(cleanup);
publicVariable QFUNC(findHousePos);
publicVariable QFUNC(replaceString);
publicVariable QFUNC(findOverwatchPos);
publicVariable QFUNC(findPosGrid);
publicVariable QFUNC(findRandomPos);
publicVariable QFUNC(findRuralFlatPos);
publicVariable QFUNC(findRuralHousePos);
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
publicVariable QFUNC(setAction);
//publicVariable QFUNC(setSettings);
//publicVariable QFUNC(setSettingsFromConfig);
//publicVariable QFUNC(setOwner);
//publicVariable QFUNC(setParams);
publicVariable QFUNC(setPatrol);
publicVariable QFUNC(setSide);
publicVariable QFUNC(setStrength);
publicVariable QFUNC(setTime);
publicVariable QFUNC(setUnitDamaged);
publicVariable QFUNC(setSurrender);
publicVariable QFUNC(setVehDamaged);
publicVariable QFUNC(setWaypointPos);
publicVariable QFUNC(spawnBase);
publicVariable QFUNC(spawnBaseSmall);
publicVariable QFUNC(spawnGroup);
publicVariable QFUNC(spawnReinforcements);
publicVariable QFUNC(spawnSniper);
publicVariable QFUNC(spawnSquad);
publicVariable QFUNC(spawnStatic);
publicVariable QFUNC(inBuilding);

publicVariable QGVAR(range);
publicVariable QGVAR(center);
publicVariable QGVAR(enemySide);
publicVariable QGVAR(markerCleanup);
publicVariable QGVAR(objectCleanup);

call FUNC(setSettings);
call FUNC(loadData);