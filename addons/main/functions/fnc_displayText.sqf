/*
Author:
Nicholas Clark (SENSEI)

Description:
display message

Arguments:
0: message to display <STRING>
1: hint sound <BOOL>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_msg","",[""]],
    ["_sound",true]
];

if (CHECK_ADDON_1(ace_common)) then {
    [_msg, _sound, 8, 0] call ace_common_fnc_displayText;
} else {
    [hintSilent _msg, hint _msg] select _sound;
};

nil