/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define LOCATIONS_TYPE ["Alsatian_Random_F","Fin_random_F","Cock_random_F","Hen_random_F"]
#define LOCALS_TYPE ["Sheep_random_F","Rabbit_F"]
#define HILLS_TYPE ["Sheep_random_F","Goat_random_F"]
#define LIMIT 8
#define INTERATIONS 3

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	INFO("Addon is disabled.");
};

[
	{DOUBLES(PREFIX,main)},
	{
		_locations = EGVAR(main,locations) select {!(CHECK_DIST2D((_x select 1),locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))};

		{
			_mrk = createMarker [LOCATION_ID(_x select 0),_x select 1];
			_mrk setMarkerColor "ColorCivilian";
			_mrk setMarkerShape "ELLIPSE";
			_mrk setMarkerBrush "Solid";
			_mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
			[_mrk] call EFUNC(main,setDebugMarker);

			false
		} count _locations;

		[FUNC(handleUnit), 15, [_locations]] call CBA_fnc_addPerFrameHandler;

		_animalList = [];

		_locations = _locations select {!(CHECK_DIST2D(_x select 1,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))};
		_locals = _locals select {!(CHECK_DIST2D(_x select 1,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))};
		_hills = _hills select {!(CHECK_DIST2D(_x select 0,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))};

		_locations = [EGVAR(main,locations),(count EGVAR(main,locations))*INTERATIONS] call EFUNC(main,shuffle);
		_locals = [EGVAR(main,locals),(count EGVAR(main,locals))*INTERATIONS] call EFUNC(main,shuffle);
		_hills = [EGVAR(main,hills),(count EGVAR(main,hills))*INTERATIONS] call EFUNC(main,shuffle);

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

		[FUNC(handleAnimal), 15, [_animalList]] call CBA_fnc_addPerFrameHandler;

		[FUNC(handleVehicle), GVAR(vehCooldown), []] call CBA_fnc_addPerFrameHandler;
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;