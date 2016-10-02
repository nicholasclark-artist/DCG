/*
Author:
Nicholas Clark (SENSEI)

Description:
init order not guaranteed
__________________________________________________________________*/
[
	{!isNil "dcg_main" && {dcg_main}},
	{
		["Initialize"] call BIS_fnc_dynamicGroups;
		createCenter dcg_main_enemySide;
		dcg_main_enemySide setFriend [CIVILIAN, 1];
		dcg_main_playerSide setFriend [CIVILIAN, 1];
	},
	[]
] call CBA_fnc_waitUntilAndExecute;
