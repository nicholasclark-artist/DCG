/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_PREINIT;

ADDON = false;
LOG(MSG_INIT);

PREP(initSettings);
PREP(debug);
PREP(handleLoadData);
PREP(handleCleanup);
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
PREP(getPool);
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
PREP(spawnComposition);
PREP(spawnGroup);
PREP(spawnReinforcements);
PREP(spawnSniper);
PREP(spawnStatic);
PREP(exportPool);
PREP(exportComposition);
PREP(splitGroup);
PREP(exportNetworkTraffic);
PREP(exportVehicleClasses);
PREP(exportFactionClasses);
PREP(landAt);
PREP(parseFactions);

GVAR(locations) = [];
GVAR(locals) = [];
GVAR(hills) = [];
GVAR(marines) = [];
GVAR(range) = worldSize*0.5;
GVAR(center) = [GVAR(range),GVAR(range),0];
GVAR(cleanup) = [];
GVAR(saveDataCurrent) = [];
GVAR(debugMarkers) = [];
GVAR(unitPoolWest) = [];
GVAR(vehPoolWest) = [];
GVAR(airPoolWest) = [];
GVAR(unitPoolEast) = [];
GVAR(vehPoolEast) = [];
GVAR(airPoolEast) = [];
GVAR(unitPoolInd) = [];
GVAR(vehPoolInd) = [];
GVAR(airPoolInd) = [];
GVAR(unitPoolCiv) = [];
GVAR(vehPoolCiv) = [];
GVAR(airPoolCiv) = [];

// functions required on all machines
publicVariable QFUNC(setAction);
publicVariable QFUNC(setAnim);
publicVariable QFUNC(removeAction);
publicVariable QFUNC(displayText);
publicVariable QFUNC(displayGUIMessage);
publicVariable QFUNC(armory);

// variables required on all machines
publicVariable QGVAR(range);
publicVariable QGVAR(center);

publicVariable QUOTE(ADDON);

// load current mission data
call FUNC(loadData);

// init cba settings
SETTINGS_INIT;
