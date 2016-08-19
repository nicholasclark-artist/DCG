/*
Author:
Nicholas Clark (SENSEI)

Description:
deploy FOB

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define ANIM toLower ("AinvPknlMstpSnonWnonDnon_medic4")
#define ANIM_TIME 9

if !([player modelToWorld [0,3,0],player,-1,0.3] call EFUNC(main,isPosSafe)) exitWith {
	[format ["Unsuitable position for %1. Select a flat, open area.",GVAR(name)],true] call EFUNC(main,displayText);
};

[player,ANIM] call EFUNC(main,setAnim);

private _entry = [TITLE, KEY_ID] call CBA_fnc_getKeybind;

if (!isNil "_entry") then {
	private _keyStr = "";
	private _key = (_entry select 5) select 0;
	private _modifiers = (_entry select 5) select 1;
	private _modArr = [];

	if (_modifiers select 0) then {
		_modArr pushBack "SHIFT";
	};
	if (_modifiers select 1) then {
		_modArr pushBack "CTRL";
	};
	if (_modifiers select 2) then {
		_modArr pushBack "ALT";
	};

	_keyStr = _modArr joinString " ";
	_keyStr = format ["%1 + %2", _keyStr,keyName _key];

	[format ["Press [%1] to start building %2.",_keyStr, GVAR(name)],true] call EFUNC(main,displayText);
};

[{
	missionNamespace setVariable [PVEH_DEPLOY,[player]];
	publicVariableServer PVEH_DEPLOY;
}, [], ANIM_TIME] call CBA_fnc_waitAndExecute;