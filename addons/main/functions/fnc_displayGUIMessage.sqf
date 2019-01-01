/*
Author:
Nicholas Clark (SENSEI)

Description:
display GUI message, function must be spawned

Arguments:
0: message to display <STRING>
1: message title <STRING>
2: message to display if "Yes" is selected <STRING>
3: code to run if "Yes" is selected <CODE>
4: arguments to pass to code <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_msg",""],
    ["_title",TITLE,[""]],
    ["_confirm","",[""]],
    ["_code",{},[{}]],
    ["_args",[],[[]]]
];

closeDialog 0;

_ret = [
    parseText (format ["<t align='center'>%1</t>",_msg]),
    _title,
    "Yes",
    "No"
] call bis_fnc_GUImessage;

if (_ret) then {
    _args call _code;
    [_confirm,true] call EFUNC(main,displayText);
};

nil