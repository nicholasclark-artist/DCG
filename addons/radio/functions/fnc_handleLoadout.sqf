/*
Author:
Nicholas Clark (SENSEI), Larrow, Kingsley1997

Description:
handle arsenal loadouts

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define LOADOUT_VAR "bis_fnc_saveInventory_data"
#define LOADOUT_DATA (profileNamespace getVariable [LOADOUT_VAR,[]])

if !(hasInterface) exitWith {};

if (CHECK_ADDON_1("acre_main")) then {
    // ACRE workaround, disable random button to prevent inventory desync
    [
        missionNamespace,
        "arsenalOpened",
        {
            disableSerialization;
            _display = _this select 0;
            (_display displayCtrl 44150) ctrlRemoveAllEventHandlers "buttonclick";
            (_display displayCtrl 44150) ctrlEnable false;
            _display displayAddEventHandler ["KeyDown", "if ((_this select 1) in [19,29]) then {true}"];
        }
    ] call BIS_fnc_addScriptedEventHandler;

    // remove ACRE items from loadouts to prevent radio ID issues
    // loadouts saved during the mission are not checked
    [
    	{!(LOADOUT_DATA isEqualTo [])},
    	{
    		INFO("Searching loadouts for ACRE items");

    		for "_i" from 0 to ((count LOADOUT_DATA) - 1) do {
    			if (typeName (LOADOUT_DATA select _i) == "ARRAY") then {
    				_loadout = (LOADOUT_DATA select _i);
    				_uniformItems = ((_loadout select 0) select 1);
    				_vestItems = ((_loadout select 1) select 1);
    				_backpackItems = ((_loadout select 2) select 1);
    				{
    					if ((_x select [0,5]) == "ACRE_") then {
                        _uniformItems set [_forEachindex,"Chemlight_green"];
                        INFO("Removed ACRE item from uniform");
                    };
    				} forEach _uniformItems;
    				{
    					if ((_x select [0,5]) == "ACRE_") then {
                        _vestItems set [_forEachindex,"Chemlight_green"];
                        INFO("Removed ACRE item from vest");
                    };
    				} forEach _vestItems;
    				{
    					if ((_x select [0,5]) == "ACRE_") then {
                        _backpackItems set [_forEachindex,"Chemlight_green"];
                        INFO("Removed ACRE item from backpack");
                    };
    				} forEach _backpackItems;
    			};
    		};
    	}
    ] call CBA_fnc_waitUntilAndExecute;
};
