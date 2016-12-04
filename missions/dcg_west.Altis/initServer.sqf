/*
Author:
Nicholas Clark (SENSEI)

Description:
init order not guaranteed
__________________________________________________________________*/
["Initialize"] call BIS_fnc_dynamicGroups;
createCenter dcg_main_enemySide;
dcg_main_enemySide setFriend [CIVILIAN, 1];
dcg_main_playerSide setFriend [CIVILIAN, 1];
