/*
Author: Nicholas Clark (SENSEI)

Last modified: 9/28/2015

Description: formats time

Return: string
__________________________________________________________________*/
private ["_hour","_min","_sec","_ret"];
params ["_time",["_showHour",false]];

_hour = str(floor(_time / 3600));
_min = str(floor((_time - (floor(_time / 3600) * 3600)) / 60));
_sec = str(_time - (floor(_time / 3600) * 3600) - (floor((_time - (floor(_time / 3600) * 3600)) / 60) * 60));

if (count _hour isEqualTo 1) then {
	_hour = "0" + _hour;
};
if (count _min isEqualTo 1) then {
	_min = "0" + _min;
};
if (count _sec isEqualTo 1) then {
	_sec = _sec + "0";
};

if !(_showHour) then {
	_ret = format ["%1:%2",_min,_sec];
} else {
	_ret = format ["%1:%2:%3",_hour,_min,_sec];
};

_ret