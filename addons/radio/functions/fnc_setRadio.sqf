/*
Author:
Nicholas Clark (SENSEI)

Description:
adds radios to player inventory

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if !(hasInterface) exitWith {};

if (CHECK_ADDON_1(acre_main)) exitWith {
    call FUNC(setRadioACRE);
};

if (CHECK_ADDON_1(task_force_radio)) exitWith {
    call FUNC(setRadioTFAR);
};

["Cannot issue radio. You do not have ACRE2 or TFAR enabled.",true] call EFUNC(main,displayText);