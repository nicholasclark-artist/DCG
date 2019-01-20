/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

MAIN_ADDON = false;

PREP(initSettings);
PREP(displayText);
PREP(displayGUIMessage);
PREP(handleLoadData);
PREP(handleCleanup);
PREP(handleClient);
PREP(findPosHouse);
PREP(findPosOverwatch);
PREP(findPosGrid);
PREP(findPosSafe);
PREP(findPosTerrain);
PREP(inBuilding);
PREP(inLOS);
PREP(isPosSafe);
PREP(getNearPlayers);
PREP(getPool);
PREP(getUnitCount);
PREP(setAction);
PREP(setOwner);
PREP(setSide);
PREP(setAnim);
PREP(setTimer);
PREP(setUnitDamaged);
PREP(setSurrender);
PREP(setVehDamaged);
PREP(setWaypointPos);
PREP(setPosSafe);
PREP(setPool);
PREP(setMapLocations);
PREP(setDebugMarker);
PREP(spawnComposition);
PREP(spawnGroup);
PREP(spawnReinforcements);
PREP(spawnSniper);
PREP(spawnStatic);
PREP(exportComposition);
PREP(exportNetworkTraffic);
PREP(exportVehicleClasses);
PREP(exportFactionClasses);
PREP(replaceString);
PREP(removeAction);
PREP(removeDebugMarker);
PREP(removeParticle);
PREP(saveData);
PREP(loadDataScenario);
PREP(loadDataAddon);
PREP(armory);
PREP(cleanup);
PREP(debug);
PREP(splitGroup);
PREP(landAt);
PREP(shuffle);

GVAR(cleanup) = [];

// map variables
GVAR(grid) = [];
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