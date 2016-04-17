/*
Author:
Nicholas Clark (SENSEI)

Description:
set vehicle to damaged state

Arguments:
0: vehicle to damage <OBJECT>
1: code to run on repair <STRING>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_ret","_hitpoints","_hit","_fx"];
params ["_veh", ["_onRepair",""]];

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

	// TODO add ship hitpoints
};

playSound3D ["A3\Sounds_F\Vehicles\air\noises\heli_damage_rotor_int_open_1.wss", _veh, false, getPosATL _veh, 2];
_veh setHit [getText (configFile >> "cfgVehicles" >> typeOf _veh >> "HitPoints" >> "HitEngine" >> "name"), 1];
_ret pushBack "HitEngine";

if !(isNil "_hitpoints") then {
	_hit = selectRandom _hitpoints;
	_veh setHit [getText (configFile >> "cfgVehicles" >> typeOf _veh >> "HitPoints" >> _hit >> "name"), 1];
	_ret pushBack _hit;
};

_fx = "test_EmptyObjectForSmoke" createVehicle (getPosATL _veh);
_fx attachTo [_veh,[0,0,0]];

[{
	params ["_args","_idPFH"];
	_args params ["_veh","_ret","_onRepair"];

	if (isNull _veh || {!alive _veh} || {({_veh getHit (getText (configFile >> "cfgVehicles" >> typeOf _veh >> "HitPoints" >> _x >> "name")) isEqualTo 1} count _ret) isEqualTo 0}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[getPosATL _veh,2] call FUNC(removeParticle);
		if (!isNull _veh && {alive _veh}) then {
			[_veh,_ret] call compile _onRepair;
		};
	};
}, 0.2, [_veh,_ret,_onRepair]] call CBA_fnc_addPerFrameHandler;

_ret