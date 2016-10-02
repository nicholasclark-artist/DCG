/*
Author:
Nicholas Clark (SENSEI)

Description:
set vehicle to damaged state

Arguments:
0: vehicle to damage <OBJECT>
1: max number of damaged hit points <NUMBER>
2: code to run on repair <CODE>
3: code arguments <ANY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define MAX_DMG 1

params [
	"_veh",
	["_hitCount",1],
	["_onRepair",{}],
	["_params",[]],
	["_playSound",false]
];

(getAllHitPointsDamage _veh) params [
	["_allHitpoints", []],
	["_allHitpointsSelections", []]
];

if (!(local _veh) || {_allHitpoints isEqualTo []} || {!(_veh isKindOf "LandVehicle" || (_veh isKindOf "Ship") || (_veh isKindOf "Air"))}) exitWith {};

private _hitIndex = [];
private _hitSelect = [];
private _lastHit = "";

{
	_selection = _allHitpointsSelections select _forEachIndex;

	if (!(_x isEqualTo "") && {((toLower _x) find "glass") isEqualTo -1} && {((toLower _x) find "fuel") isEqualTo -1} && {!isNil {_veh getHit _selection}}) then {
		_hitIndex pushBack _forEachIndex;
	};
} forEach _allHitpoints;

if (_hitIndex isEqualTo []) exitWith {
	WARNING_2("%1 %2: no suitable hitpoints.",typeOf _veh,getPos _veh);
};

for "_i" from 1 to _hitCount step 1 do {
	_hit = selectRandom _hitIndex;

	if !(_hit isEqualTo _lastHit) then {
		_lastHit = _hit;
		_veh setHitIndex [_hit, MAX_DMG];
		_hitSelect pushBack _hit;

		LOG_5("%1 %2: hitpoint: %3 index: %4 damage: %5.",typeOf _veh,getPos _veh,_allHitpoints select _hit,_hit,MAX_DMG);
	};
};

if (_playSound) then {
	playSound3D ["A3\Sounds_F\Vehicles\air\noises\heli_damage_rotor_int_open_1.wss", _veh, false, getPosATL _veh, 2];
};

private _fx = "test_EmptyObjectForSmoke" createVehicle (getPosWorld _veh);
_fx attachTo [_veh,[0,0,0]];

// wait until all suitable hitpoints are repaired or vehicle is dead
[
	{
		isNull (_this select 0) ||
		{!alive (_this select 0)} ||
		{({(((getAllHitPointsDamage (_this select 0)) select 2) select _x) >= MAX_DMG} count (_this select 1)) isEqualTo 0}
	},
	{
		params ["_veh","_hitIndex","_onRepair","_params","_pos","_fx"];

		if (!isNull _veh && {alive _veh}) then {
			_params = [_veh] + _params;
 			_params call _onRepair;
 			LOG_2("%1 %2: repaired.",typeOf _veh,_pos);
		};
		[_fx] call FUNC(removeParticle);
	},
	[_veh,_hitIndex,_onRepair,_params,getPos _veh,[_fx]]
] call CBA_fnc_waitUntilAndExecute;

[_hitIndex,_hitSelect]