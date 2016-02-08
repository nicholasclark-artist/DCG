/*
Author:
Nicholas Clark (SENSEI)

Description:
uncaches unit

Arguments:
0: unit to be uncached <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_unit"];

if (!isPlayer _unit && {!("driver" in assignedVehicleRole _unit)}) then {
	_unit enableSimulationGlobal true;
	_unit hideObjectGlobal false;
	detach _unit;
	//LOG_DEBUG_2("uncaching %1 %2",_unit,typeof _unit);
};