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

        [FUNC(handleUnit), CIV_HANDLER_DELAY, EGVAR(main,locations)] call CBA_fnc_addPerFrameHandler;
        [FUNC(handleVehicle), GVAR(vehCooldown), []] call CBA_fnc_addPerFrameHandler;

        {
            _mrk = createMarker [CIV_LOCATION_ID(_x select 0),_x select 1];
            _mrk setMarkerColor ([CIVILIAN,true] call BIS_fnc_sideColor);
            _mrk setMarkerShape "ELLIPSE";
            _mrk setMarkerBrush "Solid";
            _mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
            [_mrk] call EFUNC(main,setDebugMarker);
        } forEach EGVAR(main,locations);

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
            _pos = _x select 0;
            _mrk = createMarker [format["%1_animal_%2",QUOTE(PREFIX),_pos],_pos];
            _mrk setMarkerColor "ColorBlack";
            _mrk setMarkerShape "ELLIPSE";
            _mrk setMarkerBrush "Solid";
            _mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
            [_mrk] call EFUNC(main,setDebugMarker);
        } forEach _animalList;
    }
] call CBA_fnc_waitUntilAndExecute;


