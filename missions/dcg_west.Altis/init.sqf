/*
Author:
Nicholas Clark (SENSEI)

Description:
mission included with Dynamic Combat Generator
__________________________________________________________________*/
dcg_main_playerSide = EAST; // define var, can be changed via mission params

enableSaving [false, false];
enableSentences false;
enableRadio false;

[
	{!isNil "dcg_main" && {dcg_main}},
	{
		["Preload"] call dcg_main_fnc_arsenal;
	},
	[]
] call CBA_fnc_waitUntilAndExecute;
