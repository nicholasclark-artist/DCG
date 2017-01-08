/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define LOCATIONS_TYPE ["Alsatian_Random_F","Fin_random_F","Cock_random_F","Hen_random_F"]
#define LOCALS_TYPE ["Sheep_random_F","Rabbit_F"]
#define HILLS_TYPE ["Sheep_random_F","Goat_random_F"]
#define LIMIT 8
#define ITERATIONS 2

CHECK_POSTINIT;

[
	{DOUBLES(PREFIX,main) && {CHECK_POSTBRIEFING}},
	{
		_locations = +EGVAR(main,locations);
		_locals = +EGVAR(main,locals);
		_hills = +EGVAR(main,hills);
        _animalList = [];

		_locations = [_locations,(count _locations)*ITERATIONS] call EFUNC(main,shuffle);
		_locals = [_locals,(count _locals)*ITERATIONS] call EFUNC(main,shuffle);
		_hills = [_hills,(count _hills)*ITERATIONS] call EFUNC(main,shuffle);

		{
			if (_forEachIndex >= LIMIT) exitWith {};
			_animalList pushBack [_x select 1,LOCATIONS_TYPE];
		} forEach _locations;

		{
			if (_forEachIndex >= LIMIT) exitWith {};
			_animalList pushBack [_x select 1,LOCALS_TYPE];
		} forEach _locals;

		{
			if (_forEachIndex >= LIMIT) exitWith {};
			_animalList pushBack [_x select 0,HILLS_TYPE];
		} forEach _hills;

        [FUNC(handleUnit), HANDLER_DELAY, _locations] call CBA_fnc_addPerFrameHandler;
        [FUNC(handleAnimal), HANDLER_DELAY, _animalList] call CBA_fnc_addPerFrameHandler;
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
