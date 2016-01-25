/*
Author: SENSEI

Last modified: 9/28/2015

Description: destroy artillery before time expires

Return: nothing
__________________________________________________________________*/
if !(isServer) exitWith {};

#include "script_component.hpp"

private ["_taskID","_taskText","_taskDescription","_artyRadius","_artyArray","_pos","_grpArray","_baseArray","_vehArray","_grp","_posArty","_arty","_gunner","_mrkArty","_hintInterval","_sound","_time"];

_taskID = "arty";
_taskText = "Eliminate Artillery";
_taskDescription = "There is an imminent artillery barrage targeting MOB Dodge. Command is evacuating the base, but your team needs to disable the artillery immediately!";

DCG_defused = false;
DCG_armed = false;
DCG_timer = 3600;
_artyRadius = 1200;
_artyArray = [];
_pos = [DCG_centerPos,DCG_range,140] call DCG_fnc_findRuralFlatPos;
if (_pos isEqualTo []) exitWith {
	TASKEXIT(_taskID)
};

_grpArray = [_pos,DCG_enemySide,15,.80,2] call DCG_fnc_spawnSquad;
_baseArray = _grpArray select 0;
_vehArray = _grpArray select 1;
_grp = _grpArray select 2;
_posArty = getposATL ((nearestObjects [_pos, ["Land_DuctTape_F"], 200]) select 0);

// TODO: fix arty hitting rock or tree and exploding
for "_j" from 1 to 3 do {
	_arty = "O_MBT_02_arty_F" createVehicle [0,0,0];
	if (count _artyArray > 0) then {
		_posArty = ((_artyArray select (count _artyArray - 1)) modelToWorld [10,0,0]);
		_posArty set [2,0];
		_arty setPosATL _posArty;
	} else {
		_arty setPosATL _posArty;
	};
	_arty setObjectTextureGlobal [0, "#(rgb,8,8,3)color(0.09,0.1,0.08,1)"];
	_arty setObjectTextureGlobal [1, "#(rgb,8,8,3)color(0.09,0.1,0.08,1)"];
	_arty setObjectTextureGlobal [3, "#(rgb,8,8,3)color(0.09,0.1,0.08,1)"];
	_arty setDir (getDir _arty - 70);
	_arty setVectorUp [0,0,1];
	_arty lock true;
	_arty allowCrewInImmobile true;
	_artyArray pushBack _arty;
	_arty addEventHandler ["HandleDamage", {
		if ((_this select 4) isKindof "PipeBombBase" && {(_this select 2) > 0.6}) then {
			(_this select 0) setDamage 1;
		};
	}];
	_gunner = (createGroup DCG_enemySide) createUnit [DCG_unitPool select 0, _pos, [], 0, "NONE"];
	_gunner assignAsGunner _arty;
	_gunner moveInGunner  _arty;
	_gunner setFormDir (getDir _arty);
	_gunner setDir (getDir _arty);
	_gunner doWatch (_gunner modelToWorld [0,100,30]);
	_gunner disableAI "FSM";
	_gunner disableAI "MOVE";
};

[_grp,150] call DCG_fnc_setPatrolGroup;
if !(_vehArray isEqualTo []) then {
	[_vehArray select 0,500] call DCG_fnc_setPatrolVeh;
};

_mrkArty = createMarker ["DCG_arty_AO",[_pos,0,_artyRadius] call DCG_fnc_findRandomPos];
_mrkArty setMarkerColor "ColorRED";
_mrkArty setMarkerShape "ELLIPSE";
_mrkArty setMarkerAlpha 0.7;
_mrkArty setMarkerSize [_artyRadius,_artyRadius];

TASK(_taskID,_taskDescription,_taskText,"Destroy")

if(CHECK_DEBUG) then {
	[_taskID,_posArty] call BIS_fnc_taskSetDestination;
};

[{
 	params ["_args","_idPFH"];
    _args params ["_artyArray","_hintInterval"];

	if (DCG_defused) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
	};
	if (DCG_timer < 1) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		DCG_armed = true;
		for "_i" from 0 to ((count _artyArray) - 1) do {
			(_artyArray select _i) doArtilleryFire [getMarkerPos "respawn_west", "32Rnd_155mm_Mo_shells", 4];
		};
	};
	if ((DCG_timer/_hintInterval) mod 1 isEqualTo 0) then {
		(format ["%1 %2 %3","Artillery firing in",([DCG_timer] call DCG_fnc_setTime),"minutes."]) remoteExecCall ["hintSilent", allPlayers, false];
	};
	DCG_timer = DCG_timer - 1;
}, 1, [_artyArray,60]] call CBA_fnc_addPerFrameHandler;

[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_artyArray","_baseArray","_mrkArty"];

	if (DCG_armed) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call BIS_fnc_taskSetState;
		_artyArray call DCG_fnc_cleanup;
		_baseArray call DCG_fnc_cleanup;
		_mrkArty call DCG_fnc_cleanup;
		[{
			params ["_args","_idPFH"];
			_args params ["_sound","_time"];

			playSound3D [_sound, DCG_alarmMOB];
			if (diag_tickTime > _time) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				call DCG_fnc_setTask;
			};
		}, 10, ["A3\Sounds_F\sfx\alarm_independent.wss",diag_tickTime + 50]] call CBA_fnc_addPerFrameHandler;
	};

	if (({alive _x} count _artyArray) isEqualTo 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		DCG_defused = true;
		_artyArray call DCG_fnc_cleanup;
		_baseArray call DCG_fnc_cleanup;
		_mrkArty call DCG_fnc_cleanup;
		call DCG_fnc_setTask;
	};
}, 5, [_taskID,_artyArray,_baseArray,_mrkArty]] call CBA_fnc_addPerFrameHandler;