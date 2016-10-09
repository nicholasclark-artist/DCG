/*
Author:
Nicholas Clark (SENSEI)

Description:
handles animal unit spawns

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define LOCATIONS_TYPE ["Alsatian_Random_F","Fin_random_F","Cock_random_F","Hen_random_F"]
#define LOCALS_TYPE ["Sheep_random_F","Rabbit_F"]
#define HILLS_TYPE ["Sheep_random_F","Goat_random_F"]
#define LIMIT 8

_animalList = [];

_locations = _locations select {!(CHECK_DIST2D(_x select 1,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))};
_locals = _locals select {!(CHECK_DIST2D(_x select 1,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))};
_hills = _hills select {!(CHECK_DIST2D(_x select 0,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))};

_locations = [EGVAR(main,locations)] call EFUNC(main,shuffle);
_locals = [EGVAR(main,locals)] call EFUNC(main,shuffle);
_hills = [EGVAR(main,hills)] call EFUNC(main,shuffle);

{
	if (_forEachIndex > LIMIT) exitWith {};

	_animalList pushBack [_x select 1,LOCATIONS_TYPE];
} forEach _locations;

{
	if (_forEachIndex > LIMIT) exitWith {};

	_animalList pushBack [_x select 1,LOCALS_TYPE];
} forEach _locals;

{
	if (_forEachIndex > LIMIT) exitWith {};

	_animalList pushBack [_x select 0,HILLS_TYPE];
} forEach _hills;

[{
	params ["_args","_idPFH"];
	_args params ["_animalList"];

	{
		if !(missionNamespace getVariable [LOCVAR(_x select 0),false]) then {
			_x params ["_pos","_types"];

			_near = _pos nearEntities [["Man", "LandVehicle"], GVAR(spawnDist)];
			_near = _near select {isPlayer _x && {(getPosATL _x select 2) < ZDIST}};

			if !(_near isEqualTo []) then {
				[_pos,_types] call FUNC(spawnAnimal);
			};
		};

		false
	} count _animalList;
}, 15, [_animalList]] call CBA_fnc_addPerFrameHandler;

if (CHECK_DEBUG) then {
	{
		_pos = _x select 0;
		_mrk = createMarker [format["%1_animal_%2",QUOTE(ADDON),_pos],_pos];
		_mrk setMarkerColor "ColorBlack";
		_mrk setMarkerShape "ELLIPSE";
		_mrk setMarkerBrush "SolidBorder";
		_mrk setMarkerAlpha 0.5;
		_mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
	} forEach _animalList;
};