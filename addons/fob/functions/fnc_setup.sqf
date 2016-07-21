/*
Author:
Nicholas Clark (SENSEI)

Description:
setup fob on server

Arguments:
0: unit to assign to curator <OBJECT>
1: fob position <ARRAY>
2: points available to curator <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define ARMORY_STATE "if (isClass (configfile >> 'CfgPatches' >> 'acre_main')) then {{player removeItem _x} forEach (call acre_api_fnc_getCurrentRadioList);}; ['Open',true] spawn dcg_main_fnc_arsenal;"
#define ARMORY_COND QUOTE(true)

if !(isServer) exitWith {};

private ["_cargo","_actions","_location"];
params ["_unit","_pos",["_points",1]];

_pos set [2,0];
_cargo = "";

call {
	if (EGVAR(main,playerSide) isEqualTo WEST) exitWith {
		_cargo = "B_CargoNet_01_ammo_F";
	};
	if (EGVAR(main,playerSide) isEqualTo EAST) exitWith {
		_cargo = "O_CargoNet_01_ammo_F"
	};
	if (EGVAR(main,playerSide) isEqualTo INDEPENDENT) exitWith {
		_cargo = "I_CargoNet_01_ammo_F"
	};
	_cargo = "B_CargoNet_01_ammo_F";
};

GVAR(anchor) = _cargo createVehicle (_unit modelToWorld [0,4,0]);
GVAR(anchor) allowDamage false;

_actions = [[QUOTE(DOUBLES(ADDON,armory)),"Open Armory",ARMORY_STATE,QUOTE(true),"",GVAR(anchor),0,["ACE_MainActions"]]];
REMOTE_WAITADDACTION(0,_actions,GVAR(anchor));

_location = [_pos,"NameCity",GVAR(range),GVAR(name),QGVAR(location)];
REMOTE_CREATELOCATION(0,_location,CREATELOC_JIPID);

// assign unit and send unit curator UID
// unit does not immediately become owner of curator, it takes a few seconds
if !(isNull _unit) then {
	_unit assignCurator GVAR(curator);
	GVAR(UID) = getPlayerUID _unit;
	(owner _unit) publicVariableClient QGVAR(UID);
};

/*removeAllCuratorAddons GVAR(curator);
GVAR(curator) addCuratorAddons GVAR(addons);*/
GVAR(curator) addCuratorPoints _points;
GVAR(curator) setCuratorCoef ["Place", GVAR(placingMultiplier)];
GVAR(curator) setCuratorCoef ["Delete", GVAR(deletingMultiplier)];
GVAR(curator) setCuratorWaypointCost 0;
GVAR(curator) addCuratorEditingArea [0,_pos,GVAR(range)];
GVAR(curator) addCuratorCameraArea [0,_pos,GVAR(range)];
GVAR(curator) setCuratorCameraAreaCeiling 40;
[GVAR(curator),"object",["UnitPos","Rank","Lock"]] call BIS_fnc_setCuratorAttributes;

[QGVAR(curatorEH), [], _unit] call CBA_fnc_targetEvent;