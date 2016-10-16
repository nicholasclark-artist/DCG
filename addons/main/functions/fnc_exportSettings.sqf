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

private ["_config","_export","_entry","_typeName","_value","_format","_br","_tab","_compiledEntry"];

if (!isServer) exitWith {};

_config = configFile >> QUOTE(DOUBLES(PREFIX,settings));
_export = "";

for "_i" from 0 to count _config - 1 do {
	_entry = _config select _i;
	_name = configName _entry;
	_typeName = toUpper getText (_entry >> "typeName");
	_value = 0;
	_format = "class %3 {%1%2typeName = %4;%1%2value = %5;%1};%1";
	_br = toString [13,10]; // line break
	_tab = toString [9]; // tab

	call {
		if (COMPARE_STR(_typeName,"array") || {COMPARE_STR(_typeName,"pool")} || {COMPARE_STR(_typeName,"world")}) exitWith {
			_value = getArray (_entry >> "value");
		};

		if (COMPARE_STR(_typeName,"string")) exitWith {
			_value = str (getText (_entry >> "value"));
		};

		if (COMPARE_STR(_typeName,"scalar")) exitWith {
			_value = getText (_entry >> "value"); // try getText first so unevaluated code can be used
			if (_value isEqualTo "") then {
				_value = getNumber (_entry >> "value");
			};
		};

		if (COMPARE_STR(_typeName,"bool")) exitWith {
			_value = getNumber (_entry >> "value");
		};
	};

	if (COMPARE_STR(_typeName,"array") || {COMPARE_STR(_typeName,"pool")} || {COMPARE_STR(_typeName,"world")}) then {
		private _tempValue1 = "";
		{
			private _tempValue2 = str _x;
			// if value includes nested array, fix brackets
			if (_x isEqualType []) then {
				_tempValue2 = [_tempValue2,"[",format ["{",_br,_tab]] call FUNC(replaceString);
				_tempValue2 = [_tempValue2,"]",format ["}",_br,_tab]] call FUNC(replaceString);
			};
			// format array elements
			if !(_forEachIndex isEqualTo (count _value - 1)) then {
				_tempValue1 = _tempValue1 + format ["%1%2%2%3,",_br,_tab,_tempValue2];
			} else {
				_tempValue1 = _tempValue1 + format ["%1%2%2%3",_br,_tab,_tempValue2];
			};
		} forEach _value;

		_value = _tempValue1;
		_format = "class %3 {%1%2typeName = %4;%1%2value[] = {%5%1%2};%1};%1";
	};

	_compiledEntry = format [_format,_br,_tab,_name,str _typeName,_value];
    _export = _export + _compiledEntry;
};

copyToClipboard _export;