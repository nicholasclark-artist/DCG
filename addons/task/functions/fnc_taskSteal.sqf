/*
Author: Nicholas Clark (SENSEI)

Description:
steal intel from device

Arguments:

Return:
none
__________________________________________________________________*/
if !(isServer) exitWith {};

#include "script_component.hpp"

private ["_taskID","_taskText","_taskDescription","_radius","_pos","_grpArray","_baseArray","_vehArray","_grp","_mrk"];

_taskID = "steal";
_taskText = "Steal Intel";
_taskDescription = "The enemey have created a highly advanced weapons device. We cannot allow the opposition to gain the upper hand. Find the device and retrieve intel from its onboard computer.";

_radius = 1200;
_pos = [DCG_centerPos,DCG_range,140] call DCG_fnc_findRuralFlatPos;

if (_pos isEqualTo []) exitWith {
	TASKEXIT(_taskID)
};

_grpArray = [_pos,DCG_enemySide,15,.80,2] call DCG_fnc_spawnSquad;
_baseArray = _grpArray select 0;
_vehArray = _grpArray select 1;
_grp = _grpArray select 2;
_device = (nearestObjects [_pos, ["Land_Device_assembled_F"], 100]) select 0;
[_grp,150] call DCG_fnc_setPatrolGroup;
if !(_vehArray isEqualTo []) then {
	[_vehArray select 0,500] call DCG_fnc_setPatrolVeh;
};

_deviceID = [[_device],{
	_action = ["DCG_Device","Retrieve Device Intel","",{
		[
			20,
			[],
			{
				DCG_taskSuccess = 1;
				publicVariableServer "DCG_taskSuccess";
				hintSilent "You've copied the device data.";
			},
			{

			},
			"Searching Onboard Computer..."
		] call ace_common_fnc_progressBar;
	},{true}] call ace_interact_menu_fnc_createAction;
	[(_this select 0), 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
}] remoteExecCall ["BIS_fnc_call", west, true];

_mrk = createMarker ["DCG_steal_AO",([_pos,0,_radius] call DCG_fnc_findRandomPos)];
_mrk setMarkerColor "ColorRED";
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerAlpha 0.7;
_mrk setMarkerSize [_radius,_radius];

TASK(_taskID,_taskDescription,_taskText,"Search")

if(CHECK_DEBUG) then {
	[_taskID,getPosATL _device] call BIS_fnc_taskSetDestination;
};

[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_pos","_baseArray","_mrk","_deviceID"];

	if (DCG_taskSuccess isEqualTo 1) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		[_pos,DCG_enemySide,0] spawn DCG_fnc_spawnReinforcements;
		remoteExecCall ["", _deviceID];
		_baseArray call DCG_fnc_cleanup;
		_mrk call DCG_fnc_cleanup;
		call DCG_fnc_setTask;
	};
}, 5, [_taskID,_pos,_baseArray,_mrk,_deviceID]] call CBA_fnc_addPerFrameHandler;