/*
Author:
Nicholas Clark (SENSEI)

Description:
setup curator eventhandlers

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define SET_COST(COST) \
	_cost = if (_side isEqualTo _playerSide || {_side isEqualTo 3}) then { \
		[true,COST] \
	} else { \
		[false,COST]; \
	};

GVAR(curator) removeAllEventHandlers "CuratorObjectRegistered";
GVAR(curator) addEventHandler ["CuratorObjectRegistered",{
	private ["_playerSide","_costs","_side","_vehClass","_cost"];

	// _playerSide is the side of the player's class, not necessarily the player's side
	_playerSide = getNumber (configFile >> "CfgVehicles" >> typeOf getAssignedCuratorUnit GVAR(curator) >> "side");
	_costs = [];
	{
		// TODO following code may be missing a few vehicle classes that are relevant to an fob
		call {
			_side = getNumber (configFile >> "CfgVehicles" >> _x >> "side");
			_vehClass = toLower getText (configFile >> "CfgVehicles" >> _x >> "vehicleClass");
			if (_vehClass in ["men","menstory","menrecon","mendiver","mensniper","mensupport"]) exitWith {
				SET_COST(COST_MAN)
			};
			if (_vehClass in ["car","support"]) exitWith {
				SET_COST(COST_CAR)
			};
			if (_vehClass in ["armored"]) exitWith {
				SET_COST(COST_TANK)
			};
			if (_vehClass in ["air"]) exitWith {
				SET_COST(COST_AIR)
			};
			if (_vehClass in ["ship","submarine"]) exitWith {
				SET_COST(COST_SHIP)
			};
			if (_vehClass in ["ammo"]) exitWith {
				SET_COST(COST_AMMO)
			};
			if (_vehClass in ["structures","structures_military","structures_village","structures_infrastructure","structures_industrial"]) exitWith {
				SET_COST(COST_STRUCT)
			};
			if (_vehClass in ["fortifications"]) exitWith {
				SET_COST(COST_FORT)
			};
			if (_vehClass in ["signs"]) exitWith {
				SET_COST(COST_SIGN)
			};
			if (_vehClass in ["small_items","objects","furniture","tents"]) exitWith {
				SET_COST(COST_ITEM)
			};
			_cost = [true,1];
		};
		_costs pushBack _cost;
	} forEach (_this select 1);
	_costs
}];

GVAR(curator) removeAllEventHandlers "CuratorObjectPlaced";
GVAR(curator) addEventHandler ["CuratorObjectPlaced",{
	if (typeOf (_this select 1) in ARRAY_MED) then {
		(_this select 1) setVariable ["ace_medical_isMedicalFacility",true,true];
	};
	if (typeOf (_this select 1) in ARRAY_HQ) then {
		if ({typeOf _x in ARRAY_HQ} count (curatorEditableObjects GVAR(curator)) <= 1) then {
			["HQ deployed.\nAerial reconnaissance online.",true] call EFUNC(main,displayText);
		};
	};
	if (CHECK_ADDON_2(approval)) then {
		// TODO add approval increase
	};
}];

GVAR(curator) removeAllEventHandlers "CuratorObjectDeleted";
GVAR(curator) addEventHandler ["CuratorObjectDeleted",{
	if (typeOf (_this select 1) in ARRAY_HQ) then {
		if ({typeOf _x in ARRAY_HQ} count (curatorEditableObjects GVAR(curator)) isEqualTo 0) then {
			["HQ removed.\nAerial reconnaissance offline.",true] call EFUNC(main,displayText);
		};
	};
	if (CHECK_ADDON_2(approval)) then {
		// TODO add approval decrease
	};
}];