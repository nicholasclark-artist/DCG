/*
Author: SENSEI

Last modified: 12/12/2015

Description: assigns acre radio and channels

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define KITBAG "B_Kitbag_cbr"
#define NOBACKPACK (backpack player) isEqualTo ""
#define NAME_CMD getText (configFile >> "cfgWeapons" >> GVAR(acre_command) >> "displayName")
#define NAME_SUP getText (configFile >> "cfgWeapons" >> GVAR(acre_support) >> "displayName")
#define NAME_SQ getText (configFile >> "cfgWeapons" >> GVAR(acre_squad) >> "displayName")

private ["_radioInInv","_access"];

_radioInInv = [];
_access = [];
_role = toLower (str player);

{player removeItem _x} forEach (call acre_api_fnc_getCurrentRadioList);

if (_role in GVAR(commandNet)) then {
	if (player canAdd GVAR(acre_command)) then {
		player addItem GVAR(acre_command);
	} else {
		if (NOBACKPACK) then {
			player addBackpack KITBAG;
			player addItemToBackpack GVAR(acre_command);
		};
	};
};
if (_role in GVAR(supportNet)) then {
	if (player canAdd GVAR(acre_support)) then {
		player addItem GVAR(acre_support);
	} else {
		if (NOBACKPACK) then {
			player addBackpack KITBAG;
			player addItemToBackpack GVAR(acre_support);
		};
	};
};

{
	if (_role in _x) exitWith {
		if (player canAdd GVAR(acre_squad)) then {
			player addItem GVAR(acre_squad);
		} else {
			if (NOBACKPACK) then {
				player addBackpack KITBAG;
				player addItemToBackpack GVAR(acre_squad);
			};
		};
	};
} forEach GVAR(squadNet);

waitUntil {[] call acre_api_fnc_isInitialized};

{_radioInInv pushBack ([_x] call acre_api_fnc_getBaseRadio)} forEach ([] call acre_api_fnc_getCurrentRadioList);

if (_radioInInv isEqualTo []) exitWith {
	["Cannot add ACRE2 radios to inventory\nComm net access: NONE",true] call EFUNC(main,displayText);
};

if (GVAR(acre_command) in _radioInInv) then {_access pushBack (text "COMMAND")};
if (GVAR(acre_support) in _radioInInv) then {_access pushBack (text "SUPPORT")};
if (GVAR(acre_squad) in _radioInInv) then {_access pushBack (text "SQUAD")};

[format ["Comm net access:\n%1",_access],true] call EFUNC(main,displayText);

// set channels
if (GVAR(acre_command) in _radioInInv) then {
	[([GVAR(acre_command)] call acre_api_fnc_getRadioByType), 1] call acre_api_fnc_setRadioChannel;
};
if (GVAR(acre_support) in _radioInInv) then {
	[([GVAR(acre_support)] call acre_api_fnc_getRadioByType), 2] call acre_api_fnc_setRadioChannel;
};
if (GVAR(acre_squad) in _radioInInv) then {
	for "_i" from 0 to (count GVAR(squadNet) min 10) - 1 do { // TODO allow more squad nets
		_squad = GVAR(squadNet) select _i;
		if (toLower str player in _squad) exitWith {
			[([GVAR(acre_squad)] call acre_api_fnc_getRadioByType), _i + 3] call acre_api_fnc_setRadioChannel;
		};
	};
};