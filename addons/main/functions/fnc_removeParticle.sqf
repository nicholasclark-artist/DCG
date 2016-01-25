/*
Author:

Last modified: 10/21/2015

Description: removes particle

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"

params ["_pos",["_range",5]];

{
	if (typeOf _x isEqualTo "#particlesource") then {
		_x addMPEventHandler ["MPKilled", {
			_this = _this select 0;
			{
				deleteVehicle _x;
			} forEach (_this getVariable ["effects", []]);
			if (isServer) then {
				deleteVehicle _this;
			};
		}];

		_x setDamage 1;
	};
} forEach (_pos nearObjects _range);