/*
Author: Nicholas Clark (SENSEI)

Start date: May 2014

Description:
mission intended to use alongside Dynamic Combat Generator

To Do:
	add steam workshop version
	add fob specific tasks
	add water tasks
	create fail state for defend task
	fix paths to defuse script

Known Issues:
	ACE interaction menu may not initialize at mission start, ACE3 Github issue #1171
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_ADDON_1("dcg_main")) exitWith {};

enableSaving [false, false];
enableSentences false;
enableRadio false;
["Preload"] call EFUNC(main,arsenal);