/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn group, this function must be ran in a scheduled environment

Arguments:
0: position where group will spawn <ARRAY>
1: type of group <NUMBER>
2: number of units in group <NUMBER>
3: side of group <SIDE>
4: disable group caching <BOOL>
5: delay between unit spawns <NUMBER>

Return:
group or array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_grp","_unitPool","_vehPool","_airPool","_veh","_unit"];
params [
	"_pos",
	["_type",0],
	["_count",1],
	["_side",GVAR(enemySide)],
	["_uncache",false],
	["_delay",1]
];

_grp = createGroup _side;

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

for "_i" from 1 to _count do {
	call {
		private ["_veh","_unit"];
		if (_type isEqualTo 0) exitWith {
			(selectRandom _unitPool) createUnit [_pos, _grp];
		};
		if (_type isEqualTo 1) then {
			_veh = (selectRandom _vehPool) createVehicle _pos;
			_veh setVectorUp surfaceNormal getPos _veh;
		} else {
			_veh = createVehicle [selectRandom _airPool, _pos, [], 0, "FLY"];
		};

		_unit = _grp createUnit [selectRandom _unitPool, _pos, [], 0, "NONE"];
		_unit moveInDriver _veh;

		if !((_veh emptyPositions "gunner") isEqualTo 0) then {
			_unit = _grp createUnit [selectRandom _unitPool, _pos, [], 0, "NONE"];
			_unit moveInGunner _veh;
		};

		if ((_veh emptyPositions "cargo") > 0) then {
			for "_i" from 1 to ((_veh emptyPositions "cargo") min 4) do {
				_unit = _grp createUnit [selectRandom _unitPool, _pos, [], 0, "NONE"];
				_unit moveInCargo _veh;
				sleep _delay;
			};
		};
	};
	sleep _delay;
};

if (_uncache) then {
	CACHE_DISABLE(_grp,true);
};

if (_type isEqualTo 0) exitWith {
	_grp
};

units _grp