/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

LOG(MSG_INIT);

MAIN_ADDON = false;

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
PREP(loadDataScenario);
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
PREP(splitGroup);
PREP(exportComposition);
PREP(exportNetworkTraffic);
PREP(exportVehicleClasses);
PREP(exportFactionClasses);
PREP(parseFactions);
PREP(landAt);

GVAR(cleanup) = [];

// map variables
GVAR(locations) = [];
GVAR(locals) = [];
GVAR(hills) = [];
GVAR(marines) = [];
GVAR(range) = worldSize*0.5;
GVAR(center) = [GVAR(range),GVAR(range),0];

// debug variables
GVAR(debug) = false;
GVAR(debugMarkers) = [];

// save system variables 
GVAR(saveDataScenario) = [];

// unit pool variables
GVAR(unitsWest) = [];
GVAR(vehiclesWest) = [];
GVAR(aircraftWest) = [];
GVAR(officersWest) = [];
GVAR(snipersWest) = [];
GVAR(unitsEast) = [];
GVAR(vehiclesEast) = [];
GVAR(aircraftEast) = [];
GVAR(officersEast) = [];
GVAR(snipersEast) = [];
GVAR(unitsInd) = [];
GVAR(vehiclesInd) = [];
GVAR(aircraftInd) = [];
GVAR(officersInd) = [];
GVAR(snipersInd) = [];
GVAR(unitsCiv) = [];
GVAR(vehiclesCiv) = [];
GVAR(aircraftCiv) = [];

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
publicVariable QUOTE(MAIN_ADDON);

// load current scenario data
call FUNC(loadDataScenario);

// init cba settings
SETTINGS_INIT;