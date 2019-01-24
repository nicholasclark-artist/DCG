/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define LOCATIONS_TYPE ["Alsatian_Random_F","Fin_random_F","Cock_random_F","Hen_random_F"]
#define LOCALS_TYPE ["Sheep_random_F","Rabbit_F"]
#define HILLS_TYPE ["Sheep_random_F","Goat_random_F"]
#define ANIMAL_COUNT 32

POSTINIT;

// eventhandlers
[QGVARMAIN(settingsInitialized), {
    [FUNC(handleVehicle), GVAR(vehCooldown), []] call CBA_fnc_addPerFrameHandler;

    // get animal spawn locations
    _animalList = [];

    _animalList append (EGVAR(main,locations) apply {[_x select 1,LOCATIONS_TYPE]});
    _animalList append (EGVAR(main,locals) apply {[_x select 1,LOCALS_TYPE]});
    _animalList append (EGVAR(main,hills) apply {[_x select 0,HILLS_TYPE]});

    [_animalList] call EFUNC(main,shuffle);

    _animalList resize (count _animalList min ANIMAL_COUNT);

    // animal PFH
    [FUNC(handleAnimal), CIV_HANDLER_DELAY, _animalList] call CBA_fnc_addPerFrameHandler;

    // debug
    {
        _mrk = createMarker [format["%1_animal_%2",QUOTE(PREFIX),_forEachIndex],ASLtoAGL (_x select 0)];
        _mrk setMarkerColor "ColorWhite";
        _mrk setMarkerShape "ELLIPSE";
        _mrk setMarkerBrush "Border";
        _mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
        [_mrk] call EFUNC(main,setDebugMarker);
    } forEach _animalList;
}] call CBA_fnc_addEventHandler;

// 'waitUntilAndExecute', possible fix for civ module init failing sometimes
[{CBA_missionTime > 1}, FUNC(handleUnit), EGVAR(main,locations)] call CBA_fnc_waitUntilAndExecute;