/*
Author:
Nicholas Clark (SENSEI)

Description:
add recon UAV to FOB

Arguments:
0: to add or remove recon <BOOL>
1: position to add recon <ARRAY>
2: side of recon UAV <SIDE>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_type","_wp"];
params [
	["_ifRecon",true],
	["_position",[0,0,0]],
	["_side",EGVAR(main,playerSide)]
];

if (_ifRecon) then {
	_type = "";

	call {
		if (_side isEqualTo WEST) exitWith {
			_type = "B_UAV_02_F";
		};
		if (_side isEqualTo EAST) exitWith {
			_type = "O_UAV_02_F";
		};
		if (_side isEqualTo RESISTANCE) exitWith {
			_type = "I_UAV_02_F";
		};
	};

	RECON = createVehicle [_type, _position, [], 0, "FLY"];
	(owner (getAssignedCuratorUnit GVAR(curator))) publicVariableClient QUOTE(RECON);
    createVehicleCrew RECON;
	RECON allowDamage false;
	RECON setCaptive true;
    {
        _x setCaptive true;
    } forEach crew RECON;
	RECON setVehicleAmmo 0;
	RECON lockDriver true;
	RECON flyInHeight 200;

	RECON addEventHandler ["Fuel",{if !(_this select 1) then {(_this select 0) setFuel 1}}];

	_wp = group RECON addWaypoint [_position, 0];
	_wp setWaypointType "LOITER";
	_wp setWaypointLoiterType "CIRCLE_L";
	_wp setWaypointLoiterRadius GVAR(range);
} else {
	deleteVehicle RECON;
};
