/*
Author:
Nicholas Clark (SENSEI)

Description:
handles civilian vehicle spawns

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_HCs","_players","_player","_roads","_roadStart","_roadEnd","_roadMid","_road","_roadConnect"];

if (count GVAR(drivers) <= GVAR(vehMaxCount)) then {
	_HCs = entities "HeadlessClient_F";
	_players = allPlayers - _HCs;

	if !(_players isEqualTo []) then {
		_player = selectRandom _players;

		if ((getPos _player) select 2 > 5) exitWith {};

		_roads = _player nearRoads 200;

		// get start and end point for vehicle that passes by target player
		if !(_roads isEqualTo []) then {
			_roadStart = objNull;
			_roadEnd = objNull;

			// get midpoint road
			_roadMid = _roads select 0;
			_road = _roadMid;

			// get roads in start direction
			for "_i" from 1 to ITERATIONS do {
				_roadConnect = roadsConnectedTo _road;

				// if next road doesn't exist, exit with last road
				if (isNil {_roadConnect select 0}) exitWith {
					_roadStart = _road;
				};

				_road = _roadConnect select 0;

				// if loop is done or road is far enough
				if (!(CHECK_VECTORDIST(getPosASL _road,getPosASL _roadMid,RANGE)) || {_i isEqualTo ITERATIONS}) exitWith {
					_roadStart = _road;
				};
			};

			_road = _roadMid;

			// get roads in end direction
			for "_i" from 1 to ITERATIONS do {
				_roadConnect = roadsConnectedTo _road;

				// if next road doesn't exist, exit with last road
				// also check if array is empty, 'select' will throw error when checking for an element more than one index out of range
				if (_roadConnect isEqualTo [] || {isNil {_roadConnect select 1}}) exitWith {
					_roadEnd = _road;
				};

				_road = _roadConnect select 1;

				// if loop is done or road is far enough
				if (!(CHECK_VECTORDIST(getPosASL _road,getPosASL _roadMid,RANGE)) || {_i isEqualTo ITERATIONS}) exitWith {
					_roadEnd = _road;
				};
			};

			if (!(_roadStart isEqualTo _roadEnd) &&
				{!(CHECK_VECTORDIST(getPosASL _roadStart,getPosASL _roadEnd,RANGE))} &&
			    {!([getPosASL _roadStart,_player] call EFUNC(main,inLOS))} &&
			    {([_roadStart,BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo []} &&
			    {([_roadEnd,BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo []} &&
				{!(CHECK_DIST2D(_roadStart,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))} &&
				{!(CHECK_DIST2D(_roadEnd,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))}) then {
					[_roadStart,_roadMid,_roadEnd,_player] call FUNC(spawnVehicle);
			};
		};
	};
};