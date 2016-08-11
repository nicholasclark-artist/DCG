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

private ["_obj","_armory_state","_radio_state","_pack_state"];

_obj = _this select 0;

_armory_state = format ["if (%1) then {{player removeItem _x} forEach (call acre_api_fnc_getCurrentRadioList);}; ['Open',true] spawn %2;",CHECK_ADDON_1("acre_main"),QFUNC(arsenal)];

_radio_state = QUOTE(call EFUNC(radio,setRadio));

_pack_state = format ["if !([player, %1] call acre_api_fnc_hasKindOfRadio) then {
		if (player canAddItemToBackpack %1) then {
			player addItemToBackpack %1;
			hintSilent format ['Added %1 to backpack.',[configFile >> 'cfgWeapons' >> %1] call BIS_fnc_displayName];
			} else {
				if ((backpack player) isEqualTo '') then {
					player addBackpack 'B_Kitbag_cbr';
					player addItemToBackpack %1;
					hintSilent format ['Added %1 to backpack.',[configFile >> 'cfgWeapons' >> %1] call BIS_fnc_displayName];
				};
			};
	} else {
		hintSilent 'You already have a pack radio.';
	};",QEGVAR(radio,acre_support)];


[format ["%1_%2_armory", QUOTE(ADDON),_obj],"Open Armory",_armory_state,QUOTE(true),"",_obj,0,["ACE_MainActions"]] call FUNC(setAction);

[format ["%1_%2_armoryRadio", QUOTE(ADDON),_obj],"Take Radio",_radio_state,QUOTE(true),"",_obj,0,["ACE_MainActions"]] call FUNC(setAction);

if (CHECK_ADDON_1("acre_main")) then {
	[format ["%1_%2_armoryPack", QUOTE(ADDON),_obj],"Take Pack Radio",_pack_state,QUOTE(true),"",_obj,0,["ACE_MainActions"]] call FUNC(setAction);
};