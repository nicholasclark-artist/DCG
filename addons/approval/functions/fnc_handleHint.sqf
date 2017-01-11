/*
Author:
Nicholas Clark (SENSEI)

Description:
send approval hint to client

Arguments:
0: player to send hint to <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_player",objNull,[objNull]]
];

private _value = round ([getpos _player] call FUNC(getValue));
private _safety = round ((AV_CHANCE(getPos _player))*100);

private _format = format ["
    %4 \n \n
    Region Approval: %1/%3 \n
    Region Safety: %2/%3 \n
",_value,_safety,AV_MAX,toUpper COMPONENT_NAME];

[_format,true] remoteExecCall [QEFUNC(main,displayText),_player,false];
