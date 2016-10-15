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

params ["_pos","_unitCount","_townName"];

missionNamespace setVariable [LOCATION_ID(_townName),true];

_grp = [_pos,0,_unitCount,CIVILIAN,false,1] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) isEqualTo (_this select 2)},
	{
		params ["_grp","_pos","_unitCount","_townName"];

		{
			_x allowfleeing 0;
			_x addEventHandler ["firedNear",{
				if !((_this select 0) getVariable [QUOTE(DOUBLES(PREFIX,isOnPatrol)),-1] isEqualTo 0) then {
					(_this select 0) setVariable [QUOTE(DOUBLES(PREFIX,isOnPatrol)),0];
					(_this select 0) forceSpeed ((_this select 0) getSpeed "FAST");
					(_this select 0) setUnitPos "MIDDLE";
					(_this select 0) doMove ([getposASL (_this select 0),1000,2000] call EFUNC(main,findPosSafe));
				};
			}];
		} forEach (units _grp);

		[units _grp,100,true,"CARELESS"] call EFUNC(main,setPatrol);

		[{
			params ["_args","_idPFH"];
			_args params ["_pos","_townName","_grp"];

			if ({CHECK_DIST(_x,_pos,GVAR(spawnDist))} count allPlayers isEqualTo 0) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				missionNamespace setVariable [LOCATION_ID(_townName),false];
				(units _grp) call EFUNC(main,cleanup);
			};
		}, 30, [_pos,_townName,_grp]] call CBA_fnc_addPerFrameHandler;
	},
	[_grp,_pos,_unitCount,_townName]
] call CBA_fnc_waitUntilAndExecute;