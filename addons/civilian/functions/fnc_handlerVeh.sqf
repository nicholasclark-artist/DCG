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
#define RANGE 1000
#define BUFFER 300
#define ITERATIONS 250

[{
	private ["_HCs","_players","_player","_roads","_roadStart","_roadEnd","_roadMid","_road","_roadConnect","_mrk"];

	// spawn dynamic vehicles
	if (count GVAR(vehicles) <= GVAR(vehMaxCount)) then {
		_HCs = entities "HeadlessClient_F";
		_players = allPlayers - _HCs;

		if !(_players isEqualTo []) then {
			_player = selectRandom _players; // get target player

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
					if (_i isEqualTo ITERATIONS || {!(CHECK_VECTORDIST(getPosASL _road,getPosASL _roadMid,RANGE))}) exitWith {
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
					if (_i isEqualTo ITERATIONS || {!(CHECK_VECTORDIST(getPosASL _road,getPosASL _roadMid,RANGE))}) exitWith {
						_roadEnd = _road;
					};
				};

				if (!([getPosASL _roadStart,_player] call EFUNC(main,inLOS)) &&
				    {([_roadStart,BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo []} &&
					{([_roadEnd,BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo []} &&
					{!(CHECK_DIST2D(_roadStart,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))} &&
					{!(CHECK_DIST2D(_roadEnd,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))}) then {
						[_roadStart,_roadMid,_roadEnd,_player] spawn FUNC(spawnVeh);
						if (CHECK_DEBUG) then {
							_mrk = createMarker [format ["%1_%2", _roadStart,time], getpos _roadStart];
							_mrk setMarkerType "mil_dot";
							_mrk setMarkerColor "colorGREEN";
							_mrk setMarkerText "ROAD START";

							_mrk = createMarker [format ["%1_%2", _roadEnd,time], getpos _roadEnd];
							_mrk setMarkerType "mil_dot";
							_mrk setMarkerColor "colorRED";
							_mrk setMarkerText "ROAD END";
						};
				};
			};
		};
	};
}, GVAR(vehCooldown) max 180, []] call CBA_fnc_addPerFrameHandler;

