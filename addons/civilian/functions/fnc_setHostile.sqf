/*
Author: Nicholas Clark (SENSEI)

Description:
set unit as hostile

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define BOMBS ["R_TBG32V_F","HelicopterExploSmall"]
#define SOUNDPATH "A3\Sounds_F\sfx\Beep_Target.wss"

params ["_unit","_range","_type",["_tar",objNull]];

call {
	// suicide bomber
	if (_type isEqualTo 0) exitWith {
		private ["_wp"];
		_unit removeAllEventHandlers "firedNear";
		_unit addEventHandler ["Hit", {
			"HelicopterExploSmall" createVehicle ((_this select 0) modeltoworld [0,0,0]);
			(_this select 0) removeAllEventHandlers "Hit";
		}];
		_unit setBehaviour "CARELESS";
		_unit allowfleeing 0;
		_unit addVest "V_TacVestIR_blk";
		_wp = (group _unit) addWaypoint [getPosATL _tar, 0];
		_wp setWaypointSpeed "FULL";

		[group _unit,_wp,_tar,6] call EFUNC(main,setWaypointPos);

		[{
			params ["_args","_idPFH"];
			_args params ["_unit","_tar","_range"];

			if !(alive _unit) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
			};
			if ((vehicle _unit) distance _tar <= _range) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				(BOMBS select floor (random (count BOMBS))) createVehicle (getPosATL (vehicle _unit));
				deleteVehicle (vehicle _unit);
			};
		}, 0.1, [_unit,_tar,_range]] call CBA_fnc_addPerFrameHandler;

		[_unit,_tar,_range] spawn {
			_unit = vehicle (_this select 0);
			_tar = _this select 1;
			_range = _this select 2;
			while {alive (driver _unit)} do {
				if ((_tar distance _unit) < 100) then {
					playSound3D [SOUNDPATH, _unit, false, getPosATL _unit, 0.80, 1, 120];
				};
				sleep (((_tar distance _unit)*0.005 max 0.1) min 1);
			};
		};
		LOG_DEBUG("Suicide bomber spawned.");
	};
};