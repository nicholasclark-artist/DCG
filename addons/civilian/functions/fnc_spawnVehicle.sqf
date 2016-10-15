/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn civilian vehicle

Arguments:
0: road where vehicle will spawn <OBJECT>
1: road near target player <OBJECT>
2: road where vehicle will be deleted <OBJECT>
2: player that vehicle will pass by <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_grp","_driver","_veh","_wp","_statement"];
params ["_start","_mid","_end","_player"];

_grp = [getPosASL _start,1,1,CIVILIAN] call EFUNC(main,spawnGroup);

[
	{{_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]} count (units (_this select 0)) > 0},
	{
		_this params ["_grp","_start","_mid","_end","_player"];

		_driver = objNull;

		{
			if (_x isEqualTo driver (vehicle _x)) exitWith {
				_driver = _x;
			};
			false
		} count (units _grp);

		_veh = vehicle _driver;

		_wp = _grp addWaypoint [getPosATL _mid,0];
		_wp setWaypointTimeout [0, 0, 0];
		_wp setWaypointCompletionRadius 100;
		_wp setWaypointBehaviour "CARELESS";
		if (random 1 < 0.5) then {
			_wp setWaypointSpeed "LIMITED";
		} else {
			_wp setWaypointSpeed "FULL";
		};

		_wp = _grp addWaypoint [getPosATL _end,0];
		_statement = format ["deleteVehicle (objectParent this); deleteVehicle this; %1 = %1 - [this];", QGVAR(drivers)];
		_wp setWaypointStatements ["true", _statement];
		_veh allowCrewInImmobile true;
		_veh addEventHandler ["GetOut", {
			if (!isPlayer (_this select 2) && {(_this select 2) isEqualTo leader (_this select 2)}) then {
				(units group (_this select 2)) call EFUNC(main,cleanup);
				(_this select 0) call EFUNC(main,cleanup);
			};
		}];

		GVAR(drivers) pushBack _driver;

		INFO_1("Spawned civilian driver at %1.",getPos _driver);
	},
	[_grp,_start,_mid,_end,_player]
] call CBA_fnc_waitUntilAndExecute;