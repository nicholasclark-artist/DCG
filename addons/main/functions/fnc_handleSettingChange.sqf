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
#define MSG "You've changed a setting that requires a mission restart to take effect."
#define MSG_RPT "Setting (%1) changed during session. Mission restart required."

params ["_name"];

if (!isMultiplayer || {CBA_missionTime < 5} ||{!(toLower _name in CBA_settings_needRestart)}) exitWith {};

[format [MSG,_name]] call FUNC(displayText);
WARNING_1(MSG_RPT,_name);

nil