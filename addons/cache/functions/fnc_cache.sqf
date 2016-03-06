/*
Author:
Nicholas Clark (SENSEI)

Description:
caches unit

Arguments:
0: unit to be cached <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_unit"];

if (!isPlayer _unit && {!("driver" in assignedVehicleRole _unit)}) then {
	_unit enableSimulationGlobal false;
	_unit hideObjectGlobal true;
	[_unit] call FUNC(addEventhandler);
	if (vehicle _unit isEqualTo _unit) then {
		_unit attachTo [leader _unit];
	};
	//LOG_DEBUG_2("caching %1 %2",_unit,typeof _unit);
};