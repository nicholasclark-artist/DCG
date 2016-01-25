/*
Author: SENSEI

Last modified: 1/15/2016

Description: spawns civilians

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"

private ["_grp","_driverArray","_roads","_vehGrp","_vehPos","_veh","_unit","_hostile","_targets"];
params ["_pos","_unitCount","_vehCount","_townName"];

missionNamespace setVariable [format ["%1_%2",QUOTE(ADDON),_townName],true];

// spawn units
_grp = [_pos,0,_unitCount,CIVILIAN] call EFUNC(main,spawnGroup);
[units _grp,150] call EFUNC(main,setPatrol);

{
	_x addEventHandler ["firedNear",{
		if !((_this select 0) getVariable [QUOTE(DOUBLES(ADDON,civFiredNear)),false]) then {
			(_this select 0) setVariable [QUOTE(DOUBLES(ADDON,civFiredNear)),true];
			if (random 1 < 0.5) then {
				(_this select 0) setVariable [QUOTE(DOUBLES(PREFIX,patrol_exit)),true];
				(_this select 0) disableAI "MOVE";
				(_this select 0) setCombatMode "BLUE";
				(_this select 0) setUnitPos "DOWN";
			} else {
				(_this select 0) setVariable [QUOTE(DOUBLES(PREFIX,patrol_exit)),true];
				(_this select 0) forceSpeed ((_this select 0) getSpeed "FAST");
				(_this select 0) setUnitPos "MIDDLE";
				(_this select 0) doMove ([getposASL (_this select 0),1000,2000] call EFUNC(main,findRandomPos));
			};
		};
	}];
	false
} count units _grp;

// spawn vehicles
_driverArray = [];
_roads = _pos nearRoads 100;
_vehGrp = createGroup CIVILIAN;
if !(_roads isEqualTo []) then {
	for "_i" from 0 to _vehCount - 1 do {
		_vehPos = getPosATL (_roads select floor (random (count _roads)));
		if !(_vehPos isFlatEmpty [4,0,1,10,0,false,objNull] isEqualTo []) then {
			_veh = (EGVAR(main,vehPoolCiv) select floor (random (count EGVAR(main,vehPoolCiv)))) createVehicle _vehPos;
			_veh setVectorUp [0,0,1];
			_unit = _vehGrp createUnit [(EGVAR(main,unitPoolCiv) select floor (random (count EGVAR(main,unitPoolCiv)))), _pos, [], 0, "NONE"];
			_unit moveInDriver _veh;
			_driverArray pushBack _unit;
			[_driverArray,GVAR(spawnDist)*2 min 1500] call EFUNC(main,setPatrol);
		};
	};
};

// hostile unit
_hostile = false;
if (CHECK_ADDON_2(approval) && {true}) then { // TODO add approval calc
	_hostile = true;
} else {
	if (random 1 < 0.05) then {
		_hostile = true;
	};
};
if (_hostile) then {
	_unit = ((_driverArray + _grp) select floor (random (count (_driverArray + _grp))));
	_targets = [getPosATL _unit,GVAR(spawnDist)+50] call EFUNC(main,getNearPlayers);
	if !(_targets isEqualTo []) then {
		_unit setVariable [QUOTE(DOUBLES(PREFIX,patrol_exit)),true];
		_unit = [[_unit]] call EFUNC(main,setSide);
		[leader _unit,15,0,_targets select floor (random (count _targets))] call FUNC(setHostile);
	};
};

// despawn PFH
[{
	params ["_args","_idPFH"];
	_args params ["_pos","_townName","_grp","_driverArray"];

	if ({_x distance _pos < GVAR(spawnDist)} count allPlayers isEqualTo 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		missionNamespace setVariable [format ["%1_%2",QUOTE(ADDON),_townName],false];
		((units _grp)+_driverArray) call EFUNC(main,cleanup);
	};
}, 30, [_pos,_townName,_grp,_driverArray]] call CBA_fnc_addPerFrameHandler;