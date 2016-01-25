/*
Author: Nicholas Clark (SENSEI)

Start date: May 2014

Last modified: 10/21/2015

Description: Dynamic Combat Generator

To Do:
	add version check
	add steam workshop version
	add fob specific tasks
	add water tasks
	rework sniper encounters (too rare)
	create fail state for defend task
	rework setSurrender (veh units dont surrender)
	try BIS_fnc_isBuildingEnterable and buildingExit
	fix paths to defuse script

Known Issues:
	ACE_server.pbo overwrites ACE variables set by DCG. Recommend not to use ACE_server.pbo
	ACE interaction menu may not initialize at mission start, ACE3 Github issue #1171
	killing rebels hurts approval
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_ADDON_1("dcg_main")) exitWith {};

enableSaving [false, false];
enableSentences false;
enableRadio false;
["Preload"] call EFUNC(main,arsenal);