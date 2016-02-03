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

private ["_fnc_inLOS"];

if (CHECK_DEBUG) then {
	call FUNC(debug);
};

_fnc_inLOS = {
	_pos = _this select 0;
	_unit = _this select 1;

	_posUnit = AGLToASL (_unit modelToWorld [0,0,3]);
	_ret = true;

	if ([getPosASL _unit,getDir _unit,90,_pos] call BIS_fnc_inAngleSector) then {
		if !(terrainIntersectASL [_pos, _posUnit]) then {
		    if (lineIntersects [_pos, _posUnit, _unit]) then {
		        _ret = false;
		    };
		} else {
		    _ret = false;
		};
	} else {
		_ret = false;
	};

	_ret
};

[{
	params ["_args","_idPFH"];
	_args params ["_fnc_inLOS"];
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
			_player = _players select floor (random (count _players));
			_players = [getPosASL _player,100] call EFUNC(main,getNearPlayers);

			if ({CHECK_DIST2D(_player,(_x select 0),(_x select 1))} count GVAR(blacklist) isEqualTo 0) then {
				_posArray = [getpos _player,100,PATROL_RANGE,PATROL_MINRANGE,6] call EFUNC(main,findPosGrid);
				{
					_y = _x;
					if ({CHECK_DIST2D(_y,(_x select 0),(_x select 1))} count GVAR(blacklist) > 0 ||
					    {!([_y,100] call EFUNC(main,getNearPlayers) isEqualTo [])} ||
						{{[_y,_x] call _fnc_inLOS} count _players > 0}) then {
						_posArray deleteAt _forEachIndex;
					};
				} forEach _posArray;

				if !(_posArray isEqualTo []) then {
					_pos = _posArray select floor (random (count _posArray));
					_pos spawn {
						if (random 1 < GVAR(vehChance)) then {
							_grp = [_this,1,1] call EFUNC(main,spawnGroup);
							[_grp,PATROL_RANGE] call EFUNC(main,setPatrol);
							_grp = group (_grp select 0);
						} else {
							// TODO fix caching bug that breaks waypoint for all units in group except leader
							_grp = [_this,0,UNITCOUNT(4,8)] call EFUNC(main,spawnGroup);
							// set waypoint around target player
							_wp = _grp addWaypoint [_player,100];
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
}, GVAR(cooldown) max 180, [_fnc_inLOS]] call CBA_fnc_addPerFrameHandler;