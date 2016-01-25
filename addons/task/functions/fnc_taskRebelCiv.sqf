/*
Author: Nicholas Clark (SENSEI)

Last modified: 9/24/2015

Description: spawns rebel force on player or FOB
__________________________________________________________________*/
if !(isServer) exitWith {};

#include "script_component.hpp"

private ["_taskID","_taskText","_taskDescription","_tempGrp","_vest","_weapon","_mags","_targetPos","_spawnPos","_rebelGrp","_y","_mrkPatrol","_wp","_bonus","_playerArray","_tar"];

_taskID = format["%1_rebel_civ",DCG_taskCounterCiv];
_taskText = "";
_taskDescription = "";

_tempGrp = [[0,0,0],0,1] call DCG_fnc_spawnGroup;
_vest = vest (leader _tempGrp);
_weapon = currentWeapon (leader _tempGrp);
_mags = magazines (leader _tempGrp);
deleteVehicle (leader _tempGrp);

if (!(GET_APPROVAL(1)) || {count (call DCG_fnc_getPlayers) < 1}) exitWith {
	["Rebel task skipped."] call DCG_fnc_log;
	TASKCIVREBEL
};

if (FOB_CHECK && random 1 < 0.5) then {
	_taskText = "Rebel Attack (FOB)";
	_taskDescription = "Aerial reconnaissance shows several hostile civilians advancing towards FOB Pirelli. Defend the FOB against the rebel attack!";
	_targetPos = getPosATL dcg_fob_flagFOB;
	_spawnPos = [_targetPos,300,400] call DCG_fnc_findRandomPos;



	if (CHECK_DIST2D(_spawnPos,MARKER_SAFEZONE,(getMarkerSize MARKER_SAFEZONE) select 0)) exitWith {
		["Rebel spawn or target position in safezone."] call DCG_fnc_log;
		TASKCIVREBEL
	};

	_rebelGrp = [_spawnPos,0,STRENGTH(8,16),CIVILIAN] call DCG_fnc_spawnGroup;
	_rebelGrp = [units _rebelGrp] call DCG_fnc_setSide;
	{
		_y = _x;
		_y addVest _vest;
		_y addWeapon _weapon;
		{_y addMagazine _x} forEach _mags;
	} forEach units _rebelGrp;

	if(CHECK_DEBUG) then {
		_mrkPatrol = createMarker [format["DCG_rebel_%1",time],getposATL leader _rebelGrp];
		_mrkPatrol setMarkerType "o_unknown";
		_mrkPatrol setMarkerColor "ColorCIV";
		_mrkPatrol setMarkerText "rebel";
	};

	SAD(_rebelGrp,_targetPos)

	["Rebel target: FOB Pirelli: POSITION: %1",_targetPos] call DCG_fnc_log;

	TASKWPOS(_taskID,_taskDescription,_taskText,_targetPos,"C")

	[{
		params ["_args","_idPFH"];
		_args params ["_taskID","_targetPos","_rebelGrp"];

		if ({alive _x} count (units _rebelGrp) isEqualTo 0) exitWith {
			[_idPFH] call CBA_fnc_removePerFrameHandler;
			[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
			_bonus = 20;
			DCG_approval = DCG_approval + _bonus;
			publicVariable "DCG_approval";
			["DCG_approvalBonus",[_bonus,'Assisting the local population has increased your approval!']] remoteExecCall ["BIS_fnc_showNotification", allPlayers, false];
			TASKCIVREBEL
		};
		if ((leader _rebelGrp) distance _targetPos < MINDIST) exitWith {
			[_idPFH] call CBA_fnc_removePerFrameHandler;
			createVehicle ["R_TBG32V_F", _targetPos,[],0,"CAN_COLLIDE"];
			{
				if (random 1 > 0.5) then {createVehicle ["R_TBG32V_F", getposATL _x,[],0,"CAN_COLLIDE"]};
				_x setDamage 1;
			} foreach (curatorEditableObjects DCG_curatorFOB);
			call DCG_fnc_fobDelete;
			[_taskID, "FAILED"] call BIS_fnc_taskSetState;
			(units _rebelGrp) call DCG_fnc_cleanup;
			TASKCIVREBEL
		};
	}, 5, [_taskID,_targetPos,_rebelGrp]] call CBA_fnc_addPerFrameHandler;
} else {
	_taskText = "Rebel Attack";
	_taskDescription = "Aerial reconnaissance shows several hostile civilians advancing towards your position. Defend yourself against the rebel attack!";

	_playerArray = [];
	{if (alive _x) then {_playerArray pushBack _x}} forEach (call DCG_fnc_getPlayers);

	if (_playerArray isEqualTo []) exitWith {
		["Rebel target array is empty."] call DCG_fnc_log;
		TASKCIVREBEL
	};

	_tar = _playerArray select floor (random (count _playerArray));

	if (isNull _tar || {(getposATL _tar select 2) > 5}) exitWith {
		["Rebel target is unsuitable."] call DCG_fnc_log;
		TASKCIVREBEL
	};
	_targetPos = getPosATL _tar;
	_spawnPos = [_targetPos,300,400] call DCG_fnc_findRandomPos;

	if (CHECK_DIST2D(_spawnPos,MARKER_SAFEZONE,(getMarkerSize MARKER_SAFEZONE) select 0) || {CHECK_DIST2D(_targetPos,MARKER_SAFEZONE,(getMarkerSize MARKER_SAFEZONE) select 0)}) exitWith {
		["Rebel spawn or target position in safezone."] call DCG_fnc_log;
		TASKCIVREBEL
	};

	_rebelGrp = [_spawnPos,0,STRENGTH(8,16),CIVILIAN] call DCG_fnc_spawnGroup;
	_rebelGrp = [units _rebelGrp] call DCG_fnc_setSide;
	{
		_y = _x;
		_y addVest _vest;
		_y addWeapon _weapon;
		{_y addMagazine _x} forEach _mags;
	} forEach units _rebelGrp;

	if(CHECK_DEBUG) then {
		_mrkPatrol = createMarker [format["DCG_rebel_%1",time],getposATL leader _rebelGrp];
		_mrkPatrol setMarkerType "o_unknown";
		_mrkPatrol setMarkerColor "ColorCIV";
		_mrkPatrol setMarkerText "rebel";
	};

	SAD(_rebelGrp,_tar)

	["Rebel target: %1",name _tar] call DCG_fnc_log;

	TASKWPOS(_taskID,_taskDescription,_taskText,_targetPos,"C")

	[{
		params ["_args","_idPFH"];
		_args params ["_taskID","_tar","_rebelGrp"];

		if (isNull _tar || {(getposATL _tar distance getposATL (leader _rebelGrp) > 1000) && !(isPlayer((leader _rebelGrp) findNearestEnemy (leader _rebelGrp)))}) exitWith {
			[_idPFH] call CBA_fnc_removePerFrameHandler;
			[_taskID, "CANCELED"] call BIS_fnc_taskSetState;
			(units _rebelGrp) call DCG_fnc_cleanup;
			TASKCIVREBEL
		};

		if ({alive _x} count (units _rebelGrp) isEqualTo 0) exitWith {
			[_idPFH] call CBA_fnc_removePerFrameHandler;
			[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
			_bonus = 20;
			DCG_approval = DCG_approval + _bonus;
			publicVariable "DCG_approval";
			["DCG_approvalBonus",[_bonus,'Assisting the local population has increased your approval!']] remoteExecCall ["BIS_fnc_showNotification", allPlayers, false];
			TASKCIVREBEL
		};
	}, 5, [_taskID,_tar,_rebelGrp]] call CBA_fnc_addPerFrameHandler;
};