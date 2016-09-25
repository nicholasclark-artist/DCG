/*
Author:
Nicholas Clark (SENSEI)

Description:
setup eventhandlers on curator unit

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
// #define FOB_NAME format ["%1 (+ %2 Approval)", GVAR(name), GVAR(AVBonus)]

LOG_DEBUG_1("Running curator eventhandlers on %1.",getAssignedCuratorUnit GVAR(curator));

GVAR(curator) removeAllEventHandlers "CuratorObjectRegistered";
GVAR(curator) addEventHandler ["CuratorObjectRegistered",{
	private ["_playerSide","_costs","_side","_vehClass","_cost"];

	// _playerSide is the side of the player's class, not necessarily the player's side
	_playerSide = getNumber (configFile >> "CfgVehicles" >> typeOf getAssignedCuratorUnit GVAR(curator) >> "side");
	_costs = [];
	{
		_side = getNumber (configFile >> "CfgVehicles" >> _x >> "side");
		_cost = [_x] call FUNC(getCuratorCost);

		if (!(_cost isEqualTo 0) && {_side isEqualTo _playerSide || _side isEqualTo 3}) then {
			_cost = [true,_cost];
		} else {
			_cost = [false,_cost];
		};

		_costs pushBack _cost;
	} forEach (_this select 1);

	_costs
}];

GVAR(curator) removeAllEventHandlers "CuratorObjectPlaced";
GVAR(curator) addEventHandler ["CuratorObjectPlaced",{
	if (typeOf (_this select 1) in FOB_MED) then {
		(_this select 1) setVariable ["ace_medical_isMedicalFacility",true,true];
	};

	if (EGVAR(approval,enable) isEqualTo 1) then {
		_cost = [typeOf (_this select 1)] call FUNC(getCuratorCost);
		_cost = _cost*COST_MULTIPIER;

		missionNamespace setVariable [PVEH_AVADD,[getPosASL (_this select 1),_cost]];
		publicVariableServer PVEH_AVADD;
		/*GVAR(AVBonus) = round(GVAR(AVBonus) + _cost);
		publicVariable QGVAR(AVBonus);

		{GVAR(location) setText FOB_NAME} remoteExecCall [QUOTE(BIS_fnc_call),0,false];*/
	};
}];

GVAR(curator) removeAllEventHandlers "CuratorObjectDeleted";
GVAR(curator) addEventHandler ["CuratorObjectDeleted",{
	if (EGVAR(approval,enable) isEqualTo 1) then {
		_cost = [typeOf (_this select 1)] call FUNC(getCuratorCost);
		_cost = _cost*COST_MULTIPIER;

		missionNamespace setVariable [PVEH_AVADD,[getPosASL (_this select 1),_cost * -1]];
		publicVariableServer PVEH_AVADD;
		/*GVAR(AVBonus) = round(GVAR(AVBonus) - _cost);
		publicVariable QGVAR(AVBonus);
		{GVAR(location) setText FOB_NAME} remoteExecCall [QUOTE(BIS_fnc_call),0,false];*/
	};
}];