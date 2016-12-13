/*
Author:
Nicholas Clark (SENSEI)

Description:
init order not guaranteed
__________________________________________________________________*/
if (isClass (configfile >> "CfgPatches" >> "dcg_main")) then {
    createCenter dcg_main_enemySide;
    dcg_main_enemySide setFriend [CIVILIAN, 1];
    dcg_main_playerSide setFriend [CIVILIAN, 1];
};
