/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

MAIN_ADDON = false;

PREP(initSettings);
PREP(initSafezones);
PREP(initClient);
PREP(displayText);
PREP(displayGUIMessage);
PREP(handleHCConnected);
PREP(handleLoadData);
PREP(handleCleanup);
PREP(handleSettingChange);
PREP(findPosHouse);
PREP(findPosOverwatch);
PREP(findPosGrid);
PREP(findPosSafe);
PREP(findPosTerrain);
PREP(inBoundingBox);
PREP(inBuilding);
PREP(inLOS);
PREP(inSafezones);
PREP(isPosSafe);
PREP(getNearPlayers);
PREP(getPool);
PREP(getUnitCount);
PREP(sendToHC);
PREP(setAction);
PREP(setOwner);
PREP(setSide);
PREP(setAnim);
PREP(setTimer);
PREP(setUnitDamaged);
PREP(setSurrender);
PREP(setVehDamaged);
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
PREP(parseFaction);

// headless client variables 
GVAR(HC) = objNull;

// settings variables 
GVAR(settingsInitFinished) = false;
GVAR(runAtSettingsInitialized) = [];

// eventhandlers 
["CBA_settingsInitialized", {
    TRACE_1("CBA_settingsInitialized",_this);

    if !(SLX_XEH_MACHINE select 8) then {
        WARNING("PostInit not finished");
    };

    INFO("Settings initialized");

    // run event on settings init
    [QGVARMAIN(settingsInitialized), []] call CBA_fnc_localEvent;

    if (isServer) then {
        // send var to clients for handling setting changes
        GVAR(settingsInitFinished) = true;
        publicVariable QGVAR(settingsInitFinished);

        // handle delayed functions
        INFO_1("%1 delayed functions running",count GVAR(runAtSettingsInitialized));
        
        {
            (_x select 1) call (_x select 0);
        } forEach GVAR(runAtSettingsInitialized);
        
        GVAR(runAtSettingsInitialized) = nil;
    };
}] call CBA_fnc_addEventHandler;

// headless client exit 
if (!isServer) exitWith {};

[QGVAR(HCConnected), FUNC(handleHCConnected)] call CBA_fnc_addEventHandler;

// cleanup variables
GVAR(cleanup) = [];

// map variables
GVAR(locations) = [];
GVAR(locals) = [];
GVAR(hills) = [];
GVAR(marines) = [];
GVAR(radius) = worldSize*0.5;
GVAR(center) = [GVAR(radius),GVAR(radius),getTerrainHeightASL [GVAR(radius),GVAR(radius)]];
GVAR(grid) = [GVAR(center),worldSize/round(worldSize/1000),worldSize,0,0,0] call FUNC(findPosGrid);

// debug variables
GVAR(debug) = false;
GVAR(debugMarkers) = [];

// save system variables 
GVAR(saveDataScenario) = [];

// safezone variables 
GVAR(safezoneMarkers) = [];
GVAR(safezoneTriggers) = [];

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
publicVariable QFUNC(setAnim);
publicVariable QFUNC(setAction);
publicVariable QFUNC(removeAction);
publicVariable QFUNC(displayText);
publicVariable QFUNC(displayGUIMessage);
publicVariable QFUNC(armory);
publicVariable QFUNC(initClient);
publicVariable QFUNC(handleSettingChange);

// variables required on all machines
publicVariable QGVAR(radius);
publicVariable QGVAR(center);
publicVariable QGVAR(settingsInitFinished);
publicVariable QUOTE(MAIN_ADDON);

// load current scenario data
call FUNC(loadDataScenario);

// init cba settings
SETTINGS_INIT;

// populate location arrays
call FUNC(setMapLocations);