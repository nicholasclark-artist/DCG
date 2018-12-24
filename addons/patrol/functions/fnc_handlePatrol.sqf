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

if (count GVAR(groups) <= ceil GVAR(groupsMaxCount)) then {
	_players = call CBA_fnc_players;

	if !(_players isEqualTo []) then {
		_player = selectRandom _players;

		if ((GVAR(blacklist) findIf {_player inArea [_x select 0,_x select 1,_x select 1,0,false,-1]}) < 0) then { // check if player is in a blacklist area
			_posArray = [getpos _player,100,PATROL_RANGE,PATROL_MINRANGE,10,0,false] call EFUNC(main,findPosGrid);

            if (_posArray isEqualTo []) exitWith {};

            _pos = selectRandom _posArray;
            _players = [getPos _player,100] call EFUNC(main,getNearPlayers);

			if ([_pos,100] call EFUNC(main,getNearPlayers) isEqualTo [] && {{[_pos,eyePos _x] call EFUNC(main,inLOS)} count _players isEqualTo 0}) then {
				_grp = grpNull;
                _pos = ASLtoAGL _pos;

				if (random 1 < GVAR(vehChance)) then {
					_grp = [_pos,1,1,EGVAR(main,enemySide),1,true] call EFUNC(main,spawnGroup);
                    [_grp] call EFUNC(cache,disableCache);

					[
						{count units (_this select 0) > 0},
						{
                            params ["_grp","_player"];

                            // set waypoint around target player
                            _wp = _grp addWaypoint [getPosATL _player,0];
                            _wp setWaypointCompletionRadius 200;
                            _wp setWaypointBehaviour "SAFE";
                            _wp setWaypointFormation "STAG COLUMN";
                            _wp setWaypointSpeed "NORMAL";
                            _wp setWaypointStatements [
                                "!(behaviour this isEqualTo ""COMBAT"")",
                                format ["[this, this, %1, 5, ""MOVE"", ""SAFE"", ""YELLOW"", ""NORMAL"", ""STAG COLUMN"", """", [5,10,15]] call CBA_fnc_taskPatrol;",PATROL_RANGE]
                            ];
						},
						[_grp,_player]
					] call CBA_fnc_waitUntilAndExecute;

					INFO_1("Spawning vehicle patrol at %1",_pos);
				} else {
					_count = 4;
					_grp = [_pos,0,_count,EGVAR(main,enemySide),2] call EFUNC(main,spawnGroup);
                    [_grp] call EFUNC(cache,disableCache);
                    
					[
						{count units (_this select 0) isEqualTo (_this select 2)},
						{
							params ["_grp","_player","_count"];

							// set waypoint around target player
							_wp = _grp addWaypoint [getPosATL _player,0];
							_wp setWaypointCompletionRadius 50;
							_wp setWaypointBehaviour "SAFE";
							_wp setWaypointFormation "STAG COLUMN";
							_wp setWaypointSpeed "LIMITED";
							_wp setWaypointStatements [
                                "!(behaviour this isEqualTo ""COMBAT"")",
                                format ["[this, this, %1, 5, ""MOVE"", ""SAFE"", ""YELLOW"", ""LIMITED"", ""STAG COLUMN"", """", [0,0,0]] call CBA_fnc_taskPatrol;",PATROL_RANGE]
                            ];
						},
						[_grp,_player,_count]
					] call CBA_fnc_waitUntilAndExecute;

					INFO_1("Spawning infantry patrol at %1",_pos);
				};
				GVAR(groups) pushBack _grp;
			};
		};
	};
};
