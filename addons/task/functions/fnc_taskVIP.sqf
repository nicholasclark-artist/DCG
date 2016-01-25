/*
Author: Nicholas Clark (SENSEI)

Last modified: 9/19/2015

Description: rescue vip

Return: nothing
__________________________________________________________________*/
if !(isServer) exitWith {};

#include "script_component.hpp"

private ["_taskID","_taskText","_taskDescription","_houseArray","_pos","_grp1","_unit","_grpArray","_vehArray","_grp2","_mrk"];

_taskID = "vip";
_taskText = "Rescue VIP";
_taskDescription = "We have intel that the son of a local elder has been taken hostage by enemy forces.<br/><br/>Locate the VIP and safely return him to headquarters at MOB Dodge.";

_houseArray = [];
_pos = [];

if (worldName isEqualTo "Chernarus" || {worldName isEqualTo "Chernarus_Summer"}) then {
	_pos = [DCG_centerPos,DCG_range,10] call DCG_fnc_findRuralFlatPos;
} else {
	_houseArray = [DCG_centerPos,DCG_range] call DCG_fnc_findRuralHousePos;
	_pos = (_houseArray select 1);
};

if (_pos isEqualTo []) exitWith {
	TASKEXIT(_taskID)
};

_grp1 = [_pos,0,1,CIVILIAN] call DCG_fnc_spawnGroup;
_unit = leader _grp1;
_grpArray = [([_pos,5,30] call DCG_fnc_findRandomPos),DCG_enemySide,12,.25] call DCG_fnc_spawnSquad;
_vehArray = _grpArray select 1;
_grp2 = _grpArray select 2;
[_grp2] call DCG_fnc_setPatrolGroup;
if !(_vehArray isEqualTo []) then {
	[_vehArray select 0,500] call DCG_fnc_setPatrolVeh;
};

[_unit,"Acts_AidlPsitMstpSsurWnonDnon02",2] call ace_common_fnc_doAnimation;
_pos = getPos _unit;

_mrk = createMarker ["DCG_vip_mrk",([_pos,0,300] call DCG_fnc_findRandomPos)];
_mrk setMarkerColor "ColorCIV";
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerSize [350,350];
_mrk setMarkerAlpha 0.7;

TASK(_taskID,_taskDescription,_taskText,"Search")

if(CHECK_DEBUG) then {
	[_taskID,getPosATL _unit] call BIS_fnc_taskSetDestination;
};

[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_taskDescription","_unit","_pos","_mrk"];

	if !(alive _unit) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call BIS_fnc_taskSetState;
		_unit call DCG_fnc_cleanup;
		_mrk call DCG_fnc_cleanup;
		call DCG_fnc_setTask;
	};
	if (_unit distance2D _pos > MINDIST) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		_taskText = "Escort VIP";
		[_taskID,[_taskDescription,_taskText,""]] call BIS_fnc_taskSetDescription;
		[_taskID,getmarkerpos "DCG_hq_mrk"] call BIS_fnc_taskSetDestination;

		[{
			params ["_args","_idPFH"];
			_args params ["_taskID","_unit","_mrk"];

			if !(alive _unit) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				[_taskID, "FAILED"] call BIS_fnc_taskSetState;
				_unit call DCG_fnc_cleanup;
				_mrk call DCG_fnc_cleanup;
				call DCG_fnc_setTask;
			};
			if (_unit distance (getmarkerpos "DCG_hq_mrk") < MINDIST && {[_unit] call ace_common_fnc_isAwake}) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
				_unit call DCG_fnc_cleanup;
				_mrk call DCG_fnc_cleanup;
				call DCG_fnc_setTask;
			};
		}, 5, [_taskID,_unit,_mrk]] call CBA_fnc_addPerFrameHandler;
	};
}, 5, [_taskID,_taskDescription,_unit,_pos,_mrk]] call CBA_fnc_addPerFrameHandler;