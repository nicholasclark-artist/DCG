/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn civilians

Arguments:
0: position to spawn civilians <ARRAY>
1: number of units to spawn <NUMBER>
2: number of vehicles to spawn <NUMBER>
3: name of location <STRING>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_grp","_roads","_vehGrp","_veh","_unit","_targets"];
params ["_pos","_unitCount","_vehCount","_townName"];

missionNamespace setVariable [format ["%1_%2",QUOTE(ADDON),_townName],true];

// spawn units
_grp = [_pos,0,_unitCount,CIVILIAN] call EFUNC(main,spawnGroup);
[units _grp,150] call EFUNC(main,setPatrol);

{
	_x addEventHandler ["firedNear",{
		if !((_this select 0) getVariable [QUOTE(DOUBLES(PREFIX,isOnPatrol)),-1] isEqualTo 0) then {
			(_this select 0) setVariable [QUOTE(DOUBLES(PREFIX,isOnPatrol)),0];
			if (random 1 < 0.5) then {
				(_this select 0) disableAI "MOVE";
				(_this select 0) setCombatMode "BLUE";
				(_this select 0) setUnitPos "DOWN";
			} else {
				(_this select 0) forceSpeed ((_this select 0) getSpeed "FAST");
				(_this select 0) setUnitPos "MIDDLE";
				(_this select 0) doMove ([getposASL (_this select 0),1000,2000] call EFUNC(main,findRandomPos));
			};
		};
	}];
	false
} count units _grp;

// spawn vehicles
_roads = _pos nearRoads 100;
_vehGrp = createGroup CIVILIAN;
if (count _roads >= _vehCount) then {
	for "_i" from 1 to _vehCount do {
		_veh = (selectRandom EGVAR(main,vehPoolCiv)) createVehicle (getPosATL (selectRandom _roads));
		_veh setVectorUp surfaceNormal getPos _veh;
		_unit = _vehGrp createUnit [(selectRandom EGVAR(main,unitPoolCiv)), _pos, [], 0, "NONE"];
		_unit moveInDriver _veh;
		_veh allowCrewInImmobile true;
		[units _vehGrp,GVAR(spawnDist)*2 min 1500] call EFUNC(main,setPatrol);
	};
} else {
	deleteGroup _vehGrp;
};

// hostile unit
if ((CHECK_ADDON_2(approval) && true) || {!(CHECK_ADDON_2(approval)) && random 1 < 0.1}) then {
	_unit = selectRandom ((units _vehGrp) + (units _grp));
	_targets = [getPosATL _unit,GVAR(spawnDist)+50] call EFUNC(main,getNearPlayers);
	if !(_targets isEqualTo []) then {
		_unit setVariable [QUOTE(DOUBLES(PREFIX,isOnPatrol)),0];
		_unit = [[_unit]] call EFUNC(main,setSide);
		[leader _unit,round random 1,selectRandom _targets] call FUNC(setHostile);
	};
};

// despawn PFH
[{
	params ["_args","_idPFH"];
	_args params ["_pos","_townName","_grp","_vehGrp"];

	if ({_x distance _pos < GVAR(spawnDist)} count allPlayers isEqualTo 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		missionNamespace setVariable [format ["%1_%2",QUOTE(ADDON),_townName],false];
		((units _grp)+(units _vehGrp)) call EFUNC(main,cleanup);
	};
}, 30, [_pos,_townName,_grp,_vehGrp]] call CBA_fnc_addPerFrameHandler;