/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn group

Arguments:
0: position where group will spawn <ARRAY>
1: type of group <NUMBER>
2: number of units in group <NUMBER>
3: side of group <SIDE>
4: disable group caching <BOOL>
5: delay between unit spawns <NUMBER>
5: fill vehicle cargo <BOOL>

Return:
group
__________________________________________________________________*/
#include "script_component.hpp"
#define MAX_CARGO 6

private ["_unitPool","_vehPool","_airPool"];
params [
	"_pos",
	["_type",0],
	["_count",1],
	["_side",GVAR(enemySide)],
	["_uncache",false],
	["_delay",1],
	["_cargo",false]
];

private _grp = createGroup _side;
private _drivers = [];
private _check = [];

call {
	if (_side isEqualTo EAST) exitWith {
		_unitPool = GVAR(unitPoolEast);
		_vehPool = GVAR(vehPoolEast);
		_airPool = GVAR(airPoolEast);
	};
	if (_side isEqualTo WEST) exitWith {
		_unitPool = GVAR(unitPoolWest);
		_vehPool = GVAR(vehPoolWest);
		_airPool = GVAR(airPoolWest);
	};
	if (_side isEqualTo CIVILIAN) exitWith {
		_unitPool = GVAR(unitPoolCiv);
		_vehPool = GVAR(vehPoolCiv);
		_airPool = GVAR(airPoolCiv)
	};
	_unitPool = GVAR(unitPoolInd);
	_vehPool = GVAR(vehPoolInd);
	_airPool = GVAR(airPoolInd);
};

if (_uncache) then {
	CACHE_DISABLE(_grp,true);
};

if (_type isEqualTo 0) exitWith {
	[{
		params ["_args","_idPFH"];
		_args params ["_pos","_grp","_unitPool","_count","_check"];

		if (count _check isEqualTo _count) exitWith {
			[_idPFH] call CBA_fnc_removePerFrameHandler;
		};

		(selectRandom _unitPool) createUnit [_pos, _grp];

		_check pushBack 0;
	}, _delay, [_pos,_grp,_unitPool,_count,_check]] call CBA_fnc_addPerFrameHandler;

	_grp
};

[{
	params ["_args","_idPFH"];
	_args params ["_pos","_grp","_type","_count","_unitPool","_vehPool","_airPool","_check","_cargo"];

	if (count _check isEqualTo _count) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
	};

	private "_veh";

	if (_type isEqualTo 1) then {
		_veh = createVehicle [selectRandom _vehPool, _pos, [], 16, "NONE"];
		_veh setVectorUp surfaceNormal getPos _veh;
	} else {
		_veh = createVehicle [selectRandom _airPool, _pos, [], 0, "FLY"];
	};

	_unit = _grp createUnit [selectRandom _unitPool, [0,0,0], [], 0, "NONE"];
	_unit setVariable [QUOTE(GVAR(spawnDriver)),true];
	_unit moveInDriver _veh;

	if ((_veh emptyPositions "gunner") > 0) then {
		_unit = _grp createUnit [selectRandom _unitPool, [0,0,0], [], 0, "NONE"];
		_unit moveInGunner _veh;
	};

	if (_cargo) then {
		[{
			params ["_args","_idPFH"];
			_args params ["_grp","_unitPool","_veh","_count"];

			if (count crew _veh >= _count) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
			};

			_unit = _grp createUnit [selectRandom _unitPool, [0,0,0], [], 0, "NONE"];
			_unit moveInCargo _veh;
		}, _delay, [_grp,_unitPool,_veh,((_veh emptyPositions "cargo") min MAX_CARGO) + (count crew _veh)]] call CBA_fnc_addPerFrameHandler;
	};

	_check pushBack 0;
}, _delay, [_pos,_grp,_type,_count,_unitPool,_vehPool,_airPool,_check,_cargo]] call CBA_fnc_addPerFrameHandler;

_grp