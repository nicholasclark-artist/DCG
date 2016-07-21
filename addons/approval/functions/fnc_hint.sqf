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

private ["_player","_fobBonus","_region","_value","_locations","_format"];

_player = _this select 0;

_fobBonus = 0;
_region = "";
_value = [getpos _player] call FUNC(getValue);
_locations = [getpos _player] call FUNC(getRegion);

_locations = _locations apply {_x select 0};

{
	if (_forEachIndex isEqualTo (count _locations - 1)) then {
		_region = _region + _x;
	} else {
		_region = _region + _x + ", ";
	};
} forEach _locations;

if (CHECK_ADDON_2(fob)) then {
	 _fobBonus = EGVAR(fob,AVBonus);
};

_format = format ["
Regional Breakdown \n \n
Approval: %3/%4 \n
Hostility: %5/100 \n
FOB Bonus: %6 \n
Region: %2
",_player,_region,round _value,AV_MAX,round((AV_CHANCE(getPos _player))*100),_fobBonus];

[_format,true] remoteExecCall [QEFUNC(main,displayText),_player,false];
