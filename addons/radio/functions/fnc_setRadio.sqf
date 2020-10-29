/*
Author:
Nicholas Clark (SENSEI)

Description:
adds radios to player inventory

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if !(hasInterface) exitWith {};

if (CHECK_ADDON_1(acre_main)) exitWith {
    call FUNC(setRadioACRE);
};

if (CHECK_ADDON_1(task_force_radio)) exitWith {
    call FUNC(setRadioTFAR);
};

[[COMPONENT_NAME,CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],["Cannot issue radio. You do not have ACRE2 or TFAR enabled.",CBAN_BODY_SIZE,CBAN_BODY_COLOR],true] call EFUNC(main,notify);