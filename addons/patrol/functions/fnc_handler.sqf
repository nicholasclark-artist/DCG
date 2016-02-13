/*
Author:
Nicholas Clark (SENSEI)

Description:
run patrol handler

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if (CHECK_DEBUG) then {
	call FUNC(debug);
};

[{
	private ["_pos","_unit","_posUnit","_ret","_HCs","_players","_player","_posArray","_y","_grp"];

	// delete null and lonely groups
	if !(GVAR(groups) isEqualTo []) then {
		for "_i" from (count GVAR(groups) - 1) to 0 step -1 do {
			if (isNull (GVAR(groups) select _i) || {([getPosATL (leader (GVAR(groups) select _i)),PATROL_RANGE] call EFUNC(main,getNearPlayers) isEqualTo []) && !(behaviour (leader (GVAR(groups) select _i)) isEqualTo "COMBAT")}) then {
				if !(isNull (GVAR(groups) select _i)) then {
					{
						deleteVehicle _x;
					} forEach (units (GVAR(groups) select _i));
					deleteGroup (GVAR(groups) select _i);
				};
				GVAR(groups) deleteAt _i;
			};
		};
	};

	// spawn dynamic groups
	if (count GVAR(groups) <= GVAR(groupsMaxCount)) then {
		_HCs = entities "HeadlessClient_F";
		_players = allPlayers - _HCs;

		if !(_players isEqualTo []) then {
			_player = selectRandom _players; // get target player
			_players = [getPosASL _player,100] call EFUNC(main,getNearPlayers); // get players in area around target

			if ({CHECK_DIST2D(_player,(_x select 0),(_x select 1))} count GVAR(blacklist) isEqualTo 0) then { // check if player is in a blacklist array
				_posArray = [getpos _player,100,PATROL_RANGE,PATROL_MINRANGE,6] call EFUNC(main,findPosGrid);
				// TODO check LOS for several players if players notice spawn
				{ // remove positions in blacklist, that are near players or that players can see
					_y = _x;
					if ({CHECK_DIST2D(_y,(_x select 0),(_x select 1))} count GVAR(blacklist) > 0 ||
					    {count ([_y,100] call EFUNC(main,getNearPlayers)) > 0} ||
						{[_y,_player] call EFUNC(main,inLOS)} /*||
						{{[_y,_x] call EFUNC(main,inLOS)} count _players > 0}*/) then {
						_posArray deleteAt _forEachIndex;
					};
				} forEach _posArray;

				if !(_posArray isEqualTo []) then {
					[_player,selectRandom _posArray] spawn {
						private ["_grp","_wp"];
						if (random 1 < GVAR(vehChance)) then {
							_grp = [_this select 1,1,1] call EFUNC(main,spawnGroup);
							[_grp,PATROL_RANGE] call EFUNC(main,setPatrol);
							_grp = group (_grp select 0);
						} else {
							// TODO fix caching bug that breaks waypoint for all units in group except leader
							_grp = [_this select 1,0,UNITCOUNT(3,6),EGVAR(main,enemySide),false,2] call EFUNC(main,spawnGroup);
							// set waypoint around target player
							_wp = _grp addWaypoint [getPosATL (_this select 0),100];
							_wp setWaypointCompletionRadius 100;
							_wp setWaypointBehaviour "SAFE";
							_wp setWaypointFormation "STAG COLUMN";
							_wp setWaypointSpeed "LIMITED";
							_wp setWaypointStatements ["!(behaviour this isEqualTo ""COMBAT"")", format ["[thisList,%2,false] call %1;",QEFUNC(main,setPatrol),PATROL_RANGE]];
						};
						GVAR(groups) pushBack _grp;
					};
				};
			};
		};
	};
}, GVAR(cooldown) max 180, []] call CBA_fnc_addPerFrameHandler;