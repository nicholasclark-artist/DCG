/*
Author:

Description:
removes particle

Arguments:
0: center position or object to search from <ARRAY, OBJECT>
1: range to search for particles <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_center",["_range",5]];

{
	if (toUpper (getText (configfile >> "CfgVehicles" >> (typeOf _x) >> "vehicleClass")) isEqualTo "EMITTERS") then {
		_x addMPEventHandler ["MPKilled", {
			{
				deleteVehicle _x;
			} forEach ((_this select 0) getVariable ["effects", []]);

			if (isServer) then {
				deleteVehicle (_this select 0);
			};
		}];

		_x setDamage 1;
	};
} forEach (_center nearEntities _range);