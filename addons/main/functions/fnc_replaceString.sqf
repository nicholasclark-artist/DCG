/*
Author:
dreadedentity

Description:
find and replace within string

Arguments:

Return:
string
__________________________________________________________________*/
private ["_input","_replace","_replaceWith","_output","_location","_front","_end"];

_input = _this select 0;
_replace = _this select 1;
_replaceWith = _this select 2;

_output = "";
_location = _input find _replace;

if (_location > -1) then {
    _front = _input select [0, _location];
    _end = _input select [_location + (count _replace)];
    _output = format ["%1%2%3", _front, _replaceWith, _end];
};

_output;