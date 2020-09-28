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
PREP(notify);
PREP(displayText);
PREP(displayGUIMessage);
PREP(handleHCConnected);
PREP(handleCleanup);
PREP(handleSettingChange);
PREP(findLocationRadius);
PREP(findPosBuilding);
PREP(findPosOverwatch);
PREP(findPosGrid);
PREP(findPosSafe);
PREP(findPosTerrain);
PREP(findPosRoadside);
PREP(findPosDriveby);
PREP(inBoundingBox);
PREP(inBuilding);
PREP(inLOS);
PREP(inSafezones);
PREP(isPosSafe);
PREP(getTargetPlayer);
PREP(getDirCardinal);
PREP(getAnimModelData);
PREP(getNearPlayers);
PREP(getObjectSize);
PREP(getObjectCenter);
PREP(getPosOffset);
PREP(getBoundingBoxCorners);
PREP(getPool);
PREP(getAlias);
PREP(getUnitCount);
PREP(getCargoCount);
PREP(getTerrainAngle);
PREP(sendToHC);
PREP(setAction);
PREP(setOwner);
PREP(setSide);
PREP(setAnim);
PREP(setAmbientAnim);
PREP(setTimer);
PREP(setUnitDamaged);
PREP(setSurrender);
PREP(setVehDamaged);
PREP(setPosSafe);
PREP(setPool);
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
PREP(removeAmbientAnim);
PREP(armory);
PREP(cleanup);
PREP(debug);
PREP(splitGroup);
PREP(landAt);
PREP(parseFactions);
PREP(parseMapLocations);
PREP(polygonArea);
PREP(polygonCenter);
PREP(polygonFill);
PREP(polygonSort);
PREP(polygonTriangulate);
PREP(polygonRandomPos);
PREP(polygonIsConvex);
PREP(polygonLength);
PREP(taskPatrol);
PREP(taskDefend);

// heap functions
PREP(heapSwap);
PREP(heapPercUp);
PREP(heapPercDown);
PREP(heapPeek);
PREP(heapPop);
PREP(heapInsert);
PREP(heapDelete);
PREP(heapSize);
PREP(heapNew);

// voronoi functions
PREP_VOR(boundEdge);
PREP_VOR(getEdges);
PREP_VOR(getXOfEdge);
PREP_VOR(getParabolaByX);
PREP_VOR(getY);
PREP_VOR(getEdgeIntersection);
PREP_VOR(newEdge);
PREP_VOR(newEvent);
PREP_VOR(newParabola);
PREP_VOR(treeSetChild);
PREP_VOR(treeGetParent);
PREP_VOR(treeGetLeafChild);
PREP_VOR(printTree);
PREP_VOR(pointerNewContainer);
PREP_VOR(pointerDelContainer);
PREP_VOR(pointerNew);
PREP_VOR(pointerSet);
PREP_VOR(pointerGet);
PREP_VOR(insertParabola);
PREP_VOR(removeParabola);
PREP_VOR(finishEdge);
PREP_VOR(checkCircle);

// headless client variables
GVAR(HC) = objNull;

// settings variables
GVAR(settingsInitFinished) = false;
GVAR(runAtSettingsInitialized) = [];

// eventhandlers
["CBA_settingsInitialized",{
    INFO("Settings initialized");

    if !(SLX_XEH_MACHINE#8) then {
        WARNING("PostInit not finished");
    };

    if (isServer) then {
        GVAR(settingsInitFinished) = true;

        // handle delayed functions,useful for functions that are not called from pre/post init scripts
        INFO_1("%1 delayed functions running",count GVAR(runAtSettingsInitialized));

        {
            (_x select 1) call (_x select 0);
        } forEach GVAR(runAtSettingsInitialized);

        GVAR(runAtSettingsInitialized) = nil;
    };
}] call CBA_fnc_addEventHandler;

// headless client exit
if (!isServer) exitWith {};

[QGVAR(HCConnected),FUNC(handleHCConnected)] call CBA_fnc_addEventHandler;

// cleanup variables
GVAR(cleanup) = [];

// map variables
GVAR(locations) = [];
GVAR(locals) = [];
GVAR(hills) = [];
GVAR(marines) = [];
GVAR(radius) = worldSize*0.5;
GVAR(center) = [GVAR(radius),GVAR(radius)];
GVAR(center) set [2,ASLZ(GVAR(center))];

// a grid of safe terrain positions used to dynamically spawn objects mid mission
GVAR(grid) = [GVAR(center),worldSize/round(worldSize/1000),worldSize,0,2,0] call FUNC(findPosGrid);

// debug variables
GVAR(debug) = false;
GVAR(debugMarkers) = [];

// safezone variables
GVAR(safezoneMarkers) = [];
GVAR(safezoneTriggers) = [];

// unit pool variables
GVAR(unitsWest) = [];
GVAR(vehiclesWest) = [];
GVAR(aircraftWest) = [];
GVAR(shipsWest) = [];
GVAR(officersWest) = [];
GVAR(snipersWest) = [];
GVAR(unitsEast) = [];
GVAR(vehiclesEast) = [];
GVAR(aircraftEast) = [];
GVAR(shipsEast) = [];
GVAR(officersEast) = [];
GVAR(snipersEast) = [];
GVAR(unitsInd) = [];
GVAR(vehiclesInd) = [];
GVAR(aircraftInd) = [];
GVAR(shipsInd) = [];
GVAR(officersInd) = [];
GVAR(snipersInd) = [];
GVAR(unitsCiv) = [];
GVAR(vehiclesCiv) = [];
GVAR(aircraftCiv) = [];
GVAR(shipsCiv) = [];
GVAR(officersCiv) = [];

// functions required on all machines
publicVariable QFUNC(setAnim);
publicVariable QFUNC(setAction);
publicVariable QFUNC(removeAction);
// publicVariable QFUNC(displayText);
publicVariable QFUNC(notify);
publicVariable QFUNC(displayGUIMessage);
publicVariable QFUNC(armory);
publicVariable QFUNC(initClient);
publicVariable QFUNC(handleSettingChange);
publicVariable QFUNC(polygonFill);

// variables required on all machines
publicVariable QGVAR(radius);
publicVariable QGVAR(center);
publicVariable QUOTE(MAIN_ADDON);

// init cba settings
SETTINGS_INIT;

// populate location hashes
call FUNC(parseMapLocations);