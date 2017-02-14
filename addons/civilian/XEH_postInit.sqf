/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define LOCATIONS_TYPE ["Alsatian_Random_F","Fin_random_F","Cock_random_F","Hen_random_F"]
#define LOCALS_TYPE ["Sheep_random_F","Rabbit_F"]
#define HILLS_TYPE ["Sheep_random_F","Goat_random_F"]
#define LIMIT 8

CHECK_POSTINIT;

[
	{DOUBLES(PREFIX,main) && {CHECK_POSTBRIEFING}},
	{
        [FUNC(handleUnit), HANDLER_DELAY, EGVAR(main,locations)] call CBA_fnc_addPerFrameHandler;
        [FUNC(handleVehicle), GVAR(vehCooldown), []] call CBA_fnc_addPerFrameHandler;

        {
            _mrk = createMarker [LOCATION_ID(_x select 0),_x select 1];
            _mrk setMarkerColor ([CIVILIAN,true] call BIS_fnc_sideColor);
            _mrk setMarkerShape "ELLIPSE";
            _mrk setMarkerBrush "Solid";
            _mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
            [_mrk] call EFUNC(main,setDebugMarker);

            false
        } count EGVAR(main,locations);

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

        [FUNC(handleAnimal), HANDLER_DELAY, _animalList] call CBA_fnc_addPerFrameHandler;

		{
			_pos = _x select 0;
			_mrk = createMarker [format["%1_animal_%2",QUOTE(PREFIX),_pos],_pos];
			_mrk setMarkerColor "ColorBlack";
			_mrk setMarkerShape "ELLIPSE";
			_mrk setMarkerBrush "Solid";
			_mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
			[_mrk] call EFUNC(main,setDebugMarker);

			false
		} count _animalList;
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
