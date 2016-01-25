/*
Author: Nicholas Clark (SENSEI)

Last modified: 9/26/2015

Description: set vehicle to damaged state

Return: array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_veh","_ret","_hitpoints","_fx","_hit"];

_veh = _this select 0;
_ret = [];

if (_veh isKindOf "MAN") exitWith {};

if !(local _veh) exitWith {
	[_veh] remoteExecCall [QFUNC(setVehDamaged), owner _veh, false];
};

call {
	if (_veh isKindOf "Car") exitWith {
		_hitpoints = ["HitLBWheel","HitLFWheel","HitRBWheel","HitRFWheel","HitRF2Wheel","HitLF2Wheel"];
	};
	if (_veh isKindOf "Tank") exitWith {
		_hitpoints = ["HitLTrack","HitRTrack"];
	};
	if (_veh isKindOf "Air") exitWith {
		_hitpoints = ["HitTransmission","HitHRotor","HitVRotor"];
	};
};

playSound3D ["A3\Sounds_F\Vehicles\air\noises\heli_damage_rotor_int_open_1.wss", _veh, false, getPosATL _veh, 2];
_veh setHit [getText (configFile >> "cfgVehicles" >> typeOf _veh >> "HitPoints" >> "HitEngine" >> "name"), 1];
if !(isNil "_hitpoints") then {
	_hit = _hitpoints select floor (random (count _hitpoints));
	_veh setHit [getText (configFile >> "cfgVehicles" >> typeOf _veh >> "HitPoints" >> _hit >> "name"), 1];
};
_fx = "test_EmptyObjectForSmoke" createVehicle (getPosATL _veh);
_fx attachTo [_veh,[0,0,0]];

[{
	params ["_args","_idPFH"];
	_args params ["_veh"];

	if !(_veh getHit (getText (configFile >> "cfgVehicles" >> typeOf _veh >> "HitPoints" >> "HitEngine" >> "name")) isEqualTo 1) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[getPosATL _veh] call FUNC(removeParticle);
	};
}, 0.5, [_veh]] call CBA_fnc_addPerFrameHandler;

if !(isNil "_hitpoints") then {
	_ret append [_hit,"HitEngine"];
} else {
	_ret pushBack "HitEngine";
};

_ret