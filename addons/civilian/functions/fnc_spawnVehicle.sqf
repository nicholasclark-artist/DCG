/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn civilian vehicle

Arguments:
0: position where vehicle will spawn <ARRAY>
1: position near target player <ARRAY>
2: position where vehicle will be deleted <ARRAY>
3: player that vehicle will pass by <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_start","_mid","_end","_player"];

private _grp = [_start,1,1,CIVILIAN] call EFUNC(main,spawnGroup);

[_grp] call EFUNC(cache,disableCache);

[
	{{_x getVariable [ISDRIVER,false]} count (units (_this select 0)) > 0},
	{
		params ["_grp","_start","_mid","_end","_player"];

        _veh = vehicle (leader _grp);
		_driver = driver _veh;

		_wp = _grp addWaypoint [_mid,0];
		_wp setWaypointTimeout [0, 0, 0];
		_wp setWaypointCompletionRadius 100;
		_wp setWaypointBehaviour "CARELESS";
		_wp setWaypointSpeed "LIMITED";

		_wp = _grp addWaypoint [_end,0];
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

		INFO_1("Spawned civilian driver at %1",getPos _driver);
	},
	[_grp,_start,_mid,_end,_player]
] call CBA_fnc_waitUntilAndExecute;
