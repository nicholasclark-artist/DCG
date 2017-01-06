/*
Author:
Nicholas Clark (SENSEI)

Description:
secondary task - find intel 01

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_SECONDARY
#define TASK_NAME 'Find GPS Intel'
#define INTEL_CLASS QUOTE(ItemGPS)
#define INTEL_CONTAINER GVAR(DOUBLES(intel01,container))
#define MOUND_PATH "a3\structures_f\walls\mound02_8m_f.p3d"
#define UNITCOUNT 6
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;

if (_position isEqualTo [] && {!(EGVAR(main,locals) isEqualTo [])}) then {
	_position = (selectRandom EGVAR(main,locals)) select 1;

    if !([_position,5,0] call EFUNC(main,isPosSafe)) then {
        _startPos = _position;
        _position = [_startPos,0,50,5,0] call EFUNC(main,findPosSafe);

        if (_position isEqualTo _startPos) then {
            _position = [];
        };
    };
};

if (_position isEqualTo []) exitWith {
	TASK_EXIT_DELAY(0);
};

_grp = [_position,0,UNITCOUNT,CIVILIAN,true,0.5] call EFUNC(main,spawnGroup);

[
	{count units (_this select 1) >= UNITCOUNT},
	{
		params ["_position","_grp"];

        _units = units _grp;
		removeFromRemainsCollector _units;

		{
			removeAllItems _x;
			removeAllAssignedItems _x;
            _x setDir random 360;
			_x setDamage 1;
		} forEach _units;

        INTEL_CONTAINER = [leader _grp,INTEL_CLASS] call FUNC(addItem);

        _unit = selectRandom _units;
        _unit setDir 0;

        for "_dir" from 0 to 360 step 90 do {
            if (_dir > 270) exitWith {};

            _relPos = _unit getRelPos [5.5, _dir];
            _relPos set [2,getTerrainHeightASL _relPos];

            _mound = createSimpleObject [MOUND_PATH, [0,0,0]];
            _mound setDir _dir;
            _mound setPosASL _relPos;
            _mound setVectorUp surfaceNormal getPos _mound;
        };
	},
	[_position,_grp]
] call CBA_fnc_waitUntilAndExecute;

TASK_DEBUG(_position);

// SET TASK
_taskPos = ASLToAGL ([_position,120,150] call EFUNC(main,findPosSafe));
_taskDescription = "A few days ago an informant didn't show for a meeting. He was suppose to hand off a GPS device with vital intel on the enemy's whereabouts. Today, UAV reconnaissance spotted activity nearby. Search the area for the informant and retrieve the GPS.";
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"search"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_grp"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		(units _grp) call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if (!isNull INTEL_CONTAINER && {{COMPARE_STR(INTEL_CLASS,_x)} count itemCargo INTEL_CONTAINER < 1}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(getPos (leader _grp),TASK_AV);

		if (random 1 < 0.5) then {
			_posArray = [getpos (leader _grp),50,250,175] call EFUNC(main,findPosGrid);
			{
				if !([_x,100] call EFUNC(main,getNearPlayers) isEqualTo []) then {
					_posArray deleteAt _forEachIndex;
				};
			} forEach _posArray;

			if !(_posArray isEqualTo []) then {
				_grp = [selectRandom _posArray,0,TASK_STRENGTH,EGVAR(main,enemySide)] call EFUNC(main,spawnGroup);
				_wp = _grp addWaypoint [getposATL (leader _grp),0];
                _wp setWaypointType "SAD";
				_cond = "!(behaviour this isEqualTo ""COMBAT"")";
				_wp setWaypointStatements [_cond, format ["thisList call %1;",QEFUNC(main,cleanup)]];
			};
		} else {
			[getpos (leader _grp),EGVAR(main,enemySide)] spawn EFUNC(main,spawnReinforcements);
		};

        (units _grp) call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_grp]] call CBA_fnc_addPerFrameHandler;
