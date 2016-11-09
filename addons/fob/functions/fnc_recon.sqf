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

	FOB_RECON = createVehicle [_type, _position, [], 0, "FLY"];
	publicVariable QUOTE(FOB_RECON);
    createVehicleCrew FOB_RECON;
	FOB_RECON allowDamage false;
	FOB_RECON setCaptive true;

    {
        _x setCaptive true;
    } forEach crew FOB_RECON;

	FOB_RECON lockDriver true;
	FOB_RECON flyInHeight 200;

	FOB_RECON addEventHandler ["Fuel",{if !(_this select 1) then {(_this select 0) setFuel 1}}];

	_wp = group FOB_RECON addWaypoint [_position, 0];
	_wp setWaypointType "LOITER";
	_wp setWaypointLoiterType "CIRCLE_L";
	_wp setWaypointLoiterRadius GVAR(range);
} else {
	deleteVehicle FOB_RECON;
};
