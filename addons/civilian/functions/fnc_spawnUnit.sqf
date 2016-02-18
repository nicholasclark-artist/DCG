/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn civilians

Arguments:
0: position to spawn civilians <ARRAY>
1: number of units to spawn <NUMBER>
3: name of location <STRING>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_grp","_roads","_unit","_targets"];
params ["_pos","_unitCount","_townName"];

missionNamespace setVariable [format ["%1_%2",QUOTE(ADDON),_townName],true];

// spawn units
_grp = [_pos,0,_unitCount,CIVILIAN] call EFUNC(main,spawnGroup);

{
	_x allowfleeing 0;
	_x addEventHandler ["firedNear",{
		if !((_this select 0) getVariable [QUOTE(DOUBLES(PREFIX,isOnPatrol)),-1] isEqualTo 0) then {
			(_this select 0) setVariable [QUOTE(DOUBLES(PREFIX,isOnPatrol)),0];
			(_this select 0) forceSpeed ((_this select 0) getSpeed "FAST");
			(_this select 0) setUnitPos "MIDDLE";
			(_this select 0) doMove ([getposASL (_this select 0),1000,2000] call EFUNC(main,findRandomPos));
		};
	}];
} forEach (units _grp);

// hostile unit
if ((CHECK_ADDON_2(approval) && true) || {!(CHECK_ADDON_2(approval)) && random 1 < GVAR(hostileChance)}) then {
	_unit = selectRandom (units _grp);
	_targets = [getPosATL _unit,GVAR(spawnDist)] call EFUNC(main,getNearPlayers);
	if !(_targets isEqualTo []) then {
		_unit setVariable [QUOTE(DOUBLES(PREFIX,isOnPatrol)),0];
		_unit = [[_unit]] call EFUNC(main,setSide);
		[leader _unit,round random 1,selectRandom _targets] call FUNC(setHostile);
	};
};

[units _grp,100,true,"CARELESS"] call EFUNC(main,setPatrol);

// despawn PFH
[{
	params ["_args","_idPFH"];
	_args params ["_pos","_townName","_grp"];

	if ({_x distance _pos < GVAR(spawnDist)} count allPlayers isEqualTo 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		missionNamespace setVariable [format ["%1_%2",QUOTE(ADDON),_townName],false];
		(units _grp) call EFUNC(main,cleanup);
	};
}, 30, [_pos,_townName,_grp]] call CBA_fnc_addPerFrameHandler;