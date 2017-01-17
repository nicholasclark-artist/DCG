/*
Author:
Nicholas Clark (SENSEI)

Description:
add armory to object

Arguments:
0: armory object <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define PACK QUOTE(ACRE_PRC117F)
#define STATE_PACK \
  if (player canAddItemToBackpack PACK) then { \
    player addItemToBackpack PACK; \
  } else { \
    [format ["Cannot add %1 to your inventory.", [configFile >> "cfgWeapons" >> PACK] call BIS_fnc_displayName], true] call EFUNC(main,displayText); \
  };
#define STATE_RADIO call EFUNC(radio,setRadio);
#define STATE_ARMORY ["Open",true] spawn bis_fnc_arsenal;

params [
    ["_obj",objNull,[objNull]]
];

if (isNull _obj) exitWith {
    WARNING("Object does not exist");
};

[[QUOTE(PREFIX),_obj,"armory"] joinString "_","Open Armory",{STATE_ARMORY},QUOTE(true),{},[],_obj,0,["ACE_MainActions"]] call FUNC(setAction);

if (CHECK_ADDON_1("acre_main") || {CHECK_ADDON_1("task_force_radio")}) then {
  [[QUOTE(PREFIX),_obj,"armoryRadio"] joinString "_","Take Radio",{STATE_RADIO},QUOTE(true),{},[],_obj,0,["ACE_MainActions"]] call FUNC(setAction);
};

if (CHECK_ADDON_1("acre_main")) then {
	[[QUOTE(PREFIX),_obj,"armoryPack"] joinString "_","Take Pack Radio",{STATE_PACK},QUOTE(true),{},[],_obj,0,["ACE_MainActions"]] call FUNC(setAction);
};
