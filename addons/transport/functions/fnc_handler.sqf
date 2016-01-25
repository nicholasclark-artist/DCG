/*
Author: Nicholas Clark (SENSEI)

Last modified: 12/12/2015

Description: handles transport functionality

Note: functions runs on client

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define COOLDOWN_PFH \
	[{ \
		params ["_args","_idPFH"]; \
		_args params ["_time"]; \
		if (diag_tickTime >= _time) exitWith { \
			[_idPFH] call CBA_fnc_removePerFrameHandler; \
			GVAR(ready) = 1; \
			GVAR(count) = GVAR(count) - 1; \
			publicVariable QGVAR(count); \
		}; \
	}, 1, [diag_tickTime + GVAR(cooldown)]] call CBA_fnc_addPerFrameHandler

private ["_classname","_exfilMrk","_infilMrk","_helipad1","_helipad2","_helipadPos","_dir","_spawnPos","_transport","_wp","_args","_pilot","_time"];

LOG_DEBUG_1("Transport request: %1.",_this);

_classname = _this select 0;
GVAR(exfil) = _this select 1;
GVAR(infil) = _this select 2;
_exfilMrk = _this select 3;
_infilMrk = _this select 4;
_helipad1 = objNull;
_helipad2 = objNull;
_dir = 0;
GVAR(ready) = 0;
GVAR(count) = GVAR(count) + 1;
publicVariable QGVAR(count);

// check for helipad around both lz's
_fnc_getNearHelipad = {
	params ["_pos",["_range",100],["_size",8]];

	_helipad = (nearestObjects [_pos, ["Land_HelipadCircle_F","Land_HelipadCivil_F","Land_HelipadEmpty_F","Land_HelipadRescue_F","Land_HelipadSquare_F","Land_JumpTarget_F"], _range]) select 0;

	if !(isNil "_helipad") then {
		_isEmpty = (getPosATL _helipad) isFlatEmpty [_size, 0, 0.5, 6, 0, false, _helipad];
		if !(_isEmpty isEqualTo []) then {
			_pos = getPosATL _helipad;
		};
	};
	_pos
};

_helipadPos = [GVAR(exfil),100,12] call _fnc_getNearHelipad;
if !(_helipadPos isEqualTo GVAR(exfil)) then {
	GVAR(exfil) = _helipadPos;
} else {
	_helipad1 = createVehicle ["Land_HelipadEmpty_F", GVAR(exfil), [], 0, "CAN_COLLIDE"];
};
_helipadPos = [GVAR(infil),100,12] call _fnc_getNearHelipad;
if !(_helipadPos isEqualTo GVAR(infil)) then {
	GVAR(infil) = _helipadPos;
} else {
	_helipad2 = createVehicle ["Land_HelipadEmpty_F", GVAR(infil), [], 0, "CAN_COLLIDE"];
};

// find position away from an occupied location
missionNamespace setVariable [QEGVAR(transport,getLocations), player];
publicVariableServer QEGVAR(transport,getLocations);

if !(isNil QEGVAR(occupy,occupiedLocations)) then {
	{
		_dir = _dir + ([GVAR(exfil), ((EGVAR(occupy,occupiedLocations) select _forEachIndex) select 1)] call BIS_fnc_dirTo);
	} forEach EGVAR(occupy,occupiedLocations);
	_dir = (_dir/(count EGVAR(occupy,occupiedLocations))) + 180;
} else {
	_dir = random 360;
};

// spawn transport
_spawnPos = [GVAR(exfil),5000,6000,0,_dir] call EFUNC(main,findRandomPos);
_transport = createVehicle [_classname,_spawnPos,[],0,"FLY"];

// copilot EH
_transport addEventHandler ["GetIn",{
	if (isPlayer (_this select 2) && {(_this select 2) isEqualTo ((_this select 0) turretUnit [0])} && {alive (driver (_this select 0))} && {canMove (_this select 0)}) then {
		(_this select 0) removeAllEventHandlers "GetIn";
		playSound3D ["A3\dubbing_F\modules\supports\transport_welcome.ogg", driver (_this select 0), false, getPosASL (_this select 0), 2, 1, 100];
		_wp = group driver (_this select 0) addWaypoint [GVAR(infil), 0];
		_wp setWaypointStatements ["true", format ["
			(vehicle this) land ""GET OUT"";
			[{
				params [""_args"",""_id""];
				_args params [""_pilot""];

				if (isTouchingGround (vehicle _pilot)) exitWith {
					[_idPFH] call CBA_fnc_removePerFrameHandler;
					playSound3D [""A3\dubbing_F\modules\supports\transport_accomplished.ogg"", _pilot, false, getPosASL _pilot, 2, 1, 100];
					[{
						params [""_args"",""_id""];
						_args params [""_time"",""_pilot""];

						if (diag_tickTime >= _time) exitWith {
							[_idPFH] call CBA_fnc_removePerFrameHandler;
							{
								if (isPlayer _x) then {moveOut _x};
							} forEach (crew (vehicle _pilot));
							missionNameSpace setVariable ['%1', -1];
							_wp = group _pilot addWaypoint [[0,0,100], 0];
						};
					}, 1, [diag_tickTime + 10,_pilot]] call CBA_fnc_addPerFrameHandler;
				};
			}, 1, [this]] call CBA_fnc_addPerFrameHandler;
		",QGVAR(ready)]];
	};
}];

call {
	if ((side player) isEqualTo EAST) exitWith {
		_pilot = "O_Helipilot_F";
	};
	if ((side player) isEqualTo WEST) exitWith {
		_pilot = "B_Helipilot_F";
	};
	_pilot = "I_Helipilot_F";
};

_pilot = createGroup (side player) createUnit [_pilot,_spawnPos, [], 0, "NONE"];
_pilot moveInDriver _transport;
_pilot allowfleeing 0;
_pilot setBehaviour "CARELESS";
_pilot disableAI "FSM";
_transport allowCrewInImmobile true;
_transport enableCopilot false;
_transport lockDriver true;
_transport flyInHeight 180;
_wp = group _pilot addWaypoint [GVAR(exfil), 0];
_wp setWaypointStatements ["true", "(vehicle this) land ""GET IN"";"];
playSound3D ["A3\dubbing_F\modules\supports\transport_acknowledged.ogg", player, false, getPosASL player, 1, 1, 100];

// run PFHs
[{
	params ["_args","_idPFH"];
	_args params ["_transport","_pilot","_exfilMrk","_infilMrk","_helipad1","_helipad2"];

	if (GVAR(ready) isEqualTo -1) exitWith { // if transport route complete
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		deleteMarker _exfilMrk;
		deleteMarker _infilMrk;
		deleteVehicle _helipad1;
		deleteVehicle _helipad2;
		_transport call EFUNC(main,cleanup);
		COOLDOWN_PFH;
	};
	if (!alive _pilot || {vehicle _pilot isEqualTo _pilot} || {isTouchingGround _transport && (!(canMove _transport) || (fuel _transport isEqualTo 0))}) exitWith { // if transport destroyed enroute
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		GVAR(ready) = -1;
		deleteMarker _exfilMrk;
		deleteMarker _infilMrk;
		deleteVehicle _helipad1;
		deleteVehicle _helipad2;
		_transport call EFUNC(main,cleanup);
		playSound3D ["A3\dubbing_F\modules\supports\transport_destroyed.ogg", player, false, getPosASL player, 1, 1, 100];
		COOLDOWN_PFH;
	};
}, 1, [_transport,_pilot,_exfilMrk,_infilMrk,_helipad1,_helipad2]] call CBA_fnc_addPerFrameHandler;

// handles transport timeout if player not in vehicle
[{
	params ["_args","_idPFH"];
	_args params ["_transport","_pilot"];

	if (GVAR(ready) isEqualTo 1 || {GVAR(ready) isEqualTo -1}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
	};

	if (isTouchingGround _transport && {alive _pilot} && {vehicle _pilot isEqualTo _transport} && {canMove _transport}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[{
			params ["_args","_idPFH"];
			_args params ["_transport", "_pilot", "_time"];

			if !(isTouchingGround _transport) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
			};

			if (diag_tickTime >= _time && {isTouchingGround _transport}) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				GVAR(ready) = -1;
				{
					if (isPlayer _x) then {moveOut _x};
				} forEach (crew _transport);
				_wp = group _pilot addWaypoint [[0,0,100], 0];
				(vehicle _pilot) call EFUNC(main,cleanup);
				COOLDOWN_PFH;
			};
		}, 1, [_transport, _pilot, diag_tickTime + 120]] call CBA_fnc_addPerFrameHandler;
	};
}, 1, [_transport,_pilot]] call CBA_fnc_addPerFrameHandler;