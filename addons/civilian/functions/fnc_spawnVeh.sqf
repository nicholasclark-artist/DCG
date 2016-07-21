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

private ["_probability","_grp","_veh","_vehArray","_driver","_wp","_statement"];
params ["_start","_mid","_end","_player"];

_vehArray = [getPosASL _start,1,1,CIVILIAN] call EFUNC(main,spawnGroup);
_driver = _vehArray select 0;
_veh = vehicle _driver;
_grp = group _driver;

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
_statement = format ["(vehicle this) call %1; %2 = %2 - [this];", QEFUNC(main,cleanup),QGVAR(drivers)];
_wp setWaypointStatements ["true", _statement];
_veh allowCrewInImmobile true;
_veh addEventHandler ["GetOut", {
	if (!isPlayer (_this select 2) && {(_this select 2) isEqualTo leader (_this select 2)}) then {
		(units group (_this select 2)) call EFUNC(main,cleanup);
		(_this select 0) call EFUNC(main,cleanup);
	};
}];

GVAR(drivers) pushBack _driver;