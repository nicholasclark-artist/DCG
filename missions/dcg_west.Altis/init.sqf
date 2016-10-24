/*
Author:
Nicholas Clark (SENSEI)

Description:
mission template included with Dynamic Combat Generator
__________________________________________________________________*/
// dcg_main_enemySide is defined in mission parameters in this template
dcg_main_playerSide = WEST;

// disable vanilla saving and unit callouts
enableSaving [false, false];
enableSentences false;
enableRadio false;

// preload arsenal after main addon is loaded
[
	{!isNil "dcg_main" && {dcg_main}},
	{
		["Preload"] call dcg_main_fnc_arsenal;
	},
	[]
] call CBA_fnc_waitUntilAndExecute;
