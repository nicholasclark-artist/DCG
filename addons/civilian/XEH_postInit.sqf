/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define LOCATIONS_TYPE ["Alsatian_Random_F","Fin_random_F","Cock_random_F","Hen_random_F"]
#define LOCALS_TYPE ["Sheep_random_F","Rabbit_F"]
#define HILLS_TYPE ["Sheep_random_F","Goat_random_F"]
#define ANIMAL_COUNT 24

if !(isMultiplayer) exitWith {};

[
    {MAIN_ADDON && {CHECK_POSTBRIEFING}}, 
    {
        if (!(EGVAR(main,enable)) || {!(GVAR(enable))}) exitWith {};

        [
            {diag_tickTime > (_this + 5)}, // possible fix for civ module init failing sometimes
            {EGVAR(main,locations) call FUNC(handleUnit)},
            diag_tickTime
        ] call CBA_fnc_waitUntilAndExecute;

        [FUNC(handleVehicle), GVAR(vehCooldown), []] call CBA_fnc_addPerFrameHandler;

        private _animalList = [];

        _animalList append (EGVAR(main,locations) apply {[_x select 1,LOCATIONS_TYPE]});
        _animalList append (EGVAR(main,locals) apply {[_x select 1,LOCALS_TYPE]});
        _animalList append (EGVAR(main,hills) apply {[_x select 0,HILLS_TYPE]});

        [_animalList] call EFUNC(main,shuffle);

        _animalList resize ANIMAL_COUNT;

        [FUNC(handleAnimal), CIV_HANDLER_DELAY, _animalList] call CBA_fnc_addPerFrameHandler;

        {
            _mrk = createMarker [format["%1_animal_%2",QUOTE(PREFIX),_forEachIndex],ASLtoAGL (_x select 0)];
            _mrk setMarkerColor "ColorBlack";
            _mrk setMarkerShape "ELLIPSE";
            _mrk setMarkerBrush "Solid";
            _mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
            [_mrk] call EFUNC(main,setDebugMarker);
        } forEach _animalList;
    }
] call CBA_fnc_waitUntilAndExecute;