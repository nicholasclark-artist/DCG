/*
Author:
Nicholas Clark (SENSEI)

Description:
handles civilian unit spawns

Arguments:
0: positions to watch for civ spawns <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define ZDIST 65

[{
	params ["_args","_idPFH"];
	_args params ["_positions"];
	{
		if !(missionNamespace getVariable [format ["%1_%2", QUOTE(ADDON),_x select 0],false]) then {
			private ["_position","_unitCount"];
			_position = _x select 1;
			if ({CHECK_VECTORDIST(_position,getPosASL (vehicle _x),GVAR(spawnDist)) && {((getPos (vehicle _x)) select 2) < ZDIST}} count allPlayers > 0) then {
				call {
					if ((_x select 3) isEqualTo "NameCityCapital") exitWith {
						_unitCount = ceil(GVAR(countCapital));
					};
					if ((_x select 3) isEqualTo "NameCity") exitWith {
						_unitCount = ceil(GVAR(countCity));
					};
					_unitCount = ceil(GVAR(countVillage));
				};
				[ASLToAGL _position,_unitCount,_x select 0] spawn FUNC(spawnUnit);
			};
		};
	} forEach _positions;
}, 15, [_this select 0]] call CBA_fnc_addPerFrameHandler;