/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

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
PREP(findPos);
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
PREP(exportConfigList);
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
GVAR(playerSide) = sideUnknown;
GVAR(enemySide) = sideUnknown;
GVAR(markerCleanup) = [];
GVAR(objectCleanup) = [];
GVAR(saveDataCurrent) = [DATA_MISSION_ID];
GVAR(debugMarkers) = [];

publicVariable QUOTE(ADDON);

// functions required on all machines
publicVariable QFUNC(initSettings);
publicVariable QFUNC(setAction);
publicVariable QFUNC(removeAction);
publicVariable QFUNC(displayText);
publicVariable QFUNC(displayGUIMessage);
publicVariable QFUNC(armory);

publicVariable QGVAR(range);
publicVariable QGVAR(center);
publicVariable QGVAR(enemySide);
publicVariable QGVAR(playerSide);

INITSETTINGS;

// set config and mission settings
call FUNC(setSettings);
