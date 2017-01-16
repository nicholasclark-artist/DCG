/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - rescue VIP

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_PRIMARY
#define TASK_NAME 'Rescue VIP'
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_drivers = [];
_town = [];
_cleanup = [];
_strength = TASK_STRENGTH + TASK_GARRISONCOUNT;
_vehGrp = grpNull;

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"house"] call EFUNC(main,findPosTerrain);
	if !(_position isEqualTo []) then {
		_position = _position select 1;
	};
};

// find return location
if !(EGVAR(main,locations) isEqualTo []) then {
	if (CHECK_ADDON_2(occupy)) then {
		_town = selectRandom (EGVAR(main,locations) select {
            !(_x in EGVAR(occupy,locations)) &&
            {!(_position inArea [_x select 1, _x select 2,  _x select 2, 0, false, -1])}
        });
	} else {
		_town = selectRandom (EGVAR(main,locations) select {
            !(_position inArea [_x select 1, _x select 2,  _x select 2, 0, false, -1])
        });
	};
};

// cannot move vip without ACE captives addon
// TODO add vanilla compatible version
if (_position isEqualTo [] || {_town isEqualTo []} || {!(CHECK_ADDON_1("ace_captives"))}) exitWith {
	TASK_EXIT_DELAY(0);
};

_vip = (createGroup civilian) createUnit ["C_Nikos", [0,0,0], [], 0, "NONE"];
_vip setDir random 360;
_vip setPosASL _position;
_cleanup pushBack _vip;
[_vip,"Acts_AidlPsitMstpSsurWnonDnon02",true] call EFUNC(main,setAnim);

_grp = [[_position,5,20] call EFUNC(main,findPosSafe),0,_strength,EGVAR(main,enemySide),false,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 1)},
	{
        params ["_grp","_strength","_cleanup"];

        _cleanup append (units _grp);

        // regroup garrison units
        _garrisonGrp = createGroup EGVAR(main,enemySide);
        ((units _grp) select [0,TASK_GARRISONCOUNT]) joinSilent _garrisonGrp;
        [_garrisonGrp,_garrisonGrp,_bRadius,1,true] call CBA_fnc_taskDefend;

        // regroup patrols
        for "_i" from 0 to (count units _grp) - 1 step TASK_PATROL_UNITCOUNT do {
            _patrolGrp = createGroup EGVAR(main,enemySide);
            ((units _grp) select [0,TASK_PATROL_UNITCOUNT]) joinSilent _patrolGrp;
            [_patrolGrp, _patrolGrp, _bRadius, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [0,5,8]] call CBA_fnc_taskPatrol;
        };
	},
	[_grp,_strength,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

_vehPos = [_position,50,100,8,0] call EFUNC(main,findPosSafe);

if !(_vehPos isEqualTo _position) then {
	_vehGrp = [_vehPos,1,1,EGVAR(main,enemySide),false,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);
	[
		{{_x getVariable [ISDRIVER,false]} count (units (_this select 1)) > 0},
		{
            params ["_position","_vehGrp"];

            _cleanup pushBack (objectParent leader _vehGrp);
            _cleanup pushBack (units _vehGrp);

			[_vehGrp, _position, 200, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [5,10,15]] call CBA_fnc_taskPatrol;
		},
		[_position,_vehGrp,_cleanup]
	] call CBA_fnc_waitUntilAndExecute;
};

// SET TASK
_taskPos = ASLToAGL ([_position,100,150] call EFUNC(main,findPosSafe));
_taskDescription = format ["We have intel that the son of a local elder has been taken hostage by enemy forces. Locate the VIP, %1, and safely escort him to %2.", name _vip, _town select 0];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"meet"] call EFUNC(main,setTask);

TASK_DEBUG(getpos _vip);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_vip","_town","_cleanup"];

	_success = false;

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
		[TASK_TYPE,30] call FUNC(select);
	};

	if !(alive _vip) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL((getPos _vip),TASK_AV * -1);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT;
	};

    _distRet = (_town select 2)*0.5 max TASK_DIST_RET;

	// if vip is returned to town and is alive/awake
	if (_vip inArea [_town select 1, _distRet, _distRet, 0, false, -1]) then {
		if (CHECK_ADDON_1("ace_medical")) then {
			if ([_vip] call ace_common_fnc_isAwake) then {
				_success = true;
			};
		} else {
			if (alive _vip) then {
				_success = true;
			};
		};
	};

	if (_success) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL((getPos _vip),TASK_AV);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_vip,_town,_cleanup]] call CBA_fnc_addPerFrameHandler;
