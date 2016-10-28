/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

ADDON = false;

PREP(init); // do not change
call FUNC(init); // do not change

if ((GVAR(enable) isEqualTo 0) || {!isServer}) exitWith {};

PREP(debug);
PREP(handleLoadData);
PREP(handleCleanup);
PREP(handleSafezone);
PREP(setDebugMarker);
PREP(removeDebugMarker);
PREP(armory);
PREP(arsenal);
PREP(createLocation);
PREP(cleanup);
PREP(findPosHouse);
PREP(replaceString);
PREP(findPosOverwatch);
PREP(findPosGrid);
PREP(findPosSafe);
PREP(findPos);
PREP(getNearPlayers);
PREP(saveData);
PREP(saveDataClient);
PREP(deleteDataClient);
PREP(loadData);
PREP(loadDataAddon);
PREP(loadInventory);
PREP(inBuilding);
PREP(inLOS);
PREP(isPosSafe);
PREP(displayText);
PREP(removeAction);
PREP(removeParticle);
PREP(saveInventory);
PREP(setAction);
PREP(setSettingsValue);
PREP(setSettings);
PREP(setSettingsConfig);
PREP(setSettingsParams);
PREP(exportSettings);
PREP(exportBase);
PREP(shuffle);
PREP(setOwner);
PREP(setTask);
PREP(setTaskState);
PREP(setPatrol);
PREP(setSide);
PREP(setAnim);
PREP(setStrength);
PREP(setTimer);
PREP(setUnitDamaged);
PREP(setSurrender);
PREP(setVehDamaged);
PREP(setWaypointPos);
PREP(setPosSafe);
PREP(spawnBase);
PREP(spawnGroup);
PREP(spawnReinforcements);
PREP(spawnSniper);
PREP(spawnStatic);

GVAR(locations) = [];
GVAR(locals) = [];
GVAR(hills) = [];
GVAR(marines) = [];
GVAR(baseLocation) = locationNull;
GVAR(range) = worldSize*0.5;
GVAR(center) = [GVAR(range),GVAR(range),0];
GVAR(playerSide) = WEST;
GVAR(enemySide) = EAST;
GVAR(markerCleanup) = [];
GVAR(objectCleanup) = [];
GVAR(saveDataCurrent) = [DATA_MISSION_ID];
GVAR(debugMarkers) = [];

publicVariable QUOTE(ADDON);
publicVariable QFUNC(armory);
publicVariable QFUNC(arsenal);
publicVariable QFUNC(createLocation);
publicVariable QFUNC(cleanup);
publicVariable QFUNC(findPosHouse);
publicVariable QFUNC(replaceString);
publicVariable QFUNC(findPosOverwatch);
publicVariable QFUNC(findPosGrid);
publicVariable QFUNC(findPosSafe);
publicVariable QFUNC(findPos);
publicVariable QFUNC(getNearPlayers);
publicVariable QFUNC(loadInventory);
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
publicVariable QFUNC(isPosSafe);
publicVariable QFUNC(setPosSafe);

publicVariable QGVAR(range);
publicVariable QGVAR(center);
publicVariable QGVAR(enemySide);
publicVariable QGVAR(playerSide);
publicVariable QGVAR(markerCleanup);
publicVariable QGVAR(objectCleanup);

call FUNC(setSettings);
call FUNC(loadData);

if (GVAR(debug) isEqualTo 1) then {
  [true] call FUNC(debug);
};
