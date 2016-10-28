/*
Author:
Nicholas Clark (SENSEI)

Description:
add armory to object

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define PACK QUOTE(QUOTE(ACRE_PRC117F))
#define STATE_PACK \
  if (player canAddItemToBackpack PACK) then { \
    player addItemToBackpack PACK; \
  } else { \
    [format [""Cannot add %1 to your inventory."", [configFile >> ""cfgWeapons"" >> PACK] call BIS_fnc_displayName], true] call EFUNC(main,displayText); \
  };
#define STATE_RADIO call EFUNC(radio,setRadio);
#define STATE_ARMORY \
	if (CHECK_ADDON_1('acre_main')) then { \
		{player removeItem _x} forEach (call acre_api_fnc_getCurrentRadioList); \
	}; \
	['Open',true] spawn FUNC(arsenal);

private _obj = _this select 0;

[[QUOTE(PREFIX),_obj,"armory"] joinString "_","Open Armory",QUOTE(STATE_ARMORY),QUOTE(true),"",_obj,0,["ACE_MainActions"]] call FUNC(setAction);

if (CHECK_ADDON_1("acre_main") || {CHECK_ADDON_1("task_force_radio")}) then {
  [[QUOTE(PREFIX),_obj,"armoryRadio"] joinString "_","Take Radio",QUOTE(STATE_RADIO),QUOTE(true),"",_obj,0,["ACE_MainActions"]] call FUNC(setAction);
};

if (CHECK_ADDON_1("acre_main")) then {
	[[QUOTE(PREFIX),_obj,"armoryPack"] joinString "_","Take Pack Radio",QUOTE(STATE_PACK),QUOTE(true),"",_obj,0,["ACE_MainActions"]] call FUNC(setAction);
};
