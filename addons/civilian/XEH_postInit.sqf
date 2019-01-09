/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define LOCATIONS_TYPE ["Alsatian_Random_F","Fin_random_F","Cock_random_F","Hen_random_F"]
#define LOCALS_TYPE ["Sheep_random_F","Rabbit_F"]
#define HILLS_TYPE ["Sheep_random_F","Goat_random_F"]
#define LIMIT 8

if !(isMultiplayer) exitWith {};

[
    {MAIN_ADDON && {CHECK_POSTBRIEFING}}, 
    {
        if (!(EGVAR(main,enable)) || {!(GVAR(enable))}) exitWith {};

        [
            {time > 5}, // possible fix for civ module init failing sometimes
            {
                EGVAR(main,locations) call FUNC(initCivPresence);
            }
        ] call CBA_fnc_waitUntilAndExecute;

        [FUNC(handleVehicle), GVAR(vehCooldown), []] call CBA_fnc_addPerFrameHandler;

        // @todo fix animal list picking same position several times
        _animalList = [];

        for "_i" from 0 to LIMIT - 1 do {
            if !(EGVAR(main,locations) isEqualTo []) then {
                _pos = (selectRandom EGVAR(main,locations)) select 1;
                if ((_animalList find _pos) isEqualTo -1) then {
                    _animalList pushBack [_pos,LOCATIONS_TYPE];
                };
            };

            if !(EGVAR(main,locals) isEqualTo []) then {
                _pos = (selectRandom EGVAR(main,locals)) select 1;
                if ((_animalList find _pos) isEqualTo -1) then {
                    _animalList pushBack [_pos,LOCALS_TYPE];
                };
            };

            if !(EGVAR(main,hills) isEqualTo []) then {
                _pos = (selectRandom EGVAR(main,hills)) select 0;
                if ((_animalList find _pos) isEqualTo -1) then {
                    _animalList pushBack [_pos,HILLS_TYPE];
                };
            };
        };

        [FUNC(handleAnimal), CIV_HANDLER_DELAY, _animalList] call CBA_fnc_addPerFrameHandler;

        {
            _mrk = createMarker [format["%1_animal_%2",QUOTE(PREFIX),diag_frameNo + _forEachIndex],ASLtoAGL (_x select 0)];
            _mrk setMarkerColor "ColorBlack";
            _mrk setMarkerShape "ELLIPSE";
            _mrk setMarkerBrush "Solid";
            _mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
            [_mrk] call EFUNC(main,setDebugMarker);
        } forEach _animalList;
    }
] call CBA_fnc_waitUntilAndExecute;