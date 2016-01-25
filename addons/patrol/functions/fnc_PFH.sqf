/*
Author: SENSEI

Last modified: 1/5/2016

Description: run patrol handler

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"

[{
	// LAYER 1
	// check layer 1
	{
		if (_x isEqualTo grpNull) then {
			GVAR(groups) deleteAt _forEachIndex;
		};
	} forEach GVAR(groups);

	// spawn layer 1 when group array empty
	if (GVAR(groups) isEqualTo []) then {
		_posArray = [EGVAR(main,center),1000,worldSize] call EFUNC(main,findPosGrid);
		if !(_posArray isEqualTo []) then {
			{
				if !(CHECK_DIST2D(_x,locationPosition EGVAR(main,mobLocation),EGVAR(main,mobRadius))) then {
					_posArray deleteAt _forEachIndex;
				};
			} forEach _posArray;
			[{
				params ["_posArray","_idPFH"];

				if (count GVAR(groups) >= LAYER1_COUNT || {count GVAR(groups) >= count _posArray}) exitWith {
					LOG_DEBUG("EXIT PATROL LOOP");
					[_idPFH] call CBA_fnc_removePerFrameHandler;
				};

				_grp = [_posArray select (count GVAR(groups)),0,UNITCOUNT(4,8)] call EFUNC(main,spawnGroup);
				[units _grp,LAYER1_RANGE,false] call EFUNC(main,setPatrol);
				GVAR(groups) pushBack _grp;
			}, 2.5, _posArray] call CBA_fnc_addPerFrameHandler;
		};
	};

	// LAYER 2
	// check layer 2
	{
		if (_x isEqualTo grpNull || {[getPosATL (leader _x),LAYER2_RANGE] call EFUNC(main,getNearPlayers) isEqualTo []}) then {
			if !(_x isEqualTo grpNull) then {
				(units _x) call EFUNC(main,cleanup);
			};
			GVAR(groupsDynamic) deleteAt _forEachIndex;
		};
	} forEach GVAR(groupsDynamic);

	// spawn layer 2
	if (count GVAR(groupsDynamic) <= GVAR(groupsDynamicMaxCount)) then {
		_HCs = entities "HeadlessClient_F";
		_players = allPlayers - _HCs;

		if !(_players isEqualTo []) then {
			_player = _players select floor (random (count _players));
			if !(CHECK_DIST2D(_player,locationPosition EGVAR(main,mobLocation),EGVAR(main,mobRadius))) then {
				_posArray = [getpos _player,10,LAYER2_RANGE,LAYER2_MINRANGE,6] call EFUNC(main,findPosGrid);
				{
					if (terrainIntersect [_player modelToWorld [0,0,3],_x]) exitWith {
						private ["_grp"];
						if (random 1 < GVAR(armoredChance)) then {
							_grp = [_x,1,1] call EFUNC(main,spawnGroup);
							[_grp,LAYER2_RANGE*1.25] call EFUNC(main,setPatrol);
							_grp = group (_grp select 0);
						} else {
							_grp = [_x,0,UNITCOUNT(4,8)] call EFUNC(main,spawnGroup);
							[units _grp,LAYER2_RANGE*1.25,false] call EFUNC(main,setPatrol);
						};
						GVAR(groupsDynamic) pushBack _grp;
					};
				} forEach _posArray;
			};
		};
	};
}, GVAR(interval) max 180, []] call CBA_fnc_addPerFrameHandler;