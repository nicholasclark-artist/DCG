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

[
    [COMPONENT_NAME,CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],
    [MSG,CBAN_BODY_SIZE,CBAN_BODY_COLOR],
    false
] call FUNC(notify);

WARNING_1(MSG_RPT,_name);

nil