/*
Author:
Nicholas Clark (SENSEI)

Description:
check loadout for acre radio

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if !(hasInterface) exitWith {};

_loadoutList = profileNamespace getVariable ["bis_fnc_saveInventory_data",[]];
for "_i" from 0 to ((count _loadoutList) - 1) do {
	if (typeName (_loadoutList select _i) isEqualTo "ARRAY") then {
		_loadout = (_loadoutList select _i);
		_uniformItems = ((_loadout select 0) select 1);
		_vestItems = ((_loadout select 1) select 1);
		_backpackItems = ((_loadout select 2) select 1);
		{
			if ((_x select [0,5]) isEqualTo "ACRE_") then {_uniformItems set [_forEachindex,"Chemlight_green"]};
		} forEach _uniformItems;
		{
			if ((_x select [0,5]) isEqualTo "ACRE_") then {_vestItems set [_forEachindex,"Chemlight_green"]};
		} forEach _vestItems;
		{
			if ((_x select [0,5]) isEqualTo "ACRE_") then {_backpackItems set [_forEachindex,"Chemlight_green"]};
		} forEach _backpackItems;
	};
};