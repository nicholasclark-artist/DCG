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

[{
	// delete null and lonely groups
	if !(GVAR(groups) isEqualTo []) then {
		for "_i" from (count GVAR(groups) - 1) to 0 step -1 do {
			_grp = GVAR(groups) select _i;

			if (isNull _grp || {([getPosATL (leader _grp),PATROL_RANGE] call EFUNC(main,getNearPlayers) isEqualTo []) && !(behaviour (leader _grp) isEqualTo "COMBAT")}) then {
				if !(isNull _grp) then {
					{
						deleteVehicle _x;
					} forEach (units _grp);
					deleteGroup _grp;
				};
				GVAR(groups) deleteAt _i;
			};
		};
	};

	if (count GVAR(groups) <= GVAR(groupsMaxCount)) then {
		_HCs = entities "HeadlessClient_F";
		_players = allPlayers - _HCs;

		if !(_players isEqualTo []) then {
			_player = selectRandom _players;
			_players = [getPosASL _player,100] call EFUNC(main,getNearPlayers);

			if ({CHECK_DIST2D(_player,(_x select 0),(_x select 1))} count GVAR(blacklist) isEqualTo 0) then { // check if player is in a blacklist array
				_posArray = [getpos _player,100,PATROL_RANGE,PATROL_MINRANGE,6] call EFUNC(main,findPosGrid);
				{ // remove positions in blacklist, that are near players or that players can see
					_y = _x;
					if ({CHECK_DIST2D(_y,(_x select 0),(_x select 1))} count GVAR(blacklist) > 0 ||
					    {count ([_y,100] call EFUNC(main,getNearPlayers)) > 0} /*||
						{[_y,_player] call EFUNC(main,inLOS)}*/ ||
						{{[_y,_x] call EFUNC(main,inLOS)} count _players > 0}) then {
						_posArray deleteAt _forEachIndex;
					};
				} forEach _posArray;

				if !(_posArray isEqualTo []) then {
					_grp = grpNull;
					_pos = selectRandom _posArray;
					if (random 1 < GVAR(vehChance)) then {
						_grp = [_pos,1,1,EGVAR(main,enemySide),false,1,true] call EFUNC(main,spawnGroup);
						[
							{count units (_this select 0) > 0},
							{
								[units (_this select 0),PATROL_RANGE] call EFUNC(main,setPatrol);
							},
							[_grp]
						] call CBA_fnc_waitUntilAndExecute;
					} else {
						_count = UNITCOUNT(4,6);
						_grp = [_pos,0,_count,EGVAR(main,enemySide),false,2] call EFUNC(main,spawnGroup);
						[
							{count units (_this select 0) isEqualTo (_this select 2)},
							{
								_this params ["_grp","_player","_count"];

								// set waypoint around target player
								_wp = _grp addWaypoint [getPosATL _player,50];
								_wp setWaypointCompletionRadius 100;
								_wp setWaypointBehaviour "SAFE";
								_wp setWaypointFormation "STAG COLUMN";
								_wp setWaypointSpeed "LIMITED";
								_wp setWaypointStatements ["!(behaviour this isEqualTo ""COMBAT"")", format ["[thisList,%2,false] call %1;",QEFUNC(main,setPatrol),PATROL_RANGE]];
							},
							[_grp,_player,_count]
						] call CBA_fnc_waitUntilAndExecute;
					};
					GVAR(groups) pushBack _grp;
				};
			};
		};
	};
}, GVAR(cooldown), []] call CBA_fnc_addPerFrameHandler;

if (CHECK_DEBUG) then {
	[{
		{
			if (!(isNull _x) && {count units _x > 0}) then {
				private ["_mrk"];
				_mrk = createMarker [format["%1_%2_tracking",QUOTE(ADDON),getposATL leader _x],getposATL leader _x];
				_mrk setMarkerSize [0.5,0.5];
				_mrk setMarkerColor format ["Color%1", side _x];
				if !(vehicle leader _x isEqualTo leader _x) then {
					_mrk setMarkerType "o_armor";
				} else {
					_mrk setMarkerType "o_inf";
				};
			};
			false
		} count GVAR(groups);
	}, 30, []] call CBA_fnc_addPerFrameHandler;
};
