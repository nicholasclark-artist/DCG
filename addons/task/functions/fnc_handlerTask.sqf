/*
Author: Nicholas Clark (SENSEI)

Description:
starts task generation

Arguments:

Return:
none
__________________________________________________________________*/
if !(isServer) exitWith {};

DCG_taskSuccess = 0;
DCG_taskCounterCiv = 0;

DCG_taskList = [
	"defend",
	"defuse",
	"vip",
	"cache",
	"arty",
	"repair",
	"steal"
];

DCG_taskListCiv = [
	"rescue",
	"deliver",
	"stabilize",
	"identify"
];

[{
	if (DCG_complete >= 1 && {time > 60}) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;
		["Players present at task handler start: %1",call DCG_fnc_getPlayers] call DCG_fnc_log;
		call DCG_fnc_taskOfficer;
		[DCG_taskListCiv select floor (random (count DCG_taskListCiv))] call DCG_fnc_setTaskCiv;
		[{
			params ["_args","_idPFH"];
			_args params ["_time"];

			if (diag_tickTime >= _time) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				["rebel"] call DCG_fnc_setTaskCiv;
			};
		}, 1, [diag_tickTime + 1200]] call CBA_fnc_addPerFrameHandler;
	};
}, 5, []] call CBA_fnc_addPerFrameHandler;