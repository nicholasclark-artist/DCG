/*
Author:
Nicholas Clark (SENSEI)

Description:
handles civilian unit spawns

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private _locations = EGVAR(main,locations) select {!(CHECK_DIST2D((_x select 1),locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))};

if (CHECK_DEBUG) then {
	private "_mrk";
	{
		_mrk = createMarker [LOCVAR(_x select 0),_x select 1];
		_mrk setMarkerColor "ColorCivilian";
		_mrk setMarkerShape "ELLIPSE";
		_mrk setMarkerBrush "SolidBorder";
		_mrk setMarkerAlpha 0.5;
		_mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
	} forEach _locations;
};

[{
	params ["_args","_idPFH"];
	_args params ["_locations"];
	{
		if (!(missionNamespace getVariable [LOCVAR(_x select 0),false]) && {GVAR(blacklist) find (_x select 0) isEqualTo -1}) then {
			private ["_unitCount"];
			private _position = _x select 1;

			private _near = _position nearEntities [["Man", "LandVehicle"], GVAR(spawnDist)];
			_near = _near select {isPlayer _x && {(getPosATL _x select 2) < ZDIST}};

			if !(_near isEqualTo []) then {
				call {
					if ((_x select 3) isEqualTo "NameCityCapital") exitWith {
						_unitCount = ceil(GVAR(countCapital));
					};
					if ((_x select 3) isEqualTo "NameCity") exitWith {
						_unitCount = ceil(GVAR(countCity));
					};
					_unitCount = ceil(GVAR(countVillage));
				};
				[ASLToAGL _position,_unitCount,_x select 0] call FUNC(spawnUnit);
			};
		};
	} forEach _locations;
}, 15, [_locations]] call CBA_fnc_addPerFrameHandler;