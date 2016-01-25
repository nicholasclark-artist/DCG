/*
Author:
Nicholas Clark (SENSEI)

Description:
export settings

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_config","_export","_entry","_typeName","_typeDetail","_value","_br","_compiledEntry"];

if (!isServer) exitWith {};

_config = configFile >> QUOTE(DOUBLES(PREFIX,settings));
_export = "";

for "_i" from 0 to count _config - 1 do {
	_entry = _config select _i;
	_name = configName _entry;
	_typeName = getText (_entry >> "typeName");
	_typeDetail = getText (_entry >> "typeDetail");
	_value = 00;

	call {
		if (toUpper _typeName isEqualTo "ARRAY") exitWith {
			_value = getArray (_entry >> "value");
		};
		if (toUpper _typeName isEqualTo "STRING") exitWith {
			_value = str (getText (_entry >> "value"));
		};
		if (toUpper _typeName isEqualTo "SCALAR") exitWith {
			_value = getNumber (_entry >> "value");
		};
		if (toUpper _typeName isEqualTo "BOOL") exitWith {
			_value = getNumber (_entry >> "value");
		};
	};

	_br = toString [13,10];
	_compiledEntry = format ["
		class %2 {
		    typeName = %3;
		    typeDetail = %4;
		    value = %5;
		};%1",_br,_name,str _typeName,str _typeDetail,_value];

	if (toUpper _typeName isEqualTo "ARRAY") then {
		_compiledEntry = [_compiledEntry,"value = [[",format ["value[] = {%1[",_br]] call FUNC(replaceString);
		_compiledEntry = [_compiledEntry,"]];",format ["]%1};",_br]] call FUNC(replaceString);
	};

    _export = _export + _compiledEntry;
};

copyToClipboard _export;