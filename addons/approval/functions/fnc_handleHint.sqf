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

private _player = _this select 0;
private _fobBonus = 0;
private _value = [getpos _player] call FUNC(getValue);
private _locations = [getpos _player] call FUNC(getRegion);

_locations = _locations apply {_x select 0};
_locations = _locations joinString ", ";

private _format = format ["
Regional Breakdown \n \n
Approval: %3/%4 \n
Hostility: %5%6 \n
Region: %2
",_player,_locations,round _value,AV_MAX,round((AV_CHANCE(getPos _player))*100),"%"];

[_format,true] remoteExecCall [QEFUNC(main,displayText),_player,false];
