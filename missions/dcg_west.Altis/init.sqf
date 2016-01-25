/*
Author:
Nicholas Clark (SENSEI)

Description:
mission included with Dynamic Combat Generator
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_ADDON_1("dcg_main")) exitWith {};

enableSaving [false, false];
enableSentences false;
enableRadio false;
["Preload"] call EFUNC(main,arsenal);