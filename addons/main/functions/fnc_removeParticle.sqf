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
	["_fx",[],[[]]],
	["_range",5,[0]]
];

if ((_fx select 0) isEqualType 0) then {
    _fx = _fx nearEntities _range;
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
} forEach _fx;
