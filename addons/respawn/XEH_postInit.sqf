/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	INFO("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		{
			if (hasInterface && {!(CHECK_ADDON_1("ace_respawn"))}) then {
				player addEventHandler ["Killed",{
					player setVariable [UNITGEAR, getUnitLoadout player];
   					player setVariable [UNITWEAPON, [currentWeapon player, currentMuzzle player, currentWeaponMode player]];
				}];
				player addEventHandler ["Respawn",{
				    [player,player getVariable UNITGEAR,player getVariable UNITWEAPON] call FUNC(restoreLoadout);
				}];
			};
		} remoteExecCall [QUOTE(BIS_fnc_call),0,true];
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;