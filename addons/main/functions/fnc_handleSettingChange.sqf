/*
Author:
Nicholas Clark (SENSEI)

Description:
handle cba setting change

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define MSG "Setting (%1) changed during mission. Mission restart required."

params ["_name","_value"];

// [QGVARMAIN(settingChange), [_name, _value]] call CBA_fnc_localEvent;

if (!GVAR(settingsInitFinished) || {!isMultiplayer}) exitWith {};

// @todo add all changed settings to an array and send one msg, so warnings are not overwritten
WARNING_1(MSG,_name);
[format [MSG,_name]] call FUNC(displayText);
