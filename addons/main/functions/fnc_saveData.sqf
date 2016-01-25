/*
Author: SENSEI

Last modified: 1/5/2015

Description: save data to server profile

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define PUSHBACK_DATA(ADDONTOSAVE,DATATOSAVE) GVAR(saveDataCurrent) pushBack [QUOTE(DOUBLES(PREFIX,ADDONTOSAVE)),DATATOSAVE]

if (!isServer) exitWith {};

private ["_dataProfile"];

_dataProfile = DATA_GETVAR; // main data variable
GVAR(saveDataCurrent) = [DATA_MISSION_ID]; // overwrite current data

if (CHECK_ADDON_2(occupy)) then {
	private ["_data","_locations","_tasks","_infCount","_vehCount","_airCount"];
	_data = [];
	_locations = [];
	_tasks = [];

	for "_i" from 0 to count EGVAR(occupy,locations) - 1 do {
		(EGVAR(occupy,locations) select _i) params ["_name","_position","_size","_type"];
		_infCount = 0;
		_vehCount = 0;
		_airCount = 0;
		{
			if ((driver _x) getVariable [format ["occupyUnit_%1", _name],false]) then {
				if (_x isKindOf "Man") exitWith {
					_infCount = _infCount + 1;
				};
				if (_x isKindOf "LandVehicle") exitWith {
					_vehCount = _vehCount + 1;
				};
				if (_x isKindOf "Air") exitWith {
					_airCount = _airCount + 1;
				};
			};
			false
		} count (_position nearEntities [["Man","LandVehicle","Air","Ship"],_size*2]);

		_locations pushBack [_name,_position,_size,_type,[_infCount,_vehCount,_airCount]];
	};

	{ // get list of liberated locations
		if (_x select [0,4] isEqualTo "lib_") then {
			_tasks pushBack _x;
		};
	} forEach ([allPlayers select 0] call BIS_fnc_tasksUnit);

	_data = [_locations,_tasks];

	PUSHBACK_DATA(occupy,_data);
};

if (CHECK_ADDON_2(fob)) then {
	private ["_data","_dataObj"];
	_data = [];

	if !(EGVAR(fob,location) isEqualTo locationNull) then {
		_data pushBack (locationPosition EGVAR(fob,location));
		_data pushBack (curatorPoints EGVAR(fob,curator));
		_dataObj = [];
		{
			if (!(_x isKindOf "Man") && {count crew _x isEqualTo 0}) then {
				_dataObj pushBack [typeOf _x,getPosASL _x,getDir _x];
			};
			false
		} count (curatorEditableObjects EGVAR(fob,curator));
		_data pushBack _dataObj;
	};

	PUSHBACK_DATA(fob,_data);
};

if (CHECK_ADDON_2(patrol)) then {
	private ["_data","_fnc_getData","_grpData"];
	if (CHECK_HC) then {
		{
			publicVariableServer QEGVAR(patrol,groups);
		} remoteExecCall ["BIS_fnc_call", owner HEADLESSCLIENT, false];
	};

	_data = [];

	_fnc_getData = {
		private ["_ret"];
		_ret = [];
		if (!(_this isEqualTo grpNull) && {count units _this > 0}) then {
			_ret = [getpos leader _this, count units _this, parseNumber (vehicle leader _this != leader _this)];
		};
		_ret
	};

	{
		_grpData = _x call _fnc_getData;
		if !(_grpData isEqualTo []) then {
			_data pushBack _grpData;
		};
		false
	} count EGVAR(patrol,groups);

	PUSHBACK_DATA(patrol,_data);
};

if (CHECK_ADDON_2(weather)) then {
	private ["_data"];
	_data = [overcast,date];
	PUSHBACK_DATA(weather,_data);
};

if (CHECK_ADDON_2(ied)) then {
	private ["_data"];
	_data = [];
	{
		_data pushBack [getpos _x,typeOf _x];
		false
	} count EGVAR(ied,array);

	PUSHBACK_DATA(ied,_data);
};

// following code must run last
if !(_dataProfile isEqualTo []) then {
	{
		if ((_x select 0) isEqualTo DATA_MISSION_ID) exitWith {
			_dataProfile set [_forEachIndex,GVAR(saveDataCurrent)];
		};
		_dataProfile pushBack GVAR(saveDataCurrent);
	} forEach _dataProfile;
} else {
	_dataProfile pushBack GVAR(saveDataCurrent);
};

DATA_SETVAR(_dataProfile);
saveProfileNamespace;