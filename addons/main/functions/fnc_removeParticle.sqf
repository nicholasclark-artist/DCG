/*
Author:

Description:
removes particle

Arguments:
0: center position search around or array of objects <ARRAY, OBJECT>
1: range to search for particles <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
	["_center",[],[[]]],
	["_range",5,[0]]
];

private _arr = [];

call {
	if ((_center select 0) isEqualType 0) exitWith {
		_arr = _center nearEntities _range;
	};

	if ((_center select 0) isEqualType objNull) exitWith {
		_arr = _center;
	};
};

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
} forEach _arr;