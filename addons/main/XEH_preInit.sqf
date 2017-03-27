/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_PREINIT;

ADDON = false;

PREP(initSettings);
PREP(debug);
PREP(handleLoadData);
PREP(handleCleanup);
PREP(handleSafezone);
PREP(setDebugMarker);
PREP(removeDebugMarker);
PREP(armory);
PREP(cleanup);
PREP(findPosHouse);
PREP(replaceString);
PREP(findPosOverwatch);
PREP(findPosGrid);
PREP(findPosSafe);
PREP(findPosTerrain);
PREP(getNearPlayers);
PREP(saveData);
PREP(loadData);
PREP(loadDataAddon);
PREP(inBuilding);
PREP(inLOS);
PREP(isPosSafe);
PREP(displayText);
PREP(displayGUIMessage);
PREP(removeAction);
PREP(removeParticle);
PREP(setAction);
PREP(setSettingsValue);
PREP(setSettings);
PREP(setSettingsConfig);
PREP(setSettingsParams);
PREP(shuffle);
PREP(setOwner);
PREP(setSide);
PREP(setAnim);
PREP(getUnitCount);
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
PREP(exportSettings);
PREP(exportPool);
PREP(exportBase);
PREP(splitGroup);
PREP(exportNetworkTraffic);
PREP(landAt);
// PREP(exportConfigList);

GVAR(locations) = [];
GVAR(locals) = [];
GVAR(hills) = [];
GVAR(marines) = [];
GVAR(baseLocation) = locationNull;
GVAR(range) = worldSize*0.5;
GVAR(center) = [GVAR(range),GVAR(range),0];
GVAR(markerCleanup) = [];
GVAR(objectCleanup) = [];
GVAR(saveDataCurrent) = [];
GVAR(debugMarkers) = [];

publicVariable QUOTE(ADDON);

// functions required on all machines
publicVariable QFUNC(initSettings);
publicVariable QFUNC(setAction);
publicVariable QFUNC(setAnim);
publicVariable QFUNC(removeAction);
publicVariable QFUNC(displayText);
publicVariable QFUNC(displayGUIMessage);
publicVariable QFUNC(armory);

// variables required on all machines
publicVariable QGVAR(range);
publicVariable QGVAR(center);

// load current mission data
call FUNC(loadData);

// init cba settings
SETTINGS_INIT;

// set config and mission settings
call FUNC(setSettings);
