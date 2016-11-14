/*
Author:
Nicholas Clark (SENSEI)

Description:
create FOB on server

Arguments:
0: unit to assign to curator or position <OBJECT,ARRAY>
1: curator points <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

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
		_pos = _center modelToWorld [0,3,0];
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

GVAR(anchor) = _type createVehicle [0,0,0];
GVAR(anchor) setPos _pos;
publicVariable QGVAR(anchor);
GVAR(anchor) allowDamage false;
clearWeaponCargoGlobal GVAR(anchor);
clearMagazineCargoGlobal GVAR(anchor);
clearItemCargoGlobal GVAR(anchor);
clearBackpackCargoGlobal GVAR(anchor);

// setup anchor and location on all machines
[[],{
    if (hasInterface) then {
        if (CHECK_ADDON_1("ace_cargo")) then {
    		[GVAR(anchor), false] call ace_cargo_fnc_makeLoadable;
    	};

     	[GVAR(anchor)] call EFUNC(main,armory);
    };

 	[getPos GVAR(anchor),"NameCity",GVAR(range),GVAR(name),QGVAR(location)] call EFUNC(main,createLocation);
}] remoteExecCall [QUOTE(BIS_fnc_call),0,GVAR(anchor)];

// make sure setup occurs at correct position
[
    {!(FOB_POSITION isEqualTo [0,0,0])},
    {
        params ["_unit","_points"];

        GVAR(respawnPos) = [missionNamespace,FOB_POSITION,GVAR(name)] call BIS_fnc_addRespawnPosition;
        GVAR(curator) addCuratorPoints _points;
        GVAR(curator) setCuratorCoef ["Place", GVAR(placeCoef) min 0];
        GVAR(curator) setCuratorCoef ["Delete", GVAR(deleteCoef) max 0];
        GVAR(curator) setCuratorWaypointCost 0;
        GVAR(curator) addCuratorEditingArea [0,FOB_POSITION,GVAR(range)];
        GVAR(curator) addCuratorCameraArea [0,FOB_POSITION,GVAR(range)];
        GVAR(curator) setCuratorCameraAreaCeiling 40;
        [GVAR(curator),"object",["UnitPos","Rank","Lock"]] call BIS_fnc_setCuratorAttributes;

        if !(isNull _unit) then {
        	_unit assignCurator GVAR(curator);

            [FOB_POSITION,AV_FOB] call EFUNC(approval,addValue);

        	// unit does not immediately become owner of curator, it takes a few seconds
        	[
        		{getAssignedCuratorUnit GVAR(curator) isEqualTo (_this select 0)},
        		{
        			[] remoteExecCall [QFUNC(curatorEH), owner (getAssignedCuratorUnit GVAR(curator)), false];
        		},
        		[_unit]
        	] call CBA_fnc_waitUntilAndExecute;
        };

        [true,FOB_POSITION] call FUNC(recon);
    },
    [_unit,_points]
] call CBA_fnc_waitUntilAndExecute;
