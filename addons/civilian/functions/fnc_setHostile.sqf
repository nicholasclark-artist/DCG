/*
Author:
Nicholas Clark (SENSEI)

Description:
set unit as hostile

Arguments:
0: unit to set hostile <OBJECT>
1: type of hostility <NUMBER>
2: target <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define BOMBS ["R_TBG32V_F","HelicopterExploSmall"]
#define SOUNDPATH "A3\Sounds_F\sfx\Beep_Target.wss"

params ["_unit","_type",["_tar",objNull]];

_unit removeAllEventHandlers "firedNear";

call {
	// suicide bomber
	if (_type isEqualTo 0) exitWith {
		private ["_range","_wp"];
		_range = 15;
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
				(selectRandom BOMBS) createVehicle (getPosATL (vehicle _unit));
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
	// rebels
	if (_type isEqualTo 1) exitWith {
		private ["_posArray","_tempGrp","_vest","_weapon","_mags","_grp","_y","_wp","_cond"];
		_posArray = [getpos _tar,50,600,300] call EFUNC(main,findPosGrid);
		{
			if (!([_x,200] call EFUNC(main,getNearPlayers) isEqualTo []) || {[_x,_tar] call EFUNC(main,inLOS)}) then {
				_posArray deleteAt _forEachIndex;
			};
		} forEach _posArray;

		if !(_posArray isEqualTo []) then {
			_tempGrp = [[0,0,0],0,1] call EFUNC(main,spawnGroup);
			_vest = vest (leader _tempGrp);
			_weapon = currentWeapon (leader _tempGrp);
			_mags = magazines (leader _tempGrp);
			deleteVehicle (leader _tempGrp);
			_grp = [selectRandom _posArray,0,[6,16] call EFUNC(main,setStrength),CIVILIAN] call EFUNC(main,spawnGroup);
			_grp = [units _grp] call EFUNC(main,setSide);
			{
				_y = _x;
				_y addVest _vest;
				_y addWeapon _weapon;
				{_y addMagazine _x} forEach _mags;
			} forEach units _grp;
			_wp = _grp addWaypoint [getPosATL _tar,0];
			_wp setWaypointBehaviour "AWARE";
			_wp setWaypointFormation "STAG COLUMN";
			_cond = "!(behaviour this isEqualTo ""COMBAT"")";
			_wp setWaypointStatements [_cond, format ["thisList call %1;",QEFUNC(main,cleanup)]];
			LOG_DEBUG("Rebels spawned.");
		};
	};
};