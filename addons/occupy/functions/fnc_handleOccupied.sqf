/*
Author:
Nicholas Clark (SENSEI)

Description:
runs when players enter occupied location

Arguments:
0: location data <ARRAY>
1: enemy count at the time player enters location <NUMBER>
2: vfx objects <ARRAY>
3: officer unit <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define INTERVAL 30
#define SURRENDER_VAR(SURNAME) format ["%1_%2_surrendered",PREFIX,SURNAME]
#define SURRENDER_CHANCE 0.3
#define REINFORCE_CHANCE 0.1
#define ENTITY ["Man","LandVehicle","Air","Ship"]
#define ENEMYMAX_MULTIPLIER 0.5

params ["_town","_objArray","_officer","_task"];

private _maxCount = 0;

{
	if (GET_UNITVAR(driver _x)) then {
		_maxCount = _maxCount + 1;
	};
	false
} count ((_town select 1) nearEntities [ENTITY, _town select 2]);

// reinforcements
missionNamespace setVariable [SURRENDER_VAR(_town select 0),false];

[{
	params ["_args","_idPFH"];
	_args params ["_town"];

	// exit if enemy surrenders
	if (missionNamespace getVariable [SURRENDER_VAR(_town select 0),false]) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
	};

	if (random 1 < REINFORCE_CHANCE) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_town select 1,EGVAR(main,enemySide),_town select 2] spawn EFUNC(main,spawnReinforcements);
	};
}, 60, [_town]] call CBA_fnc_addPerFrameHandler;

[{
	params ["_args","_idPFH"];
	_args params ["_town","_maxCount","_objArray","_officer","_task"];

	private _count = 0;

	{
		if (side _x isEqualTo EGVAR(main,enemySide)) then {
			_count = _count + 1;
		};
	} forEach ((_town select 1) nearEntities [ENTITY, _town select 2]);

	//LOG_DEBUG_2("%1 - %2",_maxCount,_count);

	// if enemy has lost a certain amount of units, move to next phase
	if (_count <= _maxCount*ENEMYMAX_MULTIPLIER) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;

		[format ["The enemy is losing control of %1! Keep up the fight and they may surrender!",_town select 0],true] remoteExecCall [QEFUNC(main,displayText), allPlayers, false];
		EGVAR(patrol,blacklist) pushBack [_town select 1,_town select 2]; // stop patrols from spawning in town

		[{
			params ["_args","_idPFH"];
			_args params ["_town","_maxCount","_objArray","_officer","_task"];
			_town params ["_name","_position","_size","_type"];

			private _friendlyScore = 1;
			private _enemyScore = 1;
			private _enemyArray = [];

			// get scores for all units in town
			{
				if (side _x isEqualTo EGVAR(main,playerSide)) then {
					if (vehicle _x isKindOf "Man") then {
						_friendlyScore = _friendlyScore + 1;
					} else {
						_friendlyScore = _friendlyScore + 2;
					};
				} else {
					if (side _x isEqualTo EGVAR(main,enemySide)) then {
						if (vehicle _x isKindOf "Man") then {
							_enemyScore = _enemyScore + 1;
						} else {
							_enemyScore = _enemyScore + 2;
						};
						_enemyArray pushBack _x;
					};
				};
			} forEach (_position nearEntities [ENTITY, _size]);

			// get chance for enemies to surrender
			// surrender chance is capped
			_chanceSurrender = (_friendlyScore/_enemyScore) min SURRENDER_CHANCE;
			LOG_DEBUG_4("E_Score: %1, F_Score: %2, E_Count: %3, S_Chance: %4.",_enemyScore,_friendlyScore,count _enemyArray,_chanceSurrender);

			if (count _enemyArray isEqualTo 0 || {_enemyScore <= _friendlyScore && (random 1 < _chanceSurrender)}) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;

				missionNamespace setVariable [SURRENDER_VAR(_name),true];
				[_task] call EFUNC(main,setTaskState);

				{
					if !(isNull _x) then {
						if !(typeOf (vehicle _x) isKindOf "AIR") then {
							[vehicle _x] call EFUNC(main,setSurrender);
							if !(_x getVariable [QUOTE(DOUBLES(ADDON,officer)),false]) then {
								_x call EFUNC(main,cleanup);
							};
						} else {
							_x setBehaviour "CARELESS";
							(vehicle _x) call EFUNC(main,cleanup);
						};
					};
				} forEach _enemyArray;

				if (CHECK_ADDON_2(approval)) then {
					if (_type isEqualTo "NameCityCapital") exitWith {
						[_position,AV_CAPITAL] call EFUNC(approval,addValue);
					};
					if (_type isEqualTo "NameCity") exitWith {
						[_position,AV_CITY] call EFUNC(approval,addValue);
					};
					[_position,AV_VILLAGE] call EFUNC(approval,addValue);
				};

				GVAR(locations) = GVAR(locations) - [_town];
				EGVAR(patrol,blacklist) deleteAt (EGVAR(patrol,blacklist) find [_position,_size]);
				[{
					EGVAR(civilian,blacklist) deleteAt (EGVAR(civilian,blacklist) find (_this select 0));
				}, [_name], 300] call CBA_fnc_waitAndExecute;

				{
					[getPosATL _x] call EFUNC(main,removeParticle);
					deleteVehicle _x;
				} forEach _objArray;

				if (CHECK_DEBUG) then {
					deleteMarker (format["%1_%2_debug",QUOTE(ADDON),_name]);
				};

				// setup next round of occupied locations
				if (GVAR(locations) isEqualTo []) then {
					[FUNC(findLocation), [], GVAR(cooldown)] call CBA_fnc_waitAndExecute;
				};
			};
		}, INTERVAL, _args] call CBA_fnc_addPerFrameHandler;
	};
}, INTERVAL, [_town,_maxCount,_objArray,_officer,_task]] call CBA_fnc_addPerFrameHandler;