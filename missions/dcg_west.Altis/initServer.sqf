/*
Author:
Nicholas Clark (SENSEI)

Description:
init order not guaranteed
__________________________________________________________________*/
["Initialize", [true]] call BIS_fnc_dynamicGroups;

WEST setFriend [EAST, 0];
WEST setFriend [INDEPENDENT, 0];

EAST setFriend [WEST, 0];
EAST setFriend [INDEPENDENT, 0];

INDEPENDENT setFriend [WEST, 0];
INDEPENDENT setFriend [EAST, 0];

CIVILIAN setFriend [WEST, 1];
CIVILIAN setFriend [EAST, 1];
CIVILIAN setFriend [INDEPENDENT, 1];