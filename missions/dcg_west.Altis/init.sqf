/*
Author:
Nicholas Clark (SENSEI)

Description:
mission included with Dynamic Combat Generator
__________________________________________________________________*/
// dcg_main_enemySide is set via mission params
dcg_main_playerSide = WEST;

enableSaving [false, false];
enableSentences false;
enableRadio false;

waitUntil {!isNil "dcg_main" && {dcg_main}}; // wait until main addon completes postInit

["Preload"] call dcg_main_fnc_arsenal;