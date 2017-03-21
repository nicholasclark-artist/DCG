/*
Author:
Nicholas Clark (SENSEI)

Description:
secondary task - repair vehicles

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_SECONDARY
#define TASK_NAME 'Repair Patrol'
#define VEHCOUNT 1
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_unitPool = [];
_vehPool = [];
_vehicles = [];
_cleanup = [];

if (_position isEqualTo []) then {
        _roads = (ASLToAGL (selectRandom EGVAR(main,grid))) nearRoads 300;
    if !(_roads isEqualTo []) exitWith {
        _position = getPos (selectRandom _roads);
    };
};

if !(_position isEqualTo []) then {
    if !([_position,12,0] call EFUNC(main,isPosSafe)) exitWith {
        _position = [];
    };

    if (CHECK_ADDON_2(occupy)) then {
        if (CHECK_DIST2D(EGVAR(occupy,location) select 1,_position,1000)) then {
            _position = [];
        };
    };
};

if (_position isEqualTo []) exitWith {
	[TASK_TYPE,0] call FUNC(select);
};

call {
	if (EGVAR(main,playerSide) isEqualTo EAST) exitWith {
		_unitPool = EGVAR(main,unitPoolEast);
		_vehPool = EGVAR(main,vehPoolEast);
	};
	if (EGVAR(main,playerSide) isEqualTo WEST) exitWith {
		_unitPool = EGVAR(main,unitPoolWest);
		_vehPool = EGVAR(main,vehPoolWest);
	};
    if (EGVAR(main,playerSide) isEqualTo RESISTANCE) exitWith {
        _unitPool = EGVAR(main,unitPoolInd);
    	_vehPool = EGVAR(main,vehPoolInd);
	};
};

_vehicle = (selectRandom _vehPool) createVehicle [0,0,0];
_vehicle setDir random 360;
[_vehicle,AGLtoASL _position] call EFUNC(main,setPosSafe);
_vehicle lock 3;
_vehicle engineOn false;

_grp = createGroup EGVAR(main,playerSide);
_unit = _grp createUnit [selectRandom _unitPool, [0,0,0], [], 0, "NONE"];
_unit moveInDriver _vehicle;
_unit removeItems "ToolKit";

(crew _vehicle) allowGetIn false;
_grp leaveVehicle _vehicle;

[_vehicle,2,{(_this select 0) setVariable [TASK_QFUNC,true]}] call EFUNC(main,setVehDamaged);

_cleanup pushBack _unit;
_cleanup pushBack _vehicle;
_vehicles pushBack _vehicle;

// SET TASK
_taskDescription = format ["A %1 patrol is in need of repairs. Gather the necessary tools and assist the unit.",[EGVAR(main,playerSide)] call BIS_fnc_sideName];
[true,_taskID,[_taskDescription,TASK_TITLE,""],ASLToAGL([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe)),false,0,true,"repair"] call BIS_fnc_taskCreate;

// PUBLISH TASK
TASK_PUBLISH(_position);
TASK_DEBUG(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_vehicles","_cleanup","_position"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call BIS_fnc_taskSetState;
		_cleanup call EFUNC(main,cleanup);
        TASK_EXIT_DELAY(30);
	};

	if ({!alive _x} count _vehicles > 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call BIS_fnc_taskSetState;
		TASK_APPROVAL(_position,TASK_AV * -1);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT;
	};

	if ({_x getVariable [TASK_QFUNC,false]} count _vehicles isEqualTo VEHCOUNT) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		TASK_APPROVAL(_position,TASK_AV);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_vehicles,_cleanup,_position]] call CBA_fnc_addPerFrameHandler;
