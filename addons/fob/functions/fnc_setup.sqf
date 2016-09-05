/*
Author:
Nicholas Clark (SENSEI)

Description:
setup fob on server

Arguments:
0: unit to assign to curator or position <OBJECT,ARRAY>
1: curator points <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

params [
	["_center",objNull,[objNull,[]]],
	["_points",1,[0]]
];

private _unit = objNull;
private _pos = [];
private _type = "";

call {
	if (_center isEqualType objNull) exitWith {
		_unit = _center;
		_pos = _center modelToWorld [0,4,0];
	};

	if (_center isEqualType []) exitWith {
		_unit = objNull;
		_pos = _center;
	};
};

call {
	if (EGVAR(main,playerSide) isEqualTo WEST) exitWith {
		_type = "B_cargoNet_01_ammo_F";
	};
	if (EGVAR(main,playerSide) isEqualTo EAST) exitWith {
		_type = "O_cargoNet_01_ammo_F"
	};
	if (EGVAR(main,playerSide) isEqualTo INDEPENDENT) exitWith {
		_type = "I_cargoNet_01_ammo_F"
	};
	_type = "B_cargoNet_01_ammo_F";
};

GVAR(anchor) = _type createVehicle _pos;
publicVariable QGVAR(anchor);
GVAR(anchor) allowDamage false;
clearWeaponCargoGlobal GVAR(anchor);
clearMagazineCargoGlobal GVAR(anchor);
clearItemCargoGlobal GVAR(anchor);
clearBackpackCargoGlobal GVAR(anchor);

{
	if (CHECK_ADDON_1("ace_cargo")) then {
		[GVAR(anchor), false] call ace_cargo_fnc_makeLoadable;
	};

 	[GVAR(anchor)] call EFUNC(main,armory);
 	[getPos GVAR(anchor),"NameCity",GVAR(range),GVAR(name),QGVAR(location)] call EFUNC(main,createLocation);
} remoteExecCall [QUOTE(BIS_fnc_call),0,GVAR(anchor)];

/*removeAllCuratorAddons GVAR(curator);
GVAR(curator) addCuratorAddons GVAR(addons);*/
GVAR(curator) addCuratorPoints _points;
GVAR(curator) setCuratorCoef ["Place", GVAR(placingMultiplier)];
GVAR(curator) setCuratorCoef ["Delete", GVAR(deletingMultiplier)];
GVAR(curator) setCuratorWaypointCost 0;
GVAR(curator) addCuratorEditingArea [0,getPos GVAR(anchor),GVAR(range)];
GVAR(curator) addCuratorCameraArea [0,getPos GVAR(anchor),GVAR(range)];
GVAR(curator) setCuratorCameraAreaCeiling 40;
[GVAR(curator),"object",["UnitPos","Rank","Lock"]] call BIS_fnc_setCuratorAttributes;

[getPosASL GVAR(anchor),AV_FOB] call EFUNC(approval,addValue);
/*GVAR(AVBonus) = round(AV_FOB);
publicVariable QGVAR(AVBonus);*/

// assign unit and send unit curator UID
// unit does not immediately become owner of curator, it takes a few seconds
if !(isNull _unit) then {
	_unit assignCurator GVAR(curator);
	GVAR(UID) = getPlayerUID _unit;
	(owner _unit) publicVariableClient QGVAR(UID);

	[
		{(getAssignedCuratorUnit GVAR(curator)) isEqualTo (_this select 0)},
		{
			{
				call FUNC(curatorEH);
			} remoteExecCall [QUOTE(BIS_fnc_call), owner (getAssignedCuratorUnit GVAR(curator)), false];
		},
		[_unit]
	] call CBA_fnc_waitUntilAndExecute;
};

[true,getPosASL GVAR(anchor)] call FUNC(recon);