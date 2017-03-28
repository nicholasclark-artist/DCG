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
#define SET_CAPTIVE(VIP) if (CHECK_ADDON_1("ace_captives")) then { [VIP, true] call ACE_captives_fnc_setHandcuffed; } else { [VIP,"Acts_AidlPsitMstpSsurWnonDnon02",2] call EFUNC(main,setAnim); }
#define SECURE_NAME "Secure VIP"
#define SECURE_STATEMENT _vip = _this select 0; _player = _this select 1; _vip switchMove ""; [_vip] joinSilent grpNull; [_vip] joinSilent (group _player); _vip setBehaviour "CARELESS";
#define SECURE_COND (alive _target) && {(leader group _target) isEqualTo _target}
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_town = [];
_cleanup = [];
_strength = TASK_STRENGTH + TASK_GARRISONCOUNT;
_vehGrp = grpNull;
_type = "";

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"house"] call EFUNC(main,findPosTerrain);
	if !(_position isEqualTo []) then {
		_position = _position select 1;
	};
};

// find return location
if !(EGVAR(main,locations) isEqualTo []) then {
    _town = selectRandom (EGVAR(main,locations) select {
        !(_position inArea [_x select 1, _x select 2,  _x select 2, 0, false, -1])
    });
};

if (_position isEqualTo [] || {_town isEqualTo []}) exitWith {
	TASK_EXIT_DELAY(0);
};

if !(EGVAR(main,vipPoolCiv) isEqualTo []) then {
    _type = selectRandom EGVAR(main,vipPoolCiv);
} else {
    _type = "C_Nikos_aged";
};

_vip = (createGroup civilian) createUnit [_type, [0,0,0], [], 0, "NONE"];
_vip setDir random 360;
_vip setPosASL _position;
_vip disableAI "TARGET";
_vip disableAI "AUTOTARGET";
_vip disableAI "FSM";
_vip disableAI "SUPPRESSION";
_vip disableAI "COVER";
_vip disableAI "AUTOCOMBAT";
_cleanup pushBack _vip;
SET_CAPTIVE(_vip);

if !(CHECK_ADDON_1("ace_captives")) then {
    [_vip,{
        if (hasInterface) then {
            _this addAction [SECURE_NAME,{SECURE_STATEMENT},nil,0,false,true,"",QUOTE(SECURE_COND)];
        };
    }] remoteExecCall [QUOTE(BIS_fnc_call),0,_vip];
};

_grp = [[_position,5,30,5] call EFUNC(main,findPosSafe),0,_strength,EGVAR(main,enemySide),TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 1)},
	{
        params ["_grp","_strength","_cleanup"];

        _cleanup append (units _grp);

        // regroup garrison units
        [
            _grp,
            TASK_GARRISONCOUNT,
            {[_this select 0,_this select 0,50,1,false] call CBA_fnc_taskDefend},
            [],
            (count units _grp) - TASK_GARRISONCOUNT
        ] call EFUNC(main,splitGroup);

        // regroup patrols
        [
            _grp,
            TASK_PATROL_UNITCOUNT,
            {[_this select 0, _this select 0, 100, 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [0,5,8]] call CBA_fnc_taskPatrol},
            [],
            0,
            0.1
        ] call EFUNC(main,splitGroup);
	},
	[_grp,_strength,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

_vehPos = [_position,50,100,8,0] call EFUNC(main,findPosSafe);

if !(_vehPos isEqualTo _position) then {
	_vehGrp = [_vehPos,1,1,EGVAR(main,enemySide),TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);
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
_taskDescription = format ["We have intel that a local VIP has been taken hostage by %3 forces. Locate %1 and safely escort him to %2.", name _vip, _town select 0, [EGVAR(main,enemySide)] call BIS_fnc_sideName];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,0,true,"meet"] call BIS_fnc_taskCreate;

// PUBLISH TASK
TASK_PUBLISH(_position);
TASK_DEBUG(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_vip","_town","_cleanup","_position"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call BIS_fnc_taskSetState;
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if !(alive _vip) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call BIS_fnc_taskSetState;
		TASK_APPROVAL((getPos _vip),TASK_AV * -1);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT;
	};

    // if vip moves from position, consider him secured
    if !(CHECK_DIST2D(_vip,_position,5)) then {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        [_taskID,_town select 1] call BIS_fnc_taskSetDestination;

        [{
        	params ["_args","_idPFH"];
        	_args params ["_taskID","_vip","_town","_cleanup"];

            if (TASK_GVAR isEqualTo []) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                [_taskID, "CANCELED"] call BIS_fnc_taskSetState;
                _cleanup call EFUNC(main,cleanup);
                TASK_EXIT_DELAY(30);
            };

            if !(alive _vip) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                [_taskID, "FAILED"] call BIS_fnc_taskSetState;
                TASK_APPROVAL((getPos _vip),TASK_AV * -1);
                _cleanup call EFUNC(main,cleanup);
                TASK_EXIT;
            };

            _success = false;

            // if vip is returned to town and is alive/awake
            if (_vip inArea [_town select 1, TASK_DIST_RET, TASK_DIST_RET, 0, false, 10]) then {
                if (CHECK_ADDON_1("ace_medical")) then {
                    _success = [_vip] call ace_common_fnc_isAwake;
                } else {
                    _success = alive _vip;
                };
            };

            if (_success) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                [_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
                TASK_APPROVAL((getPos _vip),TASK_AV);
                _cleanup call EFUNC(main,cleanup);
                TASK_EXIT;
            };
        }, TASK_SLEEP, [_taskID,_vip,_town,_cleanup]] call CBA_fnc_addPerFrameHandler;
    };
}, TASK_SLEEP, [_taskID,_vip,_town,_cleanup,_position]] call CBA_fnc_addPerFrameHandler;
