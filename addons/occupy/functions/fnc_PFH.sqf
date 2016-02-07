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
#define SURRENDER_MAXTIME 300
#define SURRENDER_VAR format ["%1_%2_surrendered",PREFIX,_name]
#define REINFORCE_CHANCE 0.1
#define ENTITY ["Man","LandVehicle","Air","Ship"]
#define ENEMYMAX_MULTIPLIER 0.5
#define SURRENDER_MAXTIME 300

// reinforcements PFH
[{
	params ["_args","_idPFH"];
	_args params ["_town"];

	// exit if enemy surrenders
	if (missionNamespace getVariable [SURRENDER_VAR,false]) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
	};

	if (random 1 < REINFORCE_CHANCE) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_town select 1,EGVAR(main,enemySide),_town select 2] spawn EFUNC(main,spawnReinforcements);
	};
}, 60, _this] call CBA_fnc_addPerFrameHandler;

// main PFH
[{
	params ["_args","_idPFH"];
	_args params ["_town","_enemyCountMax","_objArray","_officer"];
	private ["_count"];

	_count = 0;
	{
		if (side _x isEqualTo EGVAR(main,enemySide)) then {
			_count = _count + 1;
		};
	} forEach ((_town select 1) nearEntities [ENTITY, _town select 2]);

	// if enemy has lost a certain amount of units, move to next phase
	if (_count <= _enemyCountMax*ENEMYMAX_MULTIPLIER) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;

		[format ["The enemy is losing control of %1! Keep up the fight and they may surrender!",_town select 0],true] remoteExecCall [QEFUNC(main,displayText), allPlayers, false];
		EGVAR(patrol,blacklist) pushBack [_town select 1,_town select 2]; // stop patrols from spawning in town

		[{
			params ["_args","_idPFH"];
			_args params ["_town","_enemyCountMax","_objArray","_officer"];
			_town params ["_name","_position","_size","_type"];
			private ["_friendlyScore","_enemyScore","_enemyArray"];

			_friendlyScore = 0;
			_enemyScore = 0;
			_enemyArray = [];

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
			_chanceSurrender = 1 - (_enemyScore/(_friendlyScore max 1));
			LOG_DEBUG_4("E_Score: %1, F_Score: %2, E_Count: %3, S_Chance: %4.",_enemyScore,_friendlyScore,count _enemyArray,_chanceSurrender);

			// if enemy surrenders, exit
			if (random 1 < _chanceSurrender) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;

				missionNamespace setVariable [SURRENDER_VAR,true];
				[format ["lib_%1", _name]] call EFUNC(main,setTaskState);

				// force surrender
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

				// add approval
				if (CHECK_ADDON_2(approval)) then {
					/*_approval = 0;
					call {
						if (_type isEqualTo "NameCityCapital") exitWith {
							_approval = 100;
						};
						if (_type isEqualTo "NameCity") exitWith {
							_approval = 75;
						};
						_approval = 50;
					};
					_approval call EFUNC(approval,add);*/
				};

				// cleanup
				missionNamespace setVariable [SURRENDER_VAR,nil];
				GVAR(locations) = GVAR(locations) - [_town];
				EGVAR(patrol,blacklist) deleteAt (EGVAR(patrol,blacklist) find [_position,_size]);
				{
					[getPosATL _x] call EFUNC(main,removeParticle);
					deleteVehicle _x;
				} forEach _objArray;
				if (CHECK_DEBUG) then {
					deleteMarker (format["%1_%2_debug",QUOTE(ADDON),_name]);
				};

				// setup next round of occupied locations
				if (GVAR(locations) isEqualTo []) then {
					[{
						params ["_args","_idPFH"];
						_args params ["_cooldown"];

						if (diag_tickTime > _cooldown) exitWith {
							[_idPFH] call CBA_fnc_removePerFrameHandler;
							call FUNC(findLocation);
						};
					}, 1, [diag_tickTime + GVAR(cooldown)]] call CBA_fnc_addPerFrameHandler;
				};
			};
		}, INTERVAL, _args] call CBA_fnc_addPerFrameHandler;
	};
}, 15, _this] call CBA_fnc_addPerFrameHandler;