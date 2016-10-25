/*
Author:
Nicholas Clark (SENSEI)

Description:
check loadouts

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define LOADOUT_DATA (profileNamespace getVariable ["bis_fnc_saveInventory_data",[]])

if !(hasInterface) exitWith {};

// arsenal workaround, remove items from communications tab
_data = missionnamespace getVariable "bis_fnc_arsenal_data";
_data set [12,[]];
missionnamespace setVariable ["bis_fnc_arsenal_data",_data];

if (CHECK_ADDON_1("acre_main")) then {
  [
  	{!(LOADOUT_DATA isEqualTo [])},
  	{
  		LOG("Searching loadouts for ACRE items.");

  		for "_i" from 0 to ((count LOADOUT_DATA) - 1) do {
  			if (typeName (LOADOUT_DATA select _i) == "ARRAY") then {
  				_loadout = (LOADOUT_DATA select _i);
  				_uniformItems = ((_loadout select 0) select 1);
  				_vestItems = ((_loadout select 1) select 1);
  				_backpackItems = ((_loadout select 2) select 1);
  				{
  					if ((_x select [0,5]) == "ACRE_") then {_uniformItems set [_forEachindex,"Chemlight_green"]};
  				} forEach _uniformItems;
  				{
  					if ((_x select [0,5]) == "ACRE_") then {_vestItems set [_forEachindex,"Chemlight_green"]};
  				} forEach _vestItems;
  				{
  					if ((_x select [0,5]) == "ACRE_") then {_backpackItems set [_forEachindex,"Chemlight_green"]};
  				} forEach _backpackItems;
  			};
  		};
  	}
  ] call CBA_fnc_waitUntilAndExecute;
};
