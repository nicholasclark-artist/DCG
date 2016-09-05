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
#define STATE_PACK \
	if !([player, EGVAR(radio,acre_support)] call acre_api_fnc_hasKindOfRadio) then { \
		if (player canAddItemToBackpack EGVAR(radio,acre_support)) then { \
			player addItemToBackpack EGVAR(radio,acre_support); \
			[format ['Added %1 to backpack.', [configFile >> 'cfgWeapons' >> EGVAR(radio,acre_support)] call BIS_fnc_displayName],true] call FUNC(displayText); \
			} else { \
				if ((backpack player) isEqualTo '') then { \
					player addBackpack 'B_Kitbag_cbr'; \
					player addItemToBackpack EGVAR(radio,acre_support); \
					[format ['Added %1 to backpack.', [configFile >> 'cfgWeapons' >> EGVAR(radio,acre_support)] call BIS_fnc_displayName],true] call FUNC(displayText); \
				} else { \
					['Your backpack is full.',true] call FUNC(displayText); \
				}; \
			}; \
	} else { \
		['You already have a pack radio.',true] call FUNC(displayText); \
	};
#define STATE_RADIO call EFUNC(radio,setRadio);
#define STATE_ARMORY \
	if (CHECK_ADDON_1('acre_main')) then { \
		{player removeItem _x} forEach (call acre_api_fnc_getCurrentRadioList); \
	}; \
	['Open',true] spawn FUNC(arsenal);

private _obj = _this select 0;

[format ["%1_%2_armory", QUOTE(ADDON),_obj],"Open Armory",QUOTE(STATE_ARMORY),QUOTE(true),"",_obj,0,["ACE_MainActions"]] call FUNC(setAction);

[format ["%1_%2_armoryRadio", QUOTE(ADDON),_obj],"Take Radio",QUOTE(STATE_RADIO),QUOTE(true),"",_obj,0,["ACE_MainActions"]] call FUNC(setAction);

if (CHECK_ADDON_1("acre_main")) then {
	[format ["%1_%2_armoryPack", QUOTE(ADDON),_obj],"Take Pack Radio",QUOTE(STATE_PACK),QUOTE(true),"",_obj,0,["ACE_MainActions"]] call FUNC(setAction);
};