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
#define MAX_HIT 1

params [
	"_veh",
	["_max",1],
	["_code",{}],
	["_params",[]]
];

private _ret = [];
private _hitpoints = [];
private _hit = "";

if (_veh isKindOf "MAN" || {!local _veh}) exitWith {};

_hitpoints = (getAllHitPointsDamage _veh) select 0;
_hitpoints = _hitpoints select {!(_x isEqualTo "") && {((toLower _x) find "glass") isEqualTo -1}};

if !(_hitpoints isEqualTo []) then {
	for "_i" from 1 to _max step 1 do {
		_hit = selectRandom _hitpoints;
		_veh setHitPointDamage [getText (configFile >> "cfgVehicles" >> typeOf _veh >> "HitPoints" >> _hit), MAX_HIT];
		_ret pushBack _hit;
	};

	playSound3D ["A3\Sounds_F\Vehicles\air\noises\heli_damage_rotor_int_open_1.wss", _veh, false, getPosATL _veh, 2];
	private _fx = "test_EmptyObjectForSmoke" createVehicle (getPosWorld _veh);
	_fx attachTo [_veh,[0,0,0]];
};

[
	{
		isNull (_this select 0) ||
		{!alive (_this select 0)} ||
		{(((getAllHitPointsDamage (_this select 0)) select 2) select {_x >= MAX_HIT}) isEqualTo []}
	},
	{
		params ["_veh","_ret","_code","_params","_pos"];

		if (!isNull _veh && {alive _veh}) then {
			_params = [_veh,_ret] + _params;
 			_params call _code;
		};
		[_pos,2] call FUNC(removeParticle);
	},
	[_veh,_ret,_code,_params,getPos _veh]
] call CBA_fnc_waitUntilAndExecute;

_ret