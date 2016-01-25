/*
Author: Nicholas Clark (SENSEI)

Description:
assigns TFAR radio and channels

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define CH_CMD 1
#define CH_SUP 2

_access = [];
_tfr_ch = -1;
_role = toLower (str player);

for "_i" from 0 to (count GVAR(squadNet) min 10) - 1 do { // TODO allow more squad nets
	_squad = GVAR(squadNet) select _i;
	if (_role in _squad) exitWith {
		_tfr_ch = _i + 3;
	};
};

{player unlinkItem _x} forEach (player call TFAR_fnc_radiosList);

if (_role in GVAR(commandNet)) then {
	if (GVAR(tfar_command) isKindOf "Bag_Base") then {
		_bItems = backpackItems player;
		removeBackpack player;
		sleep 0.1;
		player addbackpack GVAR(tfar_command);
		{player addItemToBackpack _x} forEach _bItems;
		waitUntil {TFAR_fnc_haveLRRadio};
		[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, CH_CMD] call TFAR_fnc_setLrChannel;
	} else {
		player addItem GVAR(tfar_command);
		waitUntil {TFAR_fnc_haveSWRadio};
		[call TFAR_fnc_activeSwRadio, _tfr_ch] call TFAR_fnc_setSwChannel;
		[call TFAR_fnc_activeSwRadio, CH_CMD] call TFAR_fnc_setAdditionalSwChannel;
	};
};
if (_role in GVAR(supportNet)) then {
	if (GVAR(tfar_support) isKindOf "Bag_Base") then {
		_bItems = backpackItems player;
		removeBackpack player;
		sleep 0.1;
		player addbackpack GVAR(tfar_support);
		{player addItemToBackpack _x} forEach _bItems;
		waitUntil {TFAR_fnc_haveLRRadio};
		[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, CH_SUP] call TFAR_fnc_setLrChannel;
	} else {
		player addItem GVAR(tfar_support);
		waitUntil {TFAR_fnc_haveSWRadio};
		[call TFAR_fnc_activeSwRadio, _tfr_ch] call TFAR_fnc_setSwChannel;
		[call TFAR_fnc_activeSwRadio, CH_SUP] call TFAR_fnc_setAdditionalSwChannel;
	};
};
{
	if (_role in _x) exitWith {
		if (GVAR(tfar_squad) isKindOf "Bag_Base") then {
			_bItems = backpackItems player;
			removeBackpack player;
			sleep 0.1;
			player addbackpack GVAR(tfar_squad);
			{player addItemToBackpack _x} forEach _bItems;
			waitUntil {TFAR_fnc_haveLRRadio};
			[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, _tfr_ch] call TFAR_fnc_setLrChannel;
		} else {
			player addItem GVAR(tfar_squad);
			waitUntil {TFAR_fnc_haveSWRadio};
			[call TFAR_fnc_activeSwRadio, _tfr_ch] call TFAR_fnc_setSwChannel;
		};
	};
} forEach GVAR(squadNet);

if (backpack player isEqualTo GVAR(tfar_command) || {GVAR(tfar_command) isEqualTo (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getRadioOwner}) then {
	_access pushBack (text "COMMAND");
};
if (backpack player isEqualTo GVAR(tfar_support) || {GVAR(tfar_support) isEqualTo (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getRadioOwner}) then {
	_access pushBack (text "SUPPORT");
};
if (backpack player isEqualTo GVAR(tfar_squad) || {GVAR(tfar_squad) isEqualTo (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getRadioOwner}) then {
	_access pushBack (text "SQUAD");
};

[format ["Comm net access:\n%1",_access],true] call EFUNC(main,displayText);