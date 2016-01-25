/*
Author: Nicholas Clark (SENSEI)

Last modified: 6/25/2015

Description: adds radios to player inventory

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"

if !(hasInterface) exitWith {};

if (CHECK_ADDON_1("acre_main")) exitWith {
	[] spawn FUNC(setRadioACRE);
};

if (CHECK_ADDON_1("task_force_radio")) exitWith {
	[] spawn FUNC(setRadioTFAR);
};

["Cannot issue radio. You do not have ACRE2 or TFAR enabled.",true] call EFUNC(main,displayText);