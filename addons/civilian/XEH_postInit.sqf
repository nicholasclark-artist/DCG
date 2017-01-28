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
		_locations =+ EGVAR(main,locations);
		_locals =+ EGVAR(main,locals);
		_hills =+ EGVAR(main,hills);
        _animalList = [];

        [FUNC(handleUnit), HANDLER_DELAY, _locations] call CBA_fnc_addPerFrameHandler;
        [FUNC(handleVehicle), GVAR(vehCooldown), []] call CBA_fnc_addPerFrameHandler;

        {
            _mrk = createMarker [LOCATION_ID(_x select 0),_x select 1];
            _mrk setMarkerColor ([CIVILIAN,true] call BIS_fnc_sideColor);
            _mrk setMarkerShape "ELLIPSE";
            _mrk setMarkerBrush "Solid";
            _mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
            [_mrk] call EFUNC(main,setDebugMarker);

            false
        } count _locations;

        _locations =+ _locations;
		_locals =+ _locals;
		_hills =+ _hills;

        for "_i" from 0 to LIMIT - 1 do {
            if !(_locations isEqualTo []) then {
                _location = selectRandom _locations;
                _animalList pushBack [_location select 1,LOCATIONS_TYPE];
                _locations deleteAt (_locations find _location);
            };

            if !(_locals isEqualTo []) then {
                _local = selectRandom _locals;
                _animalList pushBack [_local select 1,LOCALS_TYPE];
                _locals deleteAt (_locals find _local);
            };

            if !(_hills isEqualTo []) then {
                _hill = selectRandom _hills;
                _animalList pushBack [_hill select 0,HILLS_TYPE];
                _hills deleteAt (_hills find _hill);
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
