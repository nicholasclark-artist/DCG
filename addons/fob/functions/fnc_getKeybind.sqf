/*
Author:
Nicholas Clark (SENSEI)

Description:
get CBA keybind string

Arguments:

Return:
string
__________________________________________________________________*/
#include "script_component.hpp"

private _keyArr = [];
private _entry = [COMPONENT_NAME, BUILD_ID] call CBA_fnc_getKeybind;

if !(isNil "_entry") then {
    private _modifiers = (_entry select 5) select 1;

    if (_modifiers select 0) then {
        _keyArr pushBack "SHIFT";
    };
    if (_modifiers select 1) then {
        _keyArr pushBack "CTRL";
    };
    if (_modifiers select 2) then {
        _keyArr pushBack "ALT";
    };

    _keyArr pushBack (call compile (keyName ((_entry select 5) select 0)));
};

_keyArr joinString " "
